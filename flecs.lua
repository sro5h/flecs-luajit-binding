local ffi = require 'ffi'

local flecs = {}
local aux = {}
local clib

-- aux {{{

function aux.class(tableOrNil)
    local table = tableOrNil or {}
    table.__index = table
    return table
end

function aux.id(first, second)
    return second and clib.ecs_make_pair(first, second) or first
end

function aux.string(string)
    return string ~= nil and ffi.string(string) or nil
end

-- }}}

-- flecs.World {{{

local World = aux.class()

function World.__new()
    return ffi.gc(clib.ecs_init(), clib.ecs_fini)
end

function World:entity(descOrNil)
    local desc = descOrNil or {}
    return clib.ecs_entity_init(self, ffi.new('ecs_entity_desc_t', desc))
end

function World:component(name, ctypeOrNil)
    local ctype = ctypeOrNil or ffi.typeof(name)
    local entity = self:entity({ name = name, symbol = name })

    return clib.ecs_component_init(self, ffi.new('ecs_component_desc_t', {
        entity = entity,
        type = { size = ffi.sizeof(ctype), alignment = ffi.alignof(ctype) },
    }))
end

function World:query(descOrNil)
    local desc = descOrNil or {}
    return clib.ecs_query_init(self, ffi.new('ecs_query_desc_t', desc))
end

function World:struct(descOrNil)
    local desc = descOrNil or {}
    return clib.ecs_struct_init(self, ffi.new('ecs_struct_desc_t', desc))
end

function World:add(entity, first, second)
    clib.ecs_add_id(self, entity, aux.id(first, second))
end

function World:remove(entity, first, second)
    clib.ecs_remove_id(self, entity, aux.id(first, second))
end

local function enable(world, entity, first, second, value)
    if first then
        clib.ecs_enable_id(world, entity, aux.id(first, second), value)
    else
        clib.ecs_enable(world, entity, value)
    end
end

function World:enable(entity, first, second)
    return enable(self, entity, first, second, true)
end

function World:disable(entity, first, second)
    return enable(self, entity, first, second, false)
end

function World:is_enabled(entity, first, second)
    return clib.ecs_is_enabled_id(self, entity, aux.id(first, second))
end

function World:clear(entity)
    clib.ecs_clear(self, entity)
end

function World:delete(entity)
    clib.ecs_delete(self, entity)
end

function World:delete_with(first, second)
    clib.ecs_delete_with(self, aux.id(first, second))
end

function World:remove_all(first, second)
    clib.ecs_remove_all(self, aux.id(first, second))
end

local function get(world, entity, symbol, first, second)
    local ctype = ffi.typeof('$ const*', ffi.typeof(symbol))
    return ffi.cast(ctype, clib.ecs_get_id(world, entity, aux.id(first, second)))
end

function World:get(entity, first, second)
    return get(self, entity, self:symbol(first), first, second)
end

function World:get_second(entity, first, second)
    return get(self, entity, self:symbol(second), first, second)
end

local function set(world, entity, symbol, first, secondOrValue, valueOrNil)
    local value = valueOrNil or secondOrValue
    local second = valueOrNil and secondOrValue or nil
    local ctype = ffi.typeof(symbol)

    if type(value) ~= 'cdata' then
        value = ffi.new(ctype, value)
    end

    clib.ecs_set_id(world, entity, aux.id(first, second), ffi.sizeof(ctype), value)
end

function World:set(entity, first, secondOrValue, valueOrNil)
    set(self, entity, self:symbol(first), first, secondOrValue, valueOrNil)
end

function World:set_second(entity, first, secondOrValue, valueOrNil)
    set(self, entity, self:symbol(second), first, secondOrValue, valueOrNil)
end

function World:modified(entity, first, second)
    clib.ecs_modified_id(self, entity, aux.id(first, second))
end

function World:is_valid(entity)
    return clib.ecs_is_valid(self, entity)
end

function World:is_alive(entity)
    return clib.ecs_is_alive(self, entity)
end

function World:ensure(entity)
    clib.ecs_ensure(self, entity)
end

function World:ensure_id(entity)
    clib.ecs_ensure_id(self, entity)
end

function World:exists(entity)
    return clib.ecs_exists(self, entity)
end

function World:name(entity)
    return aux.string(clib.ecs_get_name(self, entity))
end

function World:symbol(entity)
    return aux.string(clib.ecs_get_symbol(self, entity))
end

function World:set_name(entity, value)
    clib.ecs_set_name(self, entity, value)
end

function World:set_symbol(entity, value)
    clib.ecs_set_symbol(self, entity, value)
end

function World:set_alias(entity, value)
    clib.ecs_set_alias(self, entity, value)
end

function World:has(entity, first, second)
    return clib.ecs_has_id(self, entity, aux.id(first, second))
end

function World:get_target(entity, relationship, indexOrNil)
    local index = indexOrNil or 0
    return clib.ecs_get_target(self, entity, relationship, index)
end

function World:get_target_for(entity, relationship, id)
    return clib.ecs_get_target_for_id(self, entity, relationship, id)
end

function World:count(entity)
    return clib.ecs_count_id(self, entity)
end

function World:iter(query)
    return clib.ecs_query_iter(self, query)
end

function World:lookup(name)
    return clib.ecs_lookup(self, name)
end

-- }}}

-- flecs.Query {{{

local Query = aux.class()

function Query:is_changed()
    return clib.ecs_query_changed(self, nil)
end

function Query:is_orphaned()
    return clib.ecs_query_orphaned(self)
end

-- }}}

-- flecs.Iter {{{

local Iter = aux.class()

function Iter:world()
    return self._world
end

function Iter:entity(index)
    return self.entities[index]
end

function Iter:count()
    return self._count
end

function Iter:field_id(j)
    return clib.ecs_field_id(self, j)
end

function Iter:is_self(j)
    return clib.ecs_field_is_self(self, j)
end

function Iter:is_readonly(j)
    return clib.ecs_field_is_readonly(self, j)
end

function Iter:is_writeonly(j)
    return clib.ecs_field_is_writeonly(self, j)
end

function Iter:field(j)
    if clib.ecs_field_size(self, j) == 0 then
        return nil
    end

    local ctype = ffi.typeof(self:world():symbol(self:field_id(j)))
    local pointer = clib.ecs_field_w_size(self, ffi.sizeof(ctype), j)

    if self:is_readonly(j) then
        return ffi.cast(ffi.typeof('$ const*', ctype), pointer)
    else
        return ffi.cast(ffi.typeof('$*', ctype), pointer)
    end
end

function Iter:field_count()
    return self._field_count
end

function Iter:fields(index)
    index = index or 0
    local fields = {}

    for j = 1, self:field_count() do
        local field = self:field(j)

        if self:is_self(j) and field ~= nil then
            table.insert(fields, field + index)
        else
            table.insert(fields, field)
        end
    end

    return table.unpack(fields)
end

function Iter:each()
    local i = 0

    return function()
        i = i + 1

        if i <= self:count() then
            return self:entity(i - 1), self:fields(i - 1)
        end
    end
end

function Iter:next()
    return clib.ecs_iter_next(self)
end

function Iter:delta_time()
    return self._delta_time
end

-- }}}

-- flecs.g {{{

local function bind_g(flecs)
    flecs.g = {
        bool = clib.FLECS__Eecs_bool_t,
        char = clib.FLECS__Eecs_char_t,
        byte = clib.FLECS__Eecs_byte_t,
        u8 = clib.FLECS__Eecs_u8_t,
        u16 = clib.FLECS__Eecs_u16_t,
        u32 = clib.FLECS__Eecs_u32_t,
        u64 = clib.FLECS__Eecs_u64_t,
        uptr = clib.FLECS__Eecs_uptr_t,
        i8 = clib.FLECS__Eecs_i8_t,
        i16 = clib.FLECS__Eecs_i16_t,
        i32 = clib.FLECS__Eecs_i32_t,
        i64 = clib.FLECS__Eecs_i64_t,
        iptr = clib.FLECS__Eecs_iptr_t,
        f32 = clib.FLECS__Eecs_f32_t,
        f64 = clib.FLECS__Eecs_f64_t,
        string = clib.FLECS__Eecs_string_t,
        entity = clib.FLECS__Eecs_entity_t,
    }
end

-- }}}

-- flecs.init {{{

local function bind(flecs, options)
    if options.no_metatypes then
        flecs.World = World
        flecs.Query = Query
        flecs.Iter = Iter
    else
        flecs.World = ffi.metatype('ecs_world_t', World)
        flecs.Query = ffi.metatype('ecs_query_t', Query)
        flecs.Iter = ffi.metatype('ecs_iter_t', Iter)
    end
end

local function init(flecs, optionsOrNil)
    local options = optionsOrNil or {}

    if clib == nil then
        if options.clib then
            clib = ffi.load(options.clib)
        else
            clib = ffi.C
        end

        if options.cdef then
            ffi.cdef(options.cdef)
        end

        if options.world then
            flecs.world = ffi.cast('ecs_world_t*', options.world)
        end

        bind(flecs, options)
        bind_g(flecs)
    end

    return flecs
end

-- }}}

return setmetatable(flecs, { __call = init })
