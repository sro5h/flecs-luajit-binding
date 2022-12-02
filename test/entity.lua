local ecs = require 'flecs'

lust.describe('Entity', function()
    local world

    lust.before(function()
        world = ecs.World()
    end)

    lust.after(function()
        world = nil
    end)

    lust.it('Should create entities', function()
        lust.expect(world:entity()).to.exist()
        lust.expect(world:entity({ name = 'Bob' })).to.exist()
    end)

    lust.it('Should add entities', function()
        local e = world:entity()
        local r = world:entity()
        local t = world:entity()

        lust.expect(world:has(e, t)).to.be(false)
        lust.expect(world:has(e, r)).to.be(false)
        lust.expect(world:has(e, r, t)).to.be(false)

        world:add(e, t)
        world:add(e, r)
        world:add(e, r, t)

        lust.expect(world:has(e, t)).to.be(true)
        lust.expect(world:has(e, r)).to.be(true)
        lust.expect(world:has(e, r, t)).to.be(true)
    end)

    lust.it('Should set and get components', function()
        local e = world:entity()
        local Position = world:component('Position')

        world:set(e, Position, { x = 1, y = 2 })

        lust.expect(world:has(e, Position)).to.be(true)

        local p = world:get(e, Position)

        lust.expect(p.x).to.be(1)
        lust.expect(p.y).to.be(2)
    end)
end)
