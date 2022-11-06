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

-- }}}

-- flecs.World {{{

local World = aux.class()

function World.__new()
    return ffi.gc(clib.ecs_init(), clib.ecs_fini)
end

-- }}}

-- flecs.init {{{

local function bind(flecs)
    flecs.World = ffi.metatype('ecs_world_t', World)
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

        bind(flecs)
    end

    return flecs
end

-- }}}

return setmetatable(flecs, { __call = init })
