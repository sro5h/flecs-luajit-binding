local ecs = require 'flecs'

lust.describe('World', function()
    local world

    lust.before(function()
        world = ecs.World()
    end)

    lust.after(function()
        world = nil
    end)

    lust.it('Should initialise', function()
        lust.expect(world).to.exist()
    end)
end)
