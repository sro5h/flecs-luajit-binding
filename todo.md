- Rename `flecs_cdef.lua` to `flecs.cdef.lua`
- Implement `ecs_luajit_struct_cdef` in Lua and add `flecs.World:ctype` to
  register a struct as a ctype
- If any defines must be used, assert their value in `gen_cdef.py`
- Use libclang to transform the flecs headers to strip unused declarations
- Expose `aux` table and its functions as `flecs.aux`
- Add `flecs.World:struct` function and ids of `ecs_{u,i}_{8,16,32,64}_t` types
  (and others) to `flecs.g` table.
- Add subtable `g` to `flecs` to hold global variables (e.g. global ids or enum
  values).
- Add a `luajit_symbol_ref` member of type `ecs_ref_t` to components to
  efficiently get the luajit symbol for a component. Then only cast types with
  that special member to their ctype.
