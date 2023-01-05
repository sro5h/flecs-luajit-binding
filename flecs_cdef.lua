-- This file is automatically generated by generate_cdef.py
return [[
/* Symbols from external/flecs/flecs.h {{{ */
typedef uint8_t ecs_flags8_t;
typedef uint32_t ecs_flags32_t;
typedef uint64_t ecs_flags64_t;
typedef int32_t ecs_size_t;
typedef struct ecs_vector_t ecs_vector_t;
void * _ecs_vector_get(struct ecs_vector_t const *, ecs_size_t, int16_t, int32_t);
int32_t ecs_vector_count(struct ecs_vector_t const *);
typedef uintptr_t ecs_os_thread_t;
typedef uintptr_t ecs_os_cond_t;
typedef uintptr_t ecs_os_mutex_t;
typedef uintptr_t ecs_os_dl_t;
struct ecs_os_api_t {
    void (* init_)(void);
    void (* fini_)(void);
    void * (* malloc_)(ecs_size_t);
    void * (* realloc_)(void *, ecs_size_t);
    void * (* calloc_)(ecs_size_t);
    void (* free_)(void *);
    char * (* strdup_)(const char *);
    ecs_os_thread_t (* thread_new_)(void * (*)(void *), void *);
    void * (* thread_join_)(ecs_os_thread_t);
    int32_t (* ainc_)(int32_t *);
    int32_t (* adec_)(int32_t *);
    int64_t (* lainc_)(int64_t *);
    int64_t (* ladec_)(int64_t *);
    ecs_os_mutex_t (* mutex_new_)(void);
    void (* mutex_free_)(ecs_os_mutex_t);
    void (* mutex_lock_)(ecs_os_mutex_t);
    void (* mutex_unlock_)(ecs_os_mutex_t);
    ecs_os_cond_t (* cond_new_)(void);
    void (* cond_free_)(ecs_os_cond_t);
    void (* cond_signal_)(ecs_os_cond_t);
    void (* cond_broadcast_)(ecs_os_cond_t);
    void (* cond_wait_)(ecs_os_cond_t, ecs_os_mutex_t);
    void (* sleep_)(int32_t, int32_t);
    uint64_t (* now_)(void);
    void (* get_time_)(struct ecs_time_t *);
    void (* log_)(int32_t, const char *, int32_t, const char *);
    void (* abort_)(void);
    ecs_os_dl_t (* dlopen_)(const char *);
    void (* (* dlproc_)(ecs_os_dl_t, const char *))(void);
    void (* dlclose_)(ecs_os_dl_t);
    char * (* module_to_dl_)(const char *);
    char * (* module_to_etc_)(const char *);
    int32_t log_level_;
    int32_t log_indent_;
    int32_t log_last_error_;
    int64_t log_last_timestamp_;
    ecs_flags32_t flags_;
};
typedef struct ecs_os_api_t ecs_os_api_t;
extern struct ecs_os_api_t ecs_os_api;
typedef uint64_t ecs_id_t;
typedef ecs_id_t ecs_entity_t;
typedef struct ecs_world_t ecs_world_t;
typedef struct ecs_query_t ecs_query_t;
typedef struct ecs_filter_t ecs_filter_t;
typedef struct ecs_iter_t ecs_iter_t;
struct ecs_header_t {
    int32_t magic;
    int32_t type;
    struct ecs_mixins_t * mixins;
};
typedef void ecs_poly_t;
struct ecs_iterable_t {
    void (* init)(struct ecs_world_t const *, const ecs_poly_t *, struct ecs_iter_t *, struct ecs_term_t *);
};
struct ecs_filter_t {
    struct ecs_header_t hdr;
    struct ecs_term_t * terms;
    int32_t term_count;
    int32_t field_count;
    bool owned;
    bool terms_owned;
    ecs_flags32_t flags;
    char * name;
    char * variable_names [1];
    struct ecs_iterable_t iterable;
};
struct ecs_table_cache_iter_t {
    struct ecs_table_cache_hdr_t * cur;
    struct ecs_table_cache_hdr_t * next;
    struct ecs_table_cache_hdr_t * next_list;
};
struct ecs_term_id_t {
    ecs_entity_t id;
    char * name;
    ecs_entity_t trav;
    ecs_flags32_t flags;
};
enum ecs_inout_kind_t {
    EcsInOutDefault,
    EcsInOutNone,
    EcsInOut,
    EcsIn,
    EcsOut,
};
enum ecs_oper_kind_t {
    EcsAnd,
    EcsOr,
    EcsNot,
    EcsOptional,
    EcsAndFrom,
    EcsOrFrom,
    EcsNotFrom,
};
struct ecs_term_t {
    ecs_id_t id;
    struct ecs_term_id_t src;
    struct ecs_term_id_t first;
    struct ecs_term_id_t second;
    enum ecs_inout_kind_t inout;
    enum ecs_oper_kind_t oper;
    ecs_id_t id_flags;
    char * name;
    int32_t field_index;
    struct ecs_id_record_t * idr;
    bool move;
};
struct ecs_term_iter_t {
    struct ecs_term_t term;
    struct ecs_id_record_t * self_index;
    struct ecs_id_record_t * set_index;
    struct ecs_id_record_t * cur;
    struct ecs_table_cache_iter_t it;
    int32_t index;
    int32_t observed_table_count;
    struct ecs_table_t * table;
    int32_t cur_match;
    int32_t match_count;
    int32_t last_column;
    bool empty_tables;
    ecs_id_t id;
    int32_t column;
    ecs_entity_t subject;
    ecs_size_t size;
    void * ptr;
};
enum ecs_iter_kind_t {
    EcsIterEvalCondition,
    EcsIterEvalTables,
    EcsIterEvalChain,
    EcsIterEvalNone,
};
struct ecs_filter_iter_t {
    struct ecs_filter_t const * filter;
    enum ecs_iter_kind_t kind;
    struct ecs_term_iter_t term_iter;
    int32_t matches_left;
    int32_t pivot_term;
};
struct ecs_query_iter_t {
    struct ecs_query_t * query;
    struct ecs_query_table_node_t * node;
    struct ecs_query_table_node_t * prev;
    struct ecs_query_table_node_t * last;
    int32_t sparse_smallest;
    int32_t sparse_first;
    int32_t bitset_first;
    int32_t skip_count;
};
struct ecs_rule_iter_t {
    struct ecs_rule_t const * rule;
    struct ecs_var_t * registers;
    struct ecs_rule_op_ctx_t * op_ctx;
    int32_t * columns;
    ecs_entity_t entity;
    bool redo;
    int32_t op;
    int32_t sp;
};
struct ecs_snapshot_iter_t {
    struct ecs_filter_t filter;
    struct ecs_vector_t * tables;
    int32_t index;
};
struct ecs_page_iter_t {
    int32_t offset;
    int32_t limit;
    int32_t remaining;
};
struct ecs_worker_iter_t {
    int32_t index;
    int32_t count;
};
struct ecs_stack_cursor_t {
    struct ecs_stack_page_t * cur;
    int16_t sp;
};
struct ecs_iter_cache_t {
    struct ecs_stack_cursor_t stack_cursor;
    ecs_flags8_t used;
    ecs_flags8_t allocated;
};
struct ecs_iter_private_t {
    union {
        struct ecs_term_iter_t term;
        struct ecs_filter_iter_t filter;
        struct ecs_query_iter_t query;
        struct ecs_rule_iter_t rule;
        struct ecs_snapshot_iter_t snapshot;
        struct ecs_page_iter_t page;
        struct ecs_worker_iter_t worker;
    } iter;
    struct ecs_iter_cache_t cache;
};
struct ecs_iter_t {
    struct ecs_world_t * _world;
    struct ecs_world_t * _real_world;
    ecs_entity_t * _entities;
    void * * _ptrs;
    ecs_size_t * _sizes;
    struct ecs_table_t * _table;
    struct ecs_table_t * _other_table;
    ecs_id_t * _ids;
    struct ecs_var_t * _variables;
    int32_t * _columns;
    ecs_entity_t * _sources;
    int32_t * _match_indices;
    struct ecs_ref_t * _references;
    ecs_flags64_t _constrained_vars;
    uint64_t _group_id;
    int32_t _field_count;
    ecs_entity_t _system;
    ecs_entity_t _event;
    ecs_id_t _event_id;
    struct ecs_term_t * _terms;
    int32_t _table_count;
    int32_t _term_index;
    int32_t _variable_count;
    char * * _variable_names;
    void * _param;
    void * _ctx;
    void * _binding_ctx;
    float _delta_time;
    float _delta_system_time;
    int32_t _frame_offset;
    int32_t _offset;
    int32_t _count;
    int32_t _instance_count;
    ecs_flags32_t _flags;
    ecs_entity_t _interrupted_by;
    struct ecs_iter_private_t _priv;
    bool (* _next)(struct ecs_iter_t *);
    void (* _callback)(struct ecs_iter_t *);
    void (* _fini)(struct ecs_iter_t *);
    struct ecs_iter_t * _chain_it;
};
struct ecs_entity_desc_t {
    int32_t _canary;
    ecs_entity_t id;
    const char * name;
    const char * sep;
    const char * root_sep;
    const char * symbol;
    bool use_low_id;
    ecs_id_t add [32];
    const char * add_expr;
};
typedef struct ecs_entity_desc_t ecs_entity_desc_t;
struct ecs_type_hooks_t {
    void (* ctor)(void *, int32_t, struct ecs_type_info_t const *);
    void (* dtor)(void *, int32_t, struct ecs_type_info_t const *);
    void (* copy)(void *, const void *, int32_t, struct ecs_type_info_t const *);
    void (* move)(void *, void *, int32_t, struct ecs_type_info_t const *);
    void (* copy_ctor)(void *, const void *, int32_t, struct ecs_type_info_t const *);
    void (* move_ctor)(void *, void *, int32_t, struct ecs_type_info_t const *);
    void (* ctor_move_dtor)(void *, void *, int32_t, struct ecs_type_info_t const *);
    void (* move_dtor)(void *, void *, int32_t, struct ecs_type_info_t const *);
    void (* on_add)(struct ecs_iter_t *);
    void (* on_set)(struct ecs_iter_t *);
    void (* on_remove)(struct ecs_iter_t *);
    void * ctx;
    void * binding_ctx;
    void (* ctx_free)(void *);
    void (* binding_ctx_free)(void *);
};
struct ecs_type_info_t {
    ecs_size_t size;
    ecs_size_t alignment;
    struct ecs_type_hooks_t hooks;
    ecs_entity_t component;
    const char * name;
};
struct ecs_component_desc_t {
    int32_t _canary;
    ecs_entity_t entity;
    struct ecs_type_info_t type;
};
typedef struct ecs_component_desc_t ecs_component_desc_t;
struct ecs_filter_desc_t {
    int32_t _canary;
    struct ecs_term_t terms [16];
    struct ecs_term_t * terms_buffer;
    int32_t terms_buffer_count;
    struct ecs_filter_t * storage;
    bool instanced;
    ecs_flags32_t flags;
    const char * expr;
    const char * name;
};
typedef struct ecs_filter_desc_t ecs_filter_desc_t;
struct ecs_query_desc_t {
    int32_t _canary;
    struct ecs_filter_desc_t filter;
    ecs_entity_t order_by_component;
    int (* order_by)(ecs_entity_t, const void *, ecs_entity_t, const void *);
    void (* sort_table)(struct ecs_world_t *, struct ecs_table_t *, ecs_entity_t *, void *, int32_t, int32_t, int32_t, int (*)(ecs_entity_t, const void *, ecs_entity_t, const void *));
    ecs_id_t group_by_id;
    uint64_t (* group_by)(struct ecs_world_t *, struct ecs_table_t *, ecs_id_t, void *);
    void * (* on_group_create)(struct ecs_world_t *, uint64_t, void *);
    void (* on_group_delete)(struct ecs_world_t *, uint64_t, void *, void *);
    void * group_by_ctx;
    void (* group_by_ctx_free)(void *);
    struct ecs_query_t * parent;
    ecs_entity_t entity;
};
typedef struct ecs_query_desc_t ecs_query_desc_t;
extern const ecs_entity_t FLECS__EEcsComponent;
extern const ecs_entity_t FLECS__EEcsIdentifier;
extern const ecs_entity_t FLECS__EEcsIterable;
extern const ecs_entity_t FLECS__EEcsPoly;
extern const ecs_entity_t EcsQuery;
extern const ecs_entity_t EcsObserver;
extern const ecs_entity_t EcsSystem;
extern const ecs_entity_t FLECS__EEcsTickSource;
extern const ecs_entity_t FLECS__EEcsTimer;
extern const ecs_entity_t FLECS__EEcsRateFilter;
extern const ecs_entity_t EcsFlecs;
extern const ecs_entity_t EcsFlecsCore;
extern const ecs_entity_t EcsWorld;
extern const ecs_entity_t EcsWildcard;
extern const ecs_entity_t EcsAny;
extern const ecs_entity_t EcsThis;
extern const ecs_entity_t EcsVariable;
extern const ecs_entity_t EcsTransitive;
extern const ecs_entity_t EcsReflexive;
extern const ecs_entity_t EcsFinal;
extern const ecs_entity_t EcsDontInherit;
extern const ecs_entity_t EcsSymmetric;
extern const ecs_entity_t EcsExclusive;
extern const ecs_entity_t EcsAcyclic;
extern const ecs_entity_t EcsWith;
extern const ecs_entity_t EcsOneOf;
extern const ecs_entity_t EcsTag;
extern const ecs_entity_t EcsUnion;
extern const ecs_entity_t EcsName;
extern const ecs_entity_t EcsSymbol;
extern const ecs_entity_t EcsAlias;
extern const ecs_entity_t EcsChildOf;
extern const ecs_entity_t EcsIsA;
extern const ecs_entity_t EcsDependsOn;
extern const ecs_entity_t EcsSlotOf;
extern const ecs_entity_t EcsModule;
extern const ecs_entity_t EcsPrivate;
extern const ecs_entity_t EcsPrefab;
extern const ecs_entity_t EcsDisabled;
extern const ecs_entity_t EcsOnAdd;
extern const ecs_entity_t EcsOnRemove;
extern const ecs_entity_t EcsOnSet;
extern const ecs_entity_t EcsUnSet;
extern const ecs_entity_t EcsMonitor;
extern const ecs_entity_t EcsOnDelete;
extern const ecs_entity_t EcsOnTableEmpty;
extern const ecs_entity_t EcsOnTableFill;
extern const ecs_entity_t EcsOnDeleteTarget;
extern const ecs_entity_t EcsRemove;
extern const ecs_entity_t EcsDelete;
extern const ecs_entity_t EcsPanic;
extern const ecs_entity_t EcsDefaultChildComponent;
extern const ecs_entity_t EcsEmpty;
extern const ecs_entity_t FLECS__EEcsPipeline;
extern const ecs_entity_t EcsPreFrame;
extern const ecs_entity_t EcsOnLoad;
extern const ecs_entity_t EcsPostLoad;
extern const ecs_entity_t EcsPreUpdate;
extern const ecs_entity_t EcsOnUpdate;
extern const ecs_entity_t EcsOnValidate;
extern const ecs_entity_t EcsPostUpdate;
extern const ecs_entity_t EcsPreStore;
extern const ecs_entity_t EcsOnStore;
extern const ecs_entity_t EcsPostFrame;
extern const ecs_entity_t EcsPhase;
struct ecs_world_t * ecs_init(void);
int ecs_fini(struct ecs_world_t *);
void ecs_quit(struct ecs_world_t *);
bool ecs_should_quit(struct ecs_world_t const *);
void ecs_set_target_fps(struct ecs_world_t *, float);
ecs_entity_t ecs_entity_init(struct ecs_world_t *, struct ecs_entity_desc_t const *);
ecs_entity_t ecs_component_init(struct ecs_world_t *, struct ecs_component_desc_t const *);
ecs_entity_t ecs_clone(struct ecs_world_t *, ecs_entity_t, ecs_entity_t, bool);
void ecs_add_id(struct ecs_world_t *, ecs_entity_t, ecs_id_t);
void ecs_remove_id(struct ecs_world_t *, ecs_entity_t, ecs_id_t);
void ecs_override_id(struct ecs_world_t *, ecs_entity_t, ecs_id_t);
void ecs_enable_id(struct ecs_world_t *, ecs_entity_t, ecs_id_t, bool);
bool ecs_is_enabled_id(struct ecs_world_t const *, ecs_entity_t, ecs_id_t);
ecs_id_t ecs_make_pair(ecs_entity_t, ecs_entity_t);
void ecs_clear(struct ecs_world_t *, ecs_entity_t);
void ecs_delete(struct ecs_world_t *, ecs_entity_t);
void ecs_delete_with(struct ecs_world_t *, ecs_id_t);
void ecs_remove_all(struct ecs_world_t *, ecs_id_t);
const void * ecs_get_id(struct ecs_world_t const *, ecs_entity_t, ecs_id_t);
void * ecs_get_mut_id(struct ecs_world_t *, ecs_entity_t, ecs_id_t);
void * ecs_emplace_id(struct ecs_world_t *, ecs_entity_t, ecs_id_t);
void ecs_modified_id(struct ecs_world_t *, ecs_entity_t, ecs_id_t);
ecs_entity_t ecs_set_id(struct ecs_world_t *, ecs_entity_t, ecs_id_t, int, const void *);
bool ecs_is_valid(struct ecs_world_t const *, ecs_entity_t);
bool ecs_is_alive(struct ecs_world_t const *, ecs_entity_t);
ecs_entity_t ecs_get_alive(struct ecs_world_t const *, ecs_entity_t);
void ecs_ensure(struct ecs_world_t *, ecs_entity_t);
void ecs_ensure_id(struct ecs_world_t *, ecs_id_t);
bool ecs_exists(struct ecs_world_t const *, ecs_entity_t);
ecs_entity_t ecs_get_typeid(struct ecs_world_t const *, ecs_id_t);
ecs_entity_t ecs_id_is_tag(struct ecs_world_t const *, ecs_id_t);
bool ecs_id_in_use(struct ecs_world_t *, ecs_id_t);
const char * ecs_get_name(struct ecs_world_t const *, ecs_entity_t);
const char * ecs_get_symbol(struct ecs_world_t const *, ecs_entity_t);
ecs_entity_t ecs_set_name(struct ecs_world_t *, ecs_entity_t, const char *);
ecs_entity_t ecs_set_symbol(struct ecs_world_t *, ecs_entity_t, const char *);
void ecs_set_alias(struct ecs_world_t *, ecs_entity_t, const char *);
bool ecs_has_id(struct ecs_world_t const *, ecs_entity_t, ecs_id_t);
ecs_entity_t ecs_get_target(struct ecs_world_t const *, ecs_entity_t, ecs_entity_t, int32_t);
ecs_entity_t ecs_get_target_for_id(struct ecs_world_t const *, ecs_entity_t, ecs_entity_t, ecs_id_t);
void ecs_enable(struct ecs_world_t *, ecs_entity_t, bool);
int32_t ecs_count_id(struct ecs_world_t const *, ecs_id_t);
ecs_entity_t ecs_lookup_child(struct ecs_world_t const *, ecs_entity_t, const char *);
ecs_entity_t ecs_lookup_path_w_sep(struct ecs_world_t const *, ecs_entity_t, const char *, const char *, const char *, bool);
ecs_entity_t ecs_lookup_symbol(struct ecs_world_t const *, const char *, bool);
char * ecs_get_path_w_sep(struct ecs_world_t const *, ecs_entity_t, ecs_entity_t, const char *, const char *);
ecs_entity_t ecs_set_scope(struct ecs_world_t *, ecs_entity_t);
ecs_entity_t ecs_get_scope(struct ecs_world_t const *);
ecs_entity_t ecs_set_with(struct ecs_world_t *, ecs_id_t);
ecs_id_t ecs_get_with(struct ecs_world_t const *);
struct ecs_query_t * ecs_query_init(struct ecs_world_t *, struct ecs_query_desc_t const *);
struct ecs_iter_t ecs_query_iter(struct ecs_world_t const *, struct ecs_query_t *);
bool ecs_query_changed(struct ecs_query_t *, struct ecs_iter_t const *);
bool ecs_query_orphaned(struct ecs_query_t *);
bool ecs_iter_next(struct ecs_iter_t *);
void * ecs_field_w_size(struct ecs_iter_t const *, int, int32_t);
bool ecs_field_is_readonly(struct ecs_iter_t const *, int32_t);
bool ecs_field_is_writeonly(struct ecs_iter_t const *, int32_t);
ecs_id_t ecs_field_id(struct ecs_iter_t const *, int32_t);
int ecs_field_size(struct ecs_iter_t const *, int32_t);
bool ecs_field_is_self(struct ecs_iter_t const *, int32_t);
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
typedef char * ecs_string_t;
extern const ecs_entity_t FLECS__EEcsMetaTypeSerialized;
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
enum ecs_meta_type_op_kind_t {
    EcsOpArray,
    EcsOpVector,
    EcsOpPush,
    EcsOpPop,
    EcsOpScope,
    EcsOpEnum,
    EcsOpBitmask,
    EcsOpPrimitive,
    EcsOpBool,
    EcsOpChar,
    EcsOpByte,
    EcsOpU8,
    EcsOpU16,
    EcsOpU32,
    EcsOpU64,
    EcsOpI8,
    EcsOpI16,
    EcsOpI32,
    EcsOpI64,
    EcsOpF32,
    EcsOpF64,
    EcsOpUPtr,
    EcsOpIPtr,
    EcsOpString,
    EcsOpEntity,
    EcsMetaTypeOpKindLast,
};
struct ecs_meta_type_op_t {
    enum ecs_meta_type_op_kind_t kind;
    ecs_size_t offset;
    int32_t count;
    const char * name;
    int32_t op_count;
    ecs_size_t size;
    ecs_entity_t type;
    ecs_entity_t unit;
    struct ecs_hashmap_t * members;
};
typedef struct ecs_meta_type_op_t ecs_meta_type_op_t;
struct EcsMetaTypeSerialized {
    struct ecs_vector_t * ops;
};
typedef struct EcsMetaTypeSerialized EcsMetaTypeSerialized;
struct ecs_member_t {
    const char * name;
    ecs_entity_t type;
    int32_t count;
    int32_t offset;
    ecs_entity_t unit;
    ecs_size_t size;
    ecs_entity_t member;
};
struct ecs_struct_desc_t {
    ecs_entity_t entity;
    struct ecs_member_t members [32];
};
typedef struct ecs_struct_desc_t ecs_struct_desc_t;
ecs_entity_t ecs_struct_init(struct ecs_world_t *, struct ecs_struct_desc_t const *);
/* }}} */
]]
