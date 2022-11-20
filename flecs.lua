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

function World:add(entity, first, second)
    clib.ecs_add_id(self, entity, aux.id(first, second))
end

function World:remove(entity, first, second)
    clib.ecs_remove_id(self, entity, aux.id(first, second))
end

function World:has(entity, first, second)
    return clib.ecs_has_id(self, entity, aux.id(first, second))
end

-- }}}

-- flecs.init {{{

local function bind(flecs, options)
    if options.no_metatypes then
        flecs.World = World
    else
        flecs.World = ffi.metatype('ecs_world_t', World)
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

        bind(flecs, options)
    end

    return flecs
end

-- }}}

return setmetatable(flecs, { __call = init })
