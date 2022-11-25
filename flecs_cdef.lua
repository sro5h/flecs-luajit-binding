return [[

typedef int32_t ecs_size_t;
typedef uint64_t ecs_id_t;
typedef ecs_id_t ecs_entity_t;
typedef struct ecs_world_t ecs_world_t;
typedef struct ecs_iter_t ecs_iter_t;
typedef struct ecs_type_info_t ecs_type_info_t;

typedef void (*ecs_iter_action_t)(ecs_iter_t*);
typedef void (*ecs_ctx_free_t)(void*);
typedef void (*ecs_xtor_t)(void*, int32_t, ecs_type_info_t const*);
typedef void (*ecs_copy_t)(void*, void const*, int32_t, ecs_type_info_t const*);
typedef void (*ecs_move_t)(void*, void*, int32_t, ecs_type_info_t const*);

typedef struct ecs_type_hooks_t {
    ecs_xtor_t ctor;
    ecs_xtor_t dtor;
    ecs_copy_t copy;
    ecs_move_t move;
    ecs_copy_t copy_ctor;
    ecs_move_t move_ctor;
    ecs_move_t ctor_move_dtor;
    ecs_move_t move_dtor;
    ecs_iter_action_t on_add;
    ecs_iter_action_t on_set;
    ecs_iter_action_t on_remove;
    void *ctx;
    void *binding_ctx;
    ecs_ctx_free_t ctx_free;
    ecs_ctx_free_t binding_ctx_free;
} ecs_type_hooks_t;

typedef struct ecs_entity_desc_t {
    int32_t _canary;
    ecs_entity_t id;
    const char *name;
    const char *sep;
    const char *root_sep;
    const char *symbol;
    bool use_low_id;
    ecs_id_t add[32]; // ECS_ID_CACHE_SIZE
    const char *add_expr;
} ecs_entity_desc_t;

struct ecs_type_info_t {
    ecs_size_t size;
    ecs_size_t alignment;
    ecs_type_hooks_t hooks;
    ecs_entity_t component;
    const char *name;
};

typedef struct ecs_component_desc_t {
    int32_t _canary;
    ecs_entity_t entity;
    ecs_type_info_t type;
} ecs_component_desc_t;

ecs_id_t ecs_make_pair(ecs_entity_t, ecs_entity_t);

ecs_world_t* ecs_init(void);
int ecs_fini(ecs_world_t*);
ecs_entity_t ecs_entity_init(ecs_world_t*, ecs_entity_desc_t const*);
ecs_entity_t ecs_component_init(ecs_world_t*, ecs_component_desc_t const*);
void ecs_add_id(ecs_world_t*, ecs_entity_t, ecs_id_t);
void ecs_remove_id(ecs_world_t*, ecs_entity_t, ecs_id_t);
void ecs_enable_id(ecs_world_t*, ecs_entity_t, ecs_id_t, bool);
bool ecs_is_enabled_id(ecs_world_t const*, ecs_entity_t, ecs_id_t);
void ecs_clear(ecs_world_t*, ecs_entity_t);
void ecs_delete(ecs_world_t*, ecs_entity_t);
void ecs_delete_with(ecs_world_t*, ecs_id_t);
void ecs_remove_all(ecs_world_t*, ecs_id_t);
void const* ecs_get_id(ecs_world_t const*, ecs_entity_t, ecs_id_t);
ecs_entity_t ecs_set_id(ecs_world_t*, ecs_entity_t, ecs_id_t, size_t, void const*);
void ecs_modified_id(ecs_world_t*, ecs_entity_t, ecs_id_t);
bool ecs_is_valid(ecs_world_t const*, ecs_entity_t);
bool ecs_is_alive(ecs_world_t const*, ecs_entity_t);
void ecs_ensure(ecs_world_t*, ecs_entity_t);
void ecs_ensure_id(ecs_world_t*, ecs_id_t);
bool ecs_exists(ecs_world_t const*, ecs_entity_t);
char const* ecs_get_name(ecs_world_t const*, ecs_entity_t);
char const* ecs_get_symbol(ecs_world_t const*, ecs_entity_t);
ecs_entity_t ecs_set_name(ecs_world_t*, ecs_entity_t, char const*);
ecs_entity_t ecs_set_symbol(ecs_world_t*, ecs_entity_t, char const*);
void ecs_set_alias(ecs_world_t*, ecs_entity_t, char const*);
bool ecs_has_id(const ecs_world_t*, ecs_entity_t, ecs_id_t);
ecs_entity_t ecs_get_target(ecs_world_t const*, ecs_entity_t, ecs_entity_t, int32_t);
ecs_entity_t ecs_get_target_for_id(ecs_world_t const*, ecs_entity_t, ecs_entity_t, ecs_id_t);
void ecs_enable(ecs_world_t*, ecs_entity_t, bool);
int32_t ecs_count_id(ecs_world_t const*, ecs_id_t);

]]
