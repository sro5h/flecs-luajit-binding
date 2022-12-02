lust = require 'external.lust.lust'

local ffi = require 'ffi'
ffi.cdef 'typedef struct Position { uint32_t x, y; } Position;'

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
