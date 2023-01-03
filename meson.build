project(
  'flecs-luajit-binding',
  version: '0.1.0',
  license: 'mit',
)

srcs_flecs_lua = files('flecs.lua')
srcs = [ srcs_flecs_lua, files('flecs_cdef.lua', 'flecs_cdef.json') ]

generate_cdef = find_program('scripts/generate_cdef.py')

custom_target(
  'generate-cdef',
  input: [
    'flecs_cdef.json',
  ],
  output: [
    'flecs_cdef.lua',
  ],
  command: [
    generate_cdef,
    '-i', '@INPUT@',
    '-o', '@SOURCE_ROOT@/@OUTPUT@',
  ],
  build_by_default: true,
)
