import macros, cef_string, cef_string_list, cef_string_map, cef_types
include cef_import

type
  # Structure defining the reference count implementation functions. All
  # framework structures must include the cef_base_t structure first.
  cef_base* = object of RootObj
    # Size of the data structure.
    size*: csize
    # Called to increment the reference count for the object. Should be called
    # for every new copy of a pointer to a given object.
    add_ref*: proc(self: ptr cef_base) {.cef_callback.}
    # Called to decrement the reference count for the object. If the reference
    # count falls to 0 the object should self-delete. Returns true (1) if the
    # resulting reference count is 0.
    release*: proc(self: ptr cef_base): int {.cef_callback.}
    # Returns true (1) if the current reference count is 1.
    has_one_ref*: proc(self: ptr cef_base): int {.cef_callback.}
  
  #cef_client* = object of cef_base
    #on_app: proc(self: ptr cef_client, app: ptr cef_app) {.cef_callback.}
    #on_bca: proc(self: ptr cef_client) {.cef_callback.}
    
include cef_command_line, cef_stream, cef_drag_data, cef_client, cef_browser, cef_scheme, cef_app