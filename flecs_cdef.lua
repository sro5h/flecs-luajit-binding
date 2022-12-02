return [[

typedef uint8_t ecs_flags8_t;
typedef uint32_t ecs_flags32_t;
typedef uint64_t ecs_flags64_t;
typedef float ecs_float_t;
typedef ecs_float_t ecs_ftime_t;
typedef int32_t ecs_size_t;
typedef uint64_t ecs_id_t;
typedef ecs_id_t ecs_entity_t;
typedef struct ecs_world_t ecs_world_t;
typedef struct ecs_filter_t ecs_filter_t;
typedef struct ecs_query_t ecs_query_t;
typedef struct ecs_rule_t ecs_rule_t;
typedef struct ecs_iter_t ecs_iter_t;
typedef struct ecs_id_record_t ecs_id_record_t;
typedef struct ecs_type_info_t ecs_type_info_t;
typedef struct ecs_table_t ecs_table_t;
typedef struct ecs_query_table_node_t ecs_query_table_node_t;
typedef struct ecs_vector_t ecs_vector_t;
typedef struct ecs_mixins_t ecs_mixins_t;
typedef struct ecs_poly_t ecs_poly_t;
typedef struct ecs_term_t ecs_term_t;
typedef struct ecs_var_t ecs_var_t;
typedef struct ecs_ref_t ecs_ref_t;
// Meta typedefs
typedef bool ecs_bool_t;
typedef char ecs_char_t;
typedef unsigned char ecs_byte_t;
typedef uint8_t ecs_u8_t;
typedef uint16_t ecs_u16_t;
typedef uint32_t ecs_u32_t;
typedef uint64_t ecs_u64_t;
typedef uintptr_t ecs_uptr_t;
typedef int8_t ecs_i8_t;
typedef int16_t ecs_i16_t;
typedef int32_t ecs_i32_t;
typedef int64_t ecs_i64_t;
typedef intptr_t ecs_iptr_t;
typedef float ecs_f32_t;
typedef double ecs_f64_t;
typedef char* ecs_string_t;

// Ids
extern const ecs_entity_t FLECS__Eecs_bool_t;
extern const ecs_entity_t FLECS__Eecs_char_t;
extern const ecs_entity_t FLECS__Eecs_byte_t;
extern const ecs_entity_t FLECS__Eecs_u8_t;
extern const ecs_entity_t FLECS__Eecs_u16_t;
extern const ecs_entity_t FLECS__Eecs_u32_t;
extern const ecs_entity_t FLECS__Eecs_u64_t;
extern const ecs_entity_t FLECS__Eecs_uptr_t;
extern const ecs_entity_t FLECS__Eecs_i8_t;
extern const ecs_entity_t FLECS__Eecs_i16_t;
extern const ecs_entity_t FLECS__Eecs_i32_t;
extern const ecs_entity_t FLECS__Eecs_i64_t;
extern const ecs_entity_t FLECS__Eecs_iptr_t;
extern const ecs_entity_t FLECS__Eecs_f32_t;
extern const ecs_entity_t FLECS__Eecs_f64_t;
extern const ecs_entity_t FLECS__Eecs_string_t;
extern const ecs_entity_t FLECS__Eecs_entity_t;

typedef void (*ecs_iter_action_t)(ecs_iter_t*);
typedef void (*ecs_iter_init_action_t)(ecs_world_t const*, ecs_poly_t const*, ecs_iter_t*, ecs_term_t*);
typedef bool (*ecs_iter_next_action_t)(ecs_iter_t*);
typedef void (*ecs_iter_fini_action_t)(ecs_iter_t*);
typedef int (*ecs_order_by_action_t)(ecs_entity_t, void const*, ecs_entity_t, void const*);
typedef void (*ecs_sort_table_action_t)(ecs_world_t*, ecs_table_t*, ecs_entity_t*, void*, int32_t, int32_t, int32_t, ecs_order_by_action_t);
typedef uint64_t (*ecs_group_by_action_t)(ecs_world_t*, ecs_table_t*, ecs_id_t, void*);
typedef void* (*ecs_group_create_action_t)(ecs_world_t*, uint64_t, void*);
typedef void (*ecs_group_delete_action_t)(ecs_world_t*, uint64_t, void*, void*);
typedef void (*ecs_ctx_free_t)(void*);
typedef void (*ecs_xtor_t)(void*, int32_t, ecs_type_info_t const*);
typedef void (*ecs_copy_t)(void*, void const*, int32_t, ecs_type_info_t const*);
typedef void (*ecs_move_t)(void*, void*, int32_t, ecs_type_info_t const*);

typedef struct ecs_entity_desc_t {
    int32_t _canary;
    ecs_entity_t id;
    char const* name;
    char const* sep;
    char const* root_sep;
    char const* symbol;
    bool use_low_id;
    ecs_id_t add[32]; // ECS_ID_CACHE_SIZE
    char const* add_expr;
} ecs_entity_desc_t;

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
    void* ctx;
    void* binding_ctx;
    ecs_ctx_free_t ctx_free;
    ecs_ctx_free_t binding_ctx_free;
} ecs_type_hooks_t;

struct ecs_type_info_t {
    ecs_size_t size;
    ecs_size_t alignment;
    ecs_type_hooks_t hooks;
    ecs_entity_t component;
    char const* name;
};

typedef struct ecs_component_desc_t {
    int32_t _canary;
    ecs_entity_t entity;
    ecs_type_info_t type;
} ecs_component_desc_t;

typedef struct ecs_term_id_t {
    ecs_entity_t id;
    char* name;
    ecs_entity_t trav;
    ecs_flags32_t flags;
} ecs_term_id_t;

typedef enum ecs_inout_kind_t {
    EcsInOutDefault,
    EcsInOutNone,
    EcsInOut,
    EcsIn,
    EcsOut,
} ecs_inout_kind_t;

typedef enum ecs_oper_kind_t {
    EcsAnd,
    EcsOr,
    EcsNot,
    EcsOptional,
    EcsAndFrom,
    EcsOrFrom,
    EcsNotFrom
} ecs_oper_kind_t;

typedef struct ecs_term_t {
    ecs_id_t id;
    ecs_term_id_t src;
    ecs_term_id_t first;
    ecs_term_id_t second;
    ecs_inout_kind_t inout;
    ecs_oper_kind_t oper;
    ecs_id_t id_flags;
    char* name;
    int32_t field_index;
    ecs_id_record_t* idr;
    bool move;
} ecs_term_t;

typedef struct ecs_header_t {
    int32_t magic;
    int32_t type;
    ecs_mixins_t* mixins;
} ecs_header_t;

typedef struct ecs_iterable_t {
    ecs_iter_init_action_t init;
} ecs_iterable_t;

typedef struct ecs_filter_t {
    ecs_header_t hdr;
    ecs_term_t* terms;
    int32_t term_count;
    int32_t field_count;
    bool owned;
    bool terms_owned;
    ecs_flags32_t flags;
    char* name;
    char* variable_names[1];
    ecs_iterable_t iterable;
} ecs_filter_t;

typedef struct ecs_filter_desc_t {
    int32_t _canary;
    ecs_term_t terms[16]; // ECS_TERM_DESC_CACHE_SIZE
    ecs_term_t* terms_buffer;
    int32_t terms_buffer_count;
    ecs_filter_t* storage;
    bool instanced;
    ecs_flags32_t flags;
    char const* expr;
    char const* name;
} ecs_filter_desc_t;

typedef struct ecs_query_desc_t {
    int32_t _canary;
    ecs_filter_desc_t filter;
    ecs_entity_t order_by_component;
    ecs_order_by_action_t order_by;
    ecs_sort_table_action_t sort_table;
    ecs_id_t group_by_id;
    ecs_group_by_action_t group_by;
    ecs_group_create_action_t on_group_create;
    ecs_group_delete_action_t on_group_delete;
    void* group_by_ctx;
    ecs_ctx_free_t group_by_ctx_free;
    ecs_query_t* parent;
    ecs_entity_t entity;
} ecs_query_desc_t;

typedef struct ecs_member_t {
    char const *name;
    ecs_entity_t type;
    int32_t count;
    int32_t offset;
    ecs_entity_t unit;
    ecs_size_t size;
    ecs_entity_t member;
} ecs_member_t;

typedef struct ecs_struct_desc_t {
    ecs_entity_t entity;
    ecs_member_t members[32]; // ECS_MEMBER_DESC_CACHE_SIZE
} ecs_struct_desc_t;

typedef struct ecs_stack_cursor_t {
    struct ecs_stack_page_t* cur;
    int16_t sp;
} ecs_stack_cursor_t;

typedef struct ecs_iter_cache_t {
    ecs_stack_cursor_t stack_cursor;
    ecs_flags8_t used;
    ecs_flags8_t allocated;
} ecs_iter_cache_t;

typedef struct ecs_table_cache_iter_t {
    struct ecs_table_cache_hdr_t *cur, *next;
    struct ecs_table_cache_hdr_t *next_list;
} ecs_table_cache_iter_t;

typedef struct ecs_term_iter_t {
    ecs_term_t term;
    ecs_id_record_t* self_index;
    ecs_id_record_t* set_index;
    ecs_id_record_t* cur;
    ecs_table_cache_iter_t it;
    int32_t index;
    int32_t observed_table_count;
    ecs_table_t* table;
    int32_t cur_match;
    int32_t match_count;
    int32_t last_column;
    bool empty_tables;
    ecs_id_t id;
    int32_t column;
    ecs_entity_t subject;
    ecs_size_t size;
    void* ptr;
} ecs_term_iter_t;

typedef enum ecs_iter_kind_t {
    EcsIterEvalCondition,
    EcsIterEvalTables,
    EcsIterEvalChain,
    EcsIterEvalNone
} ecs_iter_kind_t;

typedef struct ecs_filter_iter_t {
    ecs_filter_t const* filter;
    ecs_iter_kind_t kind;
    ecs_term_iter_t term_iter;
    int32_t matches_left;
    int32_t pivot_term;
} ecs_filter_iter_t;

typedef struct ecs_query_iter_t {
    ecs_query_t* query;
    ecs_query_table_node_t *node, *prev, *last;
    int32_t sparse_smallest;
    int32_t sparse_first;
    int32_t bitset_first;
    int32_t skip_count;
} ecs_query_iter_t;

typedef struct ecs_rule_iter_t {
    ecs_rule_t const* rule;
    struct ecs_var_t* registers;
    struct ecs_rule_op_ctx_t* op_ctx;
    int32_t* columns;
    ecs_entity_t entity;
    bool redo;
    int32_t op;
    int32_t sp;
} ecs_rule_iter_t;

typedef struct ecs_snapshot_iter_t {
    ecs_filter_t filter;
    ecs_vector_t* tables;
    int32_t index;
} ecs_snapshot_iter_t;

typedef struct ecs_page_iter_t {
    int32_t offset;
    int32_t limit;
    int32_t remaining;
} ecs_page_iter_t;

typedef struct ecs_worker_iter_t {
    int32_t index;
    int32_t count;
} ecs_worker_iter_t;

typedef struct ecs_iter_private_t {
    union {
        ecs_term_iter_t term;
        ecs_filter_iter_t filter;
        ecs_query_iter_t query;
        ecs_rule_iter_t rule;
        ecs_snapshot_iter_t snapshot;
        ecs_page_iter_t page;
        ecs_worker_iter_t worker;
    } iter;
    ecs_iter_cache_t cache;
} ecs_iter_private_t;

struct ecs_iter_t {
    ecs_world_t *_world;
    ecs_world_t *real_world;
    ecs_entity_t *entities;
    void **ptrs;
    ecs_size_t *sizes;
    ecs_table_t *table;
    ecs_table_t *other_table;
    ecs_id_t *ids;
    ecs_var_t *variables;
    int32_t *columns;
    ecs_entity_t *sources;
    int32_t *match_indices;
    ecs_ref_t *references;
    ecs_flags64_t constrained_vars;
    uint64_t group_id;
    int32_t _field_count;
    ecs_entity_t system;
    ecs_entity_t event;
    ecs_id_t event_id;
    ecs_term_t *terms;
    int32_t table_count;
    int32_t term_index;
    int32_t variable_count;
    char **variable_names;
    void *param;
    void *ctx;
    void *binding_ctx;
    ecs_ftime_t _delta_time;
    ecs_ftime_t delta_system_time;
    int32_t frame_offset;
    int32_t offset;
    int32_t _count;
    int32_t instance_count;
    ecs_flags32_t flags;
    ecs_entity_t interrupted_by;
    ecs_iter_private_t priv;
    ecs_iter_next_action_t next;
    ecs_iter_action_t callback;
    ecs_iter_fini_action_t fini;
    ecs_iter_t *chain_it;
};

ecs_id_t ecs_make_pair(ecs_entity_t, ecs_entity_t);

ecs_world_t* ecs_init(void);
int ecs_fini(ecs_world_t*);
ecs_entity_t ecs_entity_init(ecs_world_t*, ecs_entity_desc_t const*);
ecs_entity_t ecs_component_init(ecs_world_t*, ecs_component_desc_t const*);
ecs_query_t* ecs_query_init(ecs_world_t*, ecs_query_desc_t const*);
ecs_entity_t ecs_struct_init(ecs_world_t*, ecs_struct_desc_t const*);
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
bool ecs_has_id(ecs_world_t const*, ecs_entity_t, ecs_id_t);
ecs_entity_t ecs_get_target(ecs_world_t const*, ecs_entity_t, ecs_entity_t, int32_t);
ecs_entity_t ecs_get_target_for_id(ecs_world_t const*, ecs_entity_t, ecs_entity_t, ecs_id_t);
void ecs_enable(ecs_world_t*, ecs_entity_t, bool);
int32_t ecs_count_id(ecs_world_t const*, ecs_id_t);
ecs_iter_t ecs_query_iter(ecs_world_t const*, ecs_query_t*);
bool ecs_query_changed(ecs_query_t*, ecs_iter_t const*);
bool ecs_query_orphaned(ecs_query_t*);
bool ecs_iter_next(ecs_iter_t*);
void* ecs_field_w_size(ecs_iter_t const*, size_t, int32_t);
bool ecs_field_is_readonly(ecs_iter_t const*, int32_t);
bool ecs_field_is_writeonly(ecs_iter_t const*, int32_t);
ecs_id_t ecs_field_id(ecs_iter_t const*, int32_t);
size_t ecs_field_size(ecs_iter_t const*, int32_t);
bool ecs_field_is_self(ecs_iter_t const*, int32_t);
ecs_entity_t ecs_lookup(ecs_world_t const* world, char const* name);

]]
