local ecs = require 'flecs' {
    clib = 'external/flecs/build/libflecs.so',
    cdef = require 'flecs_cdef'
}

lust.describe('g', function()
    lust.it('Should have non zero ids', function()
        lust.expect(ecs.g.bool).to_not.be(0)
        lust.expect(ecs.g.char).to_not.be(0)
        lust.expect(ecs.g.byte).to_not.be(0)
        lust.expect(ecs.g.u8).to_not.be(0)
        lust.expect(ecs.g.u16).to_not.be(0)
        lust.expect(ecs.g.u32).to_not.be(0)
        lust.expect(ecs.g.u64).to_not.be(0)
        lust.expect(ecs.g.uptr).to_not.be(0)
        lust.expect(ecs.g.i8).to_not.be(0)
        lust.expect(ecs.g.i16).to_not.be(0)
        lust.expect(ecs.g.i32).to_not.be(0)
        lust.expect(ecs.g.i64).to_not.be(0)
        lust.expect(ecs.g.iptr).to_not.be(0)
        lust.expect(ecs.g.f32).to_not.be(0)
        lust.expect(ecs.g.f64).to_not.be(0)
        lust.expect(ecs.g.string).to_not.be(0)
        lust.expect(ecs.g.entity).to_not.be(0)
    end)
end)
