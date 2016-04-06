import cef_base, cef_browser, cef_frame, cef_request, cef_resource_handler
include cef_import

# Structure that manages custom scheme registrations.

type
  cef_scheme_registrar* = object
    base*: cef_base
    
    # Register a custom scheme. This function should not be called for the built-
    # in HTTP, HTTPS, FILE, FTP, ABOUT and DATA schemes.
    #
    # If |is_standard| is true (1) the scheme will be treated as a standard
    # scheme. Standard schemes are subject to URL canonicalization and parsing
    # rules as defined in the Common Internet Scheme Syntax RFC 1738 Section 3.1
    # available at http:#www.ietf.org/rfc/rfc1738.txt
    #
    # In particular, the syntax for standard scheme URLs must be of the form:
    # <pre>
    #  [scheme]:#[username]:[password]@[host]:[port]/[url-path]
    # </pre> Standard scheme URLs must have a host component that is a fully
    # qualified domain name as defined in Section 3.5 of RFC 1034 [13] and
    # Section 2.1 of RFC 1123. These URLs will be canonicalized to
    # "scheme:#host/path" in the simplest case and
    # "scheme:#username:password@host:port/path" in the most explicit case. For
    # example, "scheme:host/path" and "scheme:host/path" will both be
    # canonicalized to "scheme:#host/path". The origin of a standard scheme URL
    # is the combination of scheme, host and port (i.e., "scheme:#host:port" in
    # the most explicit case).
    #
    # For non-standard scheme URLs only the "scheme:" component is parsed and
    # canonicalized. The remainder of the URL will be passed to the handler as-
    # is. For example, "scheme:some%20text" will remain the same. Non-standard
    # scheme URLs cannot be used as a target for form submission.
    #
    # If |is_local| is true (1) the scheme will be treated as local (i.e., with
    # the same security rules as those applied to "file" URLs). Normal pages
    # cannot link to or access local URLs. Also, by default, local URLs can only
    # perform XMLHttpRequest calls to the same URL (origin + path) that
    # originated the request. To allow XMLHttpRequest calls from a local URL to
    # other URLs with the same origin set the
    # CefSettings.file_access_from_file_urls_allowed value to true (1). To allow
    # XMLHttpRequest calls from a local URL to all origins set the
    # CefSettings.universal_access_from_file_urls_allowed value to true (1).
    #
    # If |is_display_isolated| is true (1) the scheme will be treated as display-
    # isolated. This means that pages cannot display these URLs unless they are
    # from the same scheme. For example, pages in another origin cannot create
    # iframes or hyperlinks to URLs with this scheme.
    #
    # This function may be called on any thread. It should only be called once
    # per unique |scheme_name| value. If |scheme_name| is already registered or
    # if an error occurs this function will return false (0).
  
    add_custom_scheme*: proc(self: ptr cef_scheme_registrar,
      scheme_name: ptr cef_string, is_standard, is_local, is_display_isolated: bool): int {.cef_callback.}

# Structure that creates cef_resource_handler_t instances for handling scheme
# requests. The functions of this structure will always be called on the IO
# thread.
type
  cef_scheme_handler_factory* = object
    base*: cef_base
    # Return a new resource handler instance to handle the request or an NULL
    # reference to allow default handling of the request. |browser| and |frame|
    # will be the browser window and frame respectively that originated the
    # request or NULL if the request did not originate from a browser window (for
    # example, if the request came from cef_urlrequest_t). The |request| object
    # passed to this function will not contain cookie data.
  
    create*: proc(self: ptr cef_scheme_handler_factory, browser: ptr_cef_browser, 
      frame: ptr cef_frame, scheme_name: ptr cef_string, request: ptr cef_request): ptr cef_resource_handler {.cef_callback.}

# Register a scheme handler factory with the global request context. An NULL
# |domain_name| value for a standard scheme will cause the factory to match all
# domain names. The |domain_name| value will be ignored for non-standard
# schemes. If |scheme_name| is a built-in scheme and no handler is returned by
# |factory| then the built-in scheme handler factory will be called. If
# |scheme_name| is a custom scheme then you must also implement the
# cef_app_t::on_register_custom_schemes() function in all processes. This
# function may be called multiple times to change or remove the factory that
# matches the specified |scheme_name| and optional |domain_name|. Returns false
# (0) if an error occurs. This function may be called on any thread in the
# browser process. Using this function is equivalent to calling cef_request_tCo
# ntext::cef_request_context_get_global_context()->register_scheme_handler_fact
# ory().

proc cef_register_scheme_handler_factory*(scheme_name, domain_name: ptr cef_string, 
  factory: ptr cef_scheme_handler_factory) {.cef_import.}

# Clear all scheme handler factories registered with the global request
# context. Returns false (0) on error. This function may be called on any
# thread in the browser process. Using this function is equivalent to calling c
# ef_request_tContext::cef_request_context_get_global_context()->clear_scheme_h
# andler_factories().

proc cef_clear_scheme_handler_factories*(): int {.cef_import.}