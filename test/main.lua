lust = require 'external.lust.lust'

require 'test.world'
require 'test.entity'

print()

if lust.errors > 0 then
    print('' .. lust.passes ' tests passed, ' .. lust.errors .. ' failed.')
else
    print('All tests passed.')
end
