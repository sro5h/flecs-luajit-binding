package.path = package.path .. ';external/lust/?.lua'
require 'flecs' {
    clib = 'external/flecs/build/libflecs.so',
    cdef = require 'flecs_cdef',
    bind_metatypes = true,
}

lust = require 'lust'

local ffi = require 'ffi'
ffi.cdef 'typedef struct Position { uint32_t x, y; } Position;'

require 'test.aux'
require 'test.world'
require 'test.entity'
require 'test.query'
require 'test.struct'
require 'test.g'

print()

if lust.errors > 0 then
    print('' .. lust.passes .. ' tests passed, ' .. lust.errors .. ' failed.')
else
    print('All tests passed.')
end
