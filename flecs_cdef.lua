return [[

typedef uint64_t ecs_id_t;
typedef ecs_id_t ecs_entity_t;
typedef struct ecs_world_t ecs_world_t;

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

ecs_id_t ecs_make_pair(ecs_entity_t, ecs_entity_t);

ecs_world_t* ecs_init(void);
int ecs_fini(ecs_world_t*);
ecs_entity_t ecs_entity_init(ecs_world_t*, const ecs_entity_desc_t*);
void ecs_add_id(ecs_world_t*, ecs_entity_t, ecs_id_t);
void ecs_remove_id(ecs_world_t*, ecs_entity_t, ecs_id_t);
bool ecs_has_id(const ecs_world_t*, ecs_entity_t, ecs_id_t);

]]
