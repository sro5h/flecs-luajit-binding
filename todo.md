[ ] Add subtable `g` to `flecs` to hold global variables (e.g. global ids or
    enum values)
[ ] Add a `luajit_symbol_ref` member of type `ecs_ref_t` to components to
    efficiently get the luajit symbol for a component. Then only cast types with
    that special member to their ctype.
[x] Add a `no_metatypes` parameter that controls whether the metatables (e.g.
    flecs.World) should be bound to their ctypes using `ffi.metatype`
