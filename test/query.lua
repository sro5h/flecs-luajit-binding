local ecs = require 'flecs' {
    clib = 'external/flecs/build/libflecs.so',
    cdef = require 'flecs_cdef'
}

lust.describe('Query', function()
    local world

    lust.before(function()
        world = ecs.World()
    end)

    lust.after(function()
        world = nil
    end)

    lust.it('Should iterate query', function()
        local e1 = world:entity()
        local e2 = world:entity()
        local t = world:entity()
        local Position = world:component('Position')

        world:set(e1, Position, { x = 1, y = 2 })
        world:set(e2, Position, { x = 11, y = 42 })
        world:add(e2, t)

        local query = world:query({ filter = { expr = 'Position' } })
        local iter = world:iter(query)

        --[[while iter:next() do
            print('next()')
            for i = 0, iter:count() - 1 do
                local e = iter:entity(i)
                local position = iter:fields(i)]]
        while iter:next() do
            for e, position in iter:each() do
                lust.expect(e).to.exist()
                lust.expect(position).to.exist()

                position.x = position.x + 1
            end
        end

        lust.expect(world:get(e1, Position).x).to.be(2)
        lust.expect(world:get(e1, Position).y).to.be(2)
        lust.expect(world:get(e2, Position).x).to.be(12)
        lust.expect(world:get(e2, Position).y).to.be(42)
    end)
end)
