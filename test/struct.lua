local ecs = require 'flecs'

lust.describe('Struct', function()
    local world

    lust.before(function()
        world = ecs.World()
    end)

    lust.after(function()
        world = nil
    end)

    lust.it('Should create struct', function()
        local Position = world:struct({
            name = 'Position',
            members = {
                { name = 'x', type = ecs.g.f32 },
                { name = 'y', type = ecs.g.f32 },
            },
        })

        lust.expect(Position).to.exist()
    end)
end)
