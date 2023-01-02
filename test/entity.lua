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
        lust.expect(world:entity()).to_not.be(0)
        lust.expect(world:entity({ name = 'Bob' })).to_not.be(0)
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
        local Position = world:component({
            entity = world:entity({ name = 'Position', symbol = 'Position' }),
            ctype = 'Position',
        })

        world:set(e, Position, { x = 1, y = 2 })

        lust.expect(world:has(e, Position)).to.be(true)

        local p = world:get(e, Position)

        lust.expect(p.x).to.be(1)
        lust.expect(p.y).to.be(2)
    end)

    lust.it('Should return identifier', function()
        local e1 = world:entity()
        local e2 = world:entity({ name = 'Bob' })
        local e3 = world:entity({ symbol = 'Alice' })
        local e4 = world:entity({ name = 'Otto', symbol = 'Forster' })

        lust.expect(world:identifier(e1)).to.be(nil)
        lust.expect(world:identifier(e2)).to.be('Bob')
        lust.expect(world:identifier(e3)).to.be('Alice')
        lust.expect(world:identifier(e4)).to.be('Forster')
    end)

    lust.it('Should lookup entities', function()
        local e = world:entity({ name = 'Velocity' })

        lust.expect(e).to_not.be(0)
        lust.expect(world:lookup('Velocity')).to_not.be(0)
    end)
end)
