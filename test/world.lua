local flecs = require 'flecs' {
    clib = 'external/flecs/build/libflecs.so',
    cdef = require 'flecs_cdef',
}

lust.describe('World', function()
    local world

    lust.before(function()
        world = flecs.World()
    end)

    lust.after(function()
        world = nil
    end)

    lust.it('should initialise', function()
        lust.expect(world).to.exist()
    end)
end)
