local ecs = require 'flecs'
local aux = ecs.aux

lust.describe('Aux', function()
    lust.it('aux.len basics', function()
        lust.expect(aux.len({ 5 })).to.be(1)
        lust.expect(aux.len({ 5, 6 })).to.be(2)
        lust.expect(aux.len({ 5, [3] = 6 })).to.be(1)
        lust.expect(aux.len({ [0] = 5 })).to.be(1)
        lust.expect(aux.len({ [0] = 5, [1] = 6 })).to.be(2)
        lust.expect(aux.len({ [0] = 5, [2] = 6 })).to.be(1)
    end)

    lust.it('aux.fix_array basics', function()
        aux.fix_array(nil)

        local array = { 5 }
        aux.fix_array(array, 0)

        lust.expect(array[0]).to.be(nil)
        lust.expect(array[1]).to.be(5)
        lust.expect(array[2]).to.be(0)
        lust.expect(array[3]).to.be(nil)

        local array = { 23, 11 }
        aux.fix_array(array, 0)

        lust.expect(array[0]).to.be(nil)
        lust.expect(array[1]).to.be(23)
        lust.expect(array[2]).to.be(11)
        lust.expect(array[3]).to.be(nil)

        local array = { [0] = 11 }
        aux.fix_array(array, 0)

        lust.expect(array[0]).to.be(11)
        lust.expect(array[1]).to.be(0)
        lust.expect(array[2]).to.be(nil)

        local array = { [0] = 11, [1] = 38 }
        aux.fix_array(array, 0)

        lust.expect(array[0]).to.be(11)
        lust.expect(array[1]).to.be(38)
        lust.expect(array[2]).to.be(nil)
    end)
end)
