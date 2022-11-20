local ecs = require 'flecs' {
    clib = 'external/flecs/build/libflecs.so',
    cdef = require 'flecs_cdef'
}

lust.describe('Entity', function()
    local world

    lust.before(function()
        world = ecs.World()
    end)

    lust.after(function()
        world = nil
    end)

    lust.it('should create entities', function()
        lust.expect(world:entity()).to.exist()
        lust.expect(world:entity({ name = 'Bob' })).to.exist()
    end)
end)
