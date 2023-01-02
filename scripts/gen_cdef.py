#!/usr/bin/env python3

from clang.cindex import *
from collections import OrderedDict
from textwrap import indent

unit = Index.create().parse(
    'external/flecs/flecs.h',
    options = TranslationUnit.PARSE_DETAILED_PROCESSING_RECORD
)

symbols = {
    't': {},
    'o': {},
}

for c in unit.cursor.get_children():
    if c.kind == CursorKind.TYPEDEF_DECL:
        symbols['t'][c.spelling] = c
    else:
        symbols['o'][c.spelling] = c

picked = []

def pick(t, symbol, privatize = False):
    picked.append((symbols[t][symbol], privatize))

def ecs_id(key):
    return f"FLECS__E{key}"

def dump_decl(c_type, identifier, part_a, part_b, part_c):
    const = "const" if c_type.is_const_qualified() else ""

    if c_type.get_declaration().is_anonymous() and c_type.is_pod():
        return " ".join(filter(None, [part_a, dump_pod(c_type.get_declaration()), part_b, identifier, part_c]))

    if c_type.kind == TypeKind.TYPEDEF and \
       c_type.get_declaration().underlying_typedef_type.kind in { TypeKind.ELABORATED, TypeKind.ENUM, TypeKind.POINTER }:
        part_b = " ".join(filter(None, [const, part_b]))
        return dump_decl(c_type.get_declaration().underlying_typedef_type, identifier, part_a, part_b, part_c)

    if c_type.kind == TypeKind.FUNCTIONPROTO:
        args = ", ".join(dump_decl(a, "", "", "", "") for a in c_type.argument_types()) if c_type.argument_types() else "void"
        middle = " ".join(filter(None, [part_b, identifier, part_c]))
        return dump_decl(c_type.get_result(), f"({middle})({args})", "", "", "")

    if c_type.kind == TypeKind.POINTER:
        part_b = " ".join(filter(None, ["*", const, part_b]))
        return dump_decl(c_type.get_pointee(), identifier, part_a, part_b, part_c)

    if c_type.kind == TypeKind.CONSTANTARRAY:
        part_c = f"[{c_type.element_count}]" + part_c
        return dump_decl(c_type.element_type, identifier, part_a, part_b, part_c)

    return " ".join(filter(None, [part_a, c_type.spelling, part_b, identifier, part_c]))

def dump_pod(cursor, privatize = False):
    pod_type = "union" if cursor.kind == CursorKind.UNION_DECL else "struct"
    result = " ".join(filter(None, [pod_type, cursor.spelling, "{\n"]))

    for m in cursor.get_children():
        if m.kind == CursorKind.FIELD_DECL:
            identifier = f"_{m.spelling}" if privatize else m.spelling
            result += indent(dump_decl(m.type, identifier, "", "", "") + ";\n", "    ")

    result += "}"
    return result

def dump_enum(cursor):
    result = ""
    result += f"{cursor.type.spelling} {{\n"

    for v in cursor.get_children():
        result += f"    {v.spelling},\n"

    result += "}"
    return result

def dump_typedef(cursor):
    return f"typedef {dump_decl(cursor.underlying_typedef_type, cursor.spelling, '', '', '')}"

def dump_function(cursor):
    c_type = cursor.type
    args = ", ".join(dump_decl(a, "", "", "", "") for a in c_type.argument_types()) if c_type.argument_types() else "void"
    return f"{dump_decl(cursor.type.get_result(), '', '', '', '')} {cursor.spelling}({args})"

def dump_var(cursor):
    linkage = ""
    if cursor.linkage == LinkageKind.EXTERNAL:
        linkage = "extern"
    elif cursor.linkage == LinkageKind.INTERNAL:
        linkage = "static"

    return " ".join(filter(None, [linkage, dump_decl(cursor.type, cursor.spelling, "", "", "")]))


def dump():
    result = ""

    for c, p in picked:
        if c.kind == CursorKind.STRUCT_DECL:
            result += f"{dump_pod(c, p)};\n"
        elif c.kind == CursorKind.ENUM_DECL:
            result += f"{dump_enum(c)};\n"
        elif c.kind == CursorKind.TYPEDEF_DECL:
            result += f"{dump_typedef(c)};\n"
        elif c.kind == CursorKind.FUNCTION_DECL:
            result += f"{dump_function(c)};\n"
        elif c.kind == CursorKind.VAR_DECL:
            result += f"{dump_var(c)};\n"

    return result.strip()

# Primitives {{{

pick("t", "ecs_flags8_t")
pick("t", "ecs_flags32_t")
pick("t", "ecs_flags64_t")
pick("t", "ecs_size_t")
pick("t", "ecs_time_t")

# }}}

# Id primitives {{{

pick("t", "ecs_id_t")
pick("t", "ecs_entity_t")

# }}}

# Meta primitives {{{

pick("t", "ecs_bool_t")
pick("t", "ecs_char_t")
pick("t", "ecs_byte_t")
pick("t", "ecs_u8_t")
pick("t", "ecs_u16_t")
pick("t", "ecs_u32_t")
pick("t", "ecs_u64_t")
pick("t", "ecs_uptr_t")
pick("t", "ecs_i8_t")
pick("t", "ecs_i16_t")
pick("t", "ecs_i32_t")
pick("t", "ecs_i64_t")
pick("t", "ecs_iptr_t")
pick("t", "ecs_f32_t")
pick("t", "ecs_f64_t")
pick("t", "ecs_string_t")

# }}}

# Meta primitives ids {{{

pick("o", ecs_id("ecs_bool_t"))
pick("o", ecs_id("ecs_char_t"))
pick("o", ecs_id("ecs_byte_t"))
pick("o", ecs_id("ecs_u8_t"))
pick("o", ecs_id("ecs_u16_t"))
pick("o", ecs_id("ecs_u32_t"))
pick("o", ecs_id("ecs_u64_t"))
pick("o", ecs_id("ecs_uptr_t"))
pick("o", ecs_id("ecs_i8_t"))
pick("o", ecs_id("ecs_i16_t"))
pick("o", ecs_id("ecs_i32_t"))
pick("o", ecs_id("ecs_i64_t"))
pick("o", ecs_id("ecs_iptr_t"))
pick("o", ecs_id("ecs_f32_t"))
pick("o", ecs_id("ecs_f64_t"))
pick("o", ecs_id("ecs_string_t"))
pick("o", ecs_id("ecs_entity_t"))

# }}}

# Struct typedefs {{{

pick("t", "ecs_poly_t")
pick("t", "ecs_world_t")
pick("t", "ecs_iter_t")
pick("t", "ecs_query_t")
pick("t", "ecs_vector_t")

# }}}

# OS API {{{

pick("t", "ecs_os_thread_t")
pick("t", "ecs_os_mutex_t")
pick("t", "ecs_os_cond_t")
pick("t", "ecs_os_dl_t")
pick("t", "ecs_os_api_t")
pick("o", "ecs_os_api_t")
pick("o", "ecs_os_api")

# }}}

# Desc structs {{{

pick("t", "ecs_entity_desc_t")
pick("o", "ecs_entity_desc_t")

pick("t", "ecs_type_info_t") # To suppress warning
pick("o", "ecs_type_hooks_t")
pick("o", "ecs_type_info_t")
pick("t", "ecs_component_desc_t")
pick("o", "ecs_component_desc_t")

pick("o", "ecs_term_id_t")
pick("o", "ecs_inout_kind_t")
pick("o", "ecs_oper_kind_t")
pick("o", "ecs_term_t")
pick("t", "ecs_filter_desc_t")
pick("o", "ecs_filter_desc_t")
pick("t", "ecs_table_t") # To suppress warning
pick("t", "ecs_query_desc_t")
pick("o", "ecs_query_desc_t")

pick("o", "ecs_member_t")
pick("t", "ecs_struct_desc_t")
pick("o", "ecs_struct_desc_t")

# }}}

# Iter struct {{{

pick("o", "ecs_table_cache_iter_t")
pick("o", "ecs_term_iter_t")
pick("o", "ecs_iter_kind_t")
pick("o", "ecs_filter_iter_t")
pick("o", "ecs_query_iter_t")
pick("o", "ecs_rule_iter_t")
pick("o", "ecs_header_t")
pick("o", "ecs_iterable_t")
pick("o", "ecs_filter_t")
pick("o", "ecs_snapshot_iter_t")
pick("o", "ecs_page_iter_t")
pick("o", "ecs_worker_iter_t")
pick("o", "ecs_stack_cursor_t")
pick("o", "ecs_iter_cache_t")
pick("o", "ecs_iter_private_t")
pick("o", "ecs_iter_t", True)

# }}}

# Meta structs {{{

pick("o", "ecs_meta_type_op_kind_t")
pick("t", "ecs_meta_type_op_t")
pick("o", "ecs_meta_type_op_t")
pick("t", "EcsMetaTypeSerialized")
pick("o", "EcsMetaTypeSerialized")

# }}}

# Meta struct ids{{{

pick("o", ecs_id("EcsMetaTypeSerialized"))

# }}}

# API functions {{{

pick("o", "ecs_make_pair")
pick("o", "ecs_init")
pick("o", "ecs_fini")
pick("o", "ecs_entity_init")
pick("o", "ecs_component_init")
pick("o", "ecs_query_init")
pick("o", "ecs_struct_init")
pick("o", "ecs_add_id")
pick("o", "ecs_remove_id")
pick("o", "ecs_enable_id")
pick("o", "ecs_is_enabled_id")
pick("o", "ecs_clear")
pick("o", "ecs_delete")
pick("o", "ecs_delete_with")
pick("o", "ecs_remove_all")
pick("o", "ecs_get_id")
pick("o", "ecs_set_id")
pick("o", "ecs_modified_id")
pick("o", "ecs_is_valid")
pick("o", "ecs_is_alive")
pick("o", "ecs_ensure")
pick("o", "ecs_ensure_id")
pick("o", "ecs_exists")
pick("o", "ecs_get_name")
pick("o", "ecs_get_symbol")
pick("o", "ecs_set_name")
pick("o", "ecs_set_symbol")
pick("o", "ecs_set_alias")
pick("o", "ecs_has_id")
pick("o", "ecs_get_target")
pick("o", "ecs_get_target_for_id")
pick("o", "ecs_enable")
pick("o", "ecs_count_id")
pick("o", "ecs_query_iter")
pick("o", "ecs_query_changed")
pick("o", "ecs_query_orphaned")
pick("o", "ecs_iter_next")
pick("o", "ecs_field_w_size")
pick("o", "ecs_field_is_readonly")
pick("o", "ecs_field_is_writeonly")
pick("o", "ecs_field_id")
pick("o", "ecs_field_size")
pick("o", "ecs_field_is_self")
pick("o", "ecs_lookup")
pick("o", "ecs_vector_count")
pick("o", "_ecs_vector_get")

# }}}

#print("#include <stdbool.h>\n#include <stdint.h>\n" + dump())
print("-- Automatically generated\nreturn [[\n" + dump() + "\n]]")
