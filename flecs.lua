local ffi = require 'ffi'

local flecs = {}
local aux = {}
local clib

-- aux {{{

flecs.aux = aux

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

function aux.free(pointer)
    clib.ecs_os_api.free_(pointer)
end

function aux.len(array)
    local result = 1
    while array[result] ~= nil do
        result = result + 1
    end

    return array[0] == nil and result - 1 or result
end

-- Used to fix arrays that are passed to `ffi.new` as initialisers as LuaJIT
-- repeats single elements
function aux.fix_array(array, init)
    if array ~= nil and aux.len(array) == 1 then
        table.insert(array, init)
    end
end

-- }}}

-- flecs {{{

function flecs.pair(first, second)
    return aux.id(first, second)
end

-- }}}

-- flecs.World {{{

local World = aux.class()
flecs.World = World

function World.__new()
    return ffi.gc(clib.ecs_init(), clib.ecs_fini)
end

-- Group world_frame

function World:quit()
    clib.ecs_quit(self)
end

function World:should_quit()
    return clib.ecs_should_quit(self)
end

function World:set_target_fps(value)
    clib.ecs_set_target_fps(value)
end

-- Group creating_entities

function World:entity(descOrNil)
    local desc = descOrNil or {}
    aux.fix_array(desc.add, 0)

    return clib.ecs_entity_init(self, ffi.new('ecs_entity_desc_t', desc))
end

function World:component(desc)
    local ctype = desc.ctype or ffi.typeof(world:identifier(desc.entity))

    return clib.ecs_component_init(self, ffi.new('ecs_component_desc_t', {
        entity = desc.entity,
        type = { size = ffi.sizeof(ctype), alignment = ffi.alignof(ctype) },
    }))
end

function World:clone(dstOrNil, src, copy)
    local dst = dstOrNil

    if copy == nil then
        dst = nil
        src = dstOrNil
        copy = src
    end

    return clib.ecs_clone(self, dst, src, copy)
end

-- Group adding_removing

function World:add(entity, first, second)
    clib.ecs_add_id(self, entity, aux.id(first, second))
end

function World:remove(entity, first, second)
    clib.ecs_remove_id(self, entity, aux.id(first, second))
end

function World:override(entity, first, second)
    clib.ecs_override_id(self, entity, aux.id(first, second))
end

-- Group enabling_disabling

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

-- Group deleting

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

-- Group getting

local function get(world, entity, symbol, first, second)
    local ctype = ffi.typeof('$ const*', ffi.typeof(symbol))
    return ffi.cast(ctype, clib.ecs_get_id(world, entity, aux.id(first, second)))
end

function World:get(entity, first, second)
    return get(self, entity, self:identifier(first), first, second)
end

function World:get_second(entity, first, second)
    return get(self, entity, self:identifier(second), first, second)
end

-- Group setting

local function get_mut(world, entity, symbol, first, second)
    local ctype = ffi.typeof('$*', ffi.typeof(symbol))
    return ffi.cast(ctype, clib.ecs_get_mut_id(world, entity, aux.id(first, second)))
end

function World:get_mut(entity, first, second)
    return get_mut(self, entity, self:identifier(first), first, second)
end

function World:get_mut_second(entity, first, second)
    return get_mut(self, entity, self:identifier(second), first, second)
end

local function emplace(world, entity, symbol, first, second)
    local ctype = ffi.typeof('$*', ffi.typeof(symbol))
    return ffi.cast(ctype, clib.ecs_emplace_id(world, entity, aux.id(first, second)))
end

function World:emplace(entity, first, second)
    return emplace(self, entity, self:identifier(first), first, second)
end

function World:emplace_second(entity, first, second)
    return emplace(self, entity, self:identifier(second), first, second)
end

function World:modified(entity, first, second)
    clib.ecs_modified_id(self, entity, aux.id(first, second))
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
    set(self, entity, self:identifier(first), first, secondOrValue, valueOrNil)
end

function World:set_second(entity, first, secondOrValue, valueOrNil)
    set(self, entity, self:identifier(second), first, secondOrValue, valueOrNil)
end

-- Group metadata

function World:is_valid(entity)
    return clib.ecs_is_valid(self, entity)
end

function World:is_alive(entity)
    return clib.ecs_is_alive(self, entity)
end

function World:alive(entity)
    return clib.ecs_get_alive(self, entity)
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

function World:typeid(entity)
    return clib.ecs_get_typeid(self, entity)
end

function World:is_tag(entity)
    return clib.ecs_id_is_tag(self, entity)
end

function World:is_in_use(entity)
    return clib.ecs_id_in_use(self, entity)
end

function World:name(entity)
    return aux.string(clib.ecs_get_name(self, entity))
end

function World:symbol(entity)
    return aux.string(clib.ecs_get_symbol(self, entity))
end

function World:identifier(entity)
    return self:symbol(entity) or self:name(entity)
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

-- Group lookup

function World:lookup(parentOrNil, name)
    local parent = name and parentOrNil or 0
    name = name or parentOrNil

    return clib.ecs_lookup_child(self, parent, name)
end

function World:lookup_path(parentOrNil, path)
    local parent = path and parentOrNil or 0
    path = path or parentOrNil

    return clib.ecs_lookup_path_w_sep(self, parent, path, '.', nil, true)
end

function World:lookup_symbol(symbol, lookup_as_path)
    return clib.ecs_lookup_symbol(self, symbol, lookup_as_path)
end

-- Group paths

function World:get_path(parentOrNil, child)
    local parent = child and parentOrNil or 0
    child = child or parentOrNil

    return aux.string(ffi.gc(
        clib.ecs_get_path_w_sep(self, parent, child, '.', nil),
        aux.free
    ))
end

-- Group scopes

function World:set_scope(entity)
    return clib.ecs_set_scope(self, entity)
end

function World:scope()
    return clib.ecs_get_scope(self)
end

function World:set_with(entity)
    return clib.ecs_set_with(self, entity)
end

function World:with()
    return clib.ecs_get_with(self)
end

function World:set_name_prefix(value)
    return aux.string(clib.ecs_set_name_prefix(self, value))
end

-- Group filters

function World:filter(descOrNil)
    local desc = descOrNil or {}
    aux.fix_array(desc.terms, {})

    return ffi.gc(
        clib.ecs_filter_init(self, ffi.new('ecs_filter_desc_t', desc)),
        clib.ecs_filter_fini
    )
end

-- Group queries

function World:query(descOrNil)
    local desc = descOrNil or {}
    aux.fix_array(desc.filter.terms, {})

    return clib.ecs_query_init(self, ffi.new('ecs_query_desc_t', desc))
end

-- Group iterators

function World:iter(iterable)
    if ffi.istype('ecs_filter_t', iterable) then
        return clib.ecs_filter_iter(self, iterable)
    elseif ffi.istype('ecs_query_t', iterable) then
        return clib.ecs_query_iter(self, iterable)
    end
end

-- Group staging

function World:defer_begin()
    return clib.ecs_defer_begin(self)
end

function World:is_deferred()
    return clib.ecs_is_deferred(self)
end

function World:defer_end()
    return clib.ecs_defer_end(self)
end

function World:defer_suspend()
    return clib.ecs_defer_suspend(self)
end

function World:defer_resume()
    return clib.ecs_defer_resume(self)
end

function World:is_readonly()
    return clib.ecs_stage_is_readonly(self)
end

function World:is_async()
    return clib.ecs_stage_is_async(self)
end

function World:struct(descOrNil)
    local desc = descOrNil or {}
    aux.fix_array(desc.members, {})

    return clib.ecs_struct_init(self, ffi.new('ecs_struct_desc_t', desc))
end

-- }}}

-- flecs.Filter {{{

local Filter = aux.class()
flecs.Filter = Filter

function Filter:find_this_var()
    return clib.ecs_filter_find_this_var(self)
end

function Filter:term_count()
    return self._term_count
end

function Filter:field_count()
    return self._field_count
end

function Filter:is_owned()
    return self._owned
end

function Filter:is_terms_owned()
    return self._terms_owned
end

function Filter:flags()
    return self._flags
end

function Filter:name()
    return aux.string(self._name)
end

-- }}}

-- flecs.Query {{{

local Query = aux.class()
flecs.Query = Query

function Query:filter()
    return clib.ecs_query_get_filter(self)
end

function Query:is_changed()
    return clib.ecs_query_changed(self, nil)
end

function Query:is_orphaned()
    return clib.ecs_query_orphaned(self)
end

function Query:count()
    return clib.ecs_query_entity_count(self)
end

function Query:entity()
    return clib.ecs_query_entity(self)
end

-- }}}

-- flecs.Iter {{{

local Iter = aux.class()
flecs.Iter = Iter

function Iter:is_true()
    return clib.ecs_iter_is_true(self)
end

function Iter:first()
    return clib.ecs_iter_first(self)
end

function Iter:world()
    return self._world
end

function Iter:entity(index)
    return self._entities[index]
end

function Iter:system()
    return self._system
end

function Iter:count()
    return self._count
end

function Iter:field_is_readonly(j)
    return clib.ecs_field_is_readonly(self, j)
end

function Iter:field_is_writeonly(j)
    return clib.ecs_field_is_writeonly(self, j)
end

function Iter:field_is_set(j)
    return clib.ecs_field_is_set(self, j)
end

function Iter:field_id(j)
    return clib.ecs_field_id(self, j)
end

function Iter:field_src(j)
    return clib.ecs_field_src(self, j)
end

function Iter:field_size(j)
    return clib.ecs_field_size(self, j)
end

function Iter:field_is_self(j)
    return clib.ecs_field_is_self(self, j)
end

function Iter:field(j)
    if clib.ecs_field_size(self, j) == 0 then
        return nil
    end

    local ctype = ffi.typeof(self:world():identifier(self:field_id(j)))
    local pointer = clib.ecs_field_w_size(self, ffi.sizeof(ctype), j)

    if self:field_is_readonly(j) then
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

        if self:field_is_self(j) and field ~= nil then
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

function Iter:fini()
    return clib.ecs_iter_fini(self)
end

function Iter:delta_time()
    return self._delta_time
end

-- }}}

-- flecs.g {{{

local function bind_g(flecs)
    flecs.g = {
        MetaTypeSerialized = clib.FLECS__EEcsMetaTypeSerialized,
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
        OpArray = clib.EcsOpArray,
        OpVector = clib.EcsOpVector,
        OpPush = clib.EcsOpPush,
        OpPop = clib.EcsOpPop,
        OpScope = clib.EcsOpScope,
        OpEnum = clib.EcsOpEnum,
        OpBitmask = clib.EcsOpBitmask,
        OpPrimitive = clib.EcsOpPrimitive,
        OpBool = clib.EcsOpBool,
        OpChar = clib.EcsOpChar,
        OpByte = clib.EcsOpByte,
        OpU8 = clib.EcsOpU8,
        OpU16 = clib.EcsOpU16,
        OpU32 = clib.EcsOpU32,
        OpU64 = clib.EcsOpU64,
        OpI8 = clib.EcsOpI8,
        OpI16 = clib.EcsOpI16,
        OpI32 = clib.EcsOpI32,
        OpI64 = clib.EcsOpI64,
        OpF32 = clib.EcsOpF32,
        OpF64 = clib.EcsOpF64,
        OpUPtr = clib.EcsOpUPtr,
        OpIPtr = clib.EcsOpIPtr,
        OpString = clib.EcsOpString,
        OpEntity = clib.EcsOpEntity,
        -- Builtin component ids
        Component = clib.FLECS__EEcsComponent,
        Identifier = clib.FLECS__EEcsIdentifier,
        Iterable = clib.FLECS__EEcsIterable,
        Poly = clib.FLECS__EEcsPoly,
        Query = clib.EcsQuery,
        Observer = clib.EcsObserver,
        System = clib.EcsSystem,
        TickSource = clib.FLECS__EEcsTickSource,
        Timer = clib.FLECS__EEcsTimer,
        RateFilter = clib.FLECS__EEcsRateFilter,
        Flecs = clib.EcsFlecs,
        FlecsCore = clib.EcsFlecsCore,
        World = clib.EcsWorld,
        Wildcard = clib.EcsWildcard,
        Any = clib.EcsAny,
        This = clib.EcsThis,
        Variable = clib.EcsVariable,
        Transitive = clib.EcsTransitive,
        Reflexive = clib.EcsReflexive,
        Final = clib.EcsFinal,
        DontInherit = clib.EcsDontInherit,
        Symmetric = clib.EcsSymmetric,
        Exclusive = clib.EcsExclusive,
        Acyclic = clib.EcsAcyclic,
        With = clib.EcsWith,
        OneOf = clib.EcsOneOf,
        Tag = clib.EcsTag,
        Union = clib.EcsUnion,
        Name = clib.EcsName,
        Symbol = clib.EcsSymbol,
        Alias = clib.EcsAlias,
        ChildOf = clib.EcsChildOf,
        IsA = clib.EcsIsA,
        DependsOn = clib.EcsDependsOn,
        SlotOf = clib.EcsSlotOf,
        Module = clib.EcsModule,
        Private = clib.EcsPrivate,
        Prefab = clib.EcsPrefab,
        Disabled = clib.EcsDisabled,
        OnAdd = clib.EcsOnAdd,
        OnRemove = clib.EcsOnRemove,
        OnSet = clib.EcsOnSet,
        UnSet = clib.EcsUnSet,
        Monitor = clib.EcsMonitor,
        OnDelete = clib.EcsOnDelete,
        OnTableEmpty = clib.EcsOnTableEmpty,
        OnTableFill = clib.EcsOnTableFill,
        OnDeleteTarget = clib.EcsOnDeleteTarget,
        Remove = clib.EcsRemove,
        Delete = clib.EcsDelete,
        Panic = clib.EcsPanic,
        DefaultChildComponent = clib.EcsDefaultChildComponent,
        Empty = clib.EcsEmpty,
        Pipeline = clib.FLECS__EEcsPipeline,
        PreFrame = clib.EcsPreFrame,
        OnLoad = clib.EcsOnLoad,
        PostLoad = clib.EcsPostLoad,
        PreUpdate = clib.EcsPreUpdate,
        OnUpdate = clib.EcsOnUpdate,
        OnValidate = clib.EcsOnValidate,
        PostUpdate = clib.EcsPostUpdate,
        PreStore = clib.EcsPreStore,
        OnStore = clib.EcsOnStore,
        PostFrame = clib.EcsPostFrame,
        Phase = clib.EcsPhase,
    }
end

-- }}}

-- flecs.init {{{

function flecs:bind_metatypes()
    self.World = ffi.metatype('ecs_world_t', World)
    self.Query = ffi.metatype('ecs_query_t', Query)
    self.Filter = ffi.metatype('ecs_filter_t', Filter)
    self.Iter = ffi.metatype('ecs_iter_t', Iter)
end

function flecs:init(optionsOrNil)
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
            self.world = ffi.cast('ecs_world_t*', options.world)
        end

        if options.bind_metatypes then
            self:bind_metatypes(options)
        end

        bind_g(self)
    end

    return self
end

-- }}}

return setmetatable(flecs, { __call = flecs.init })
