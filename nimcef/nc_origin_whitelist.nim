import cef_origin_whitelist_api, nc_util, nc_types

# Add an entry to the cross-origin access whitelist.
#
# The same-origin policy restricts how scripts hosted from different origins
# (scheme + domain + port) can communicate. By default, scripts can only access
# resources with the same origin. Scripts hosted on the HTTP and HTTPS schemes
# (but no other schemes) can use the "Access-Control-Allow-Origin" header to
# allow cross-origin requests. For example, https:#source.example.com can make
# XMLHttpRequest requests on http:#target.example.com if the
# http:#target.example.com request returns an "Access-Control-Allow-Origin:
# https:#source.example.com" response header.
#
# Scripts in separate frames or iframes and hosted from the same protocol and
# domain suffix can execute cross-origin JavaScript if both pages set the
# document.domain value to the same domain suffix. For example,
# scheme:#foo.example.com and scheme:#bar.example.com can communicate using
# JavaScript if both domains set document.domain="example.com".
#
# This function is used to allow access to origins that would otherwise violate
# the same-origin policy. Scripts hosted underneath the fully qualified
# |source_origin| URL (like http:#www.example.com) will be allowed access to
# all resources hosted on the specified |target_protocol| and |target_domain|.
# If |target_domain| is non-NULL and |allow_target_subdomains| if false (0)
# only exact domain matches will be allowed. If |target_domain| contains a top-
# level domain component (like "example.com") and |allow_target_subdomains| is
# true (1) sub-domain matches will be allowed. If |target_domain| is NULL and
# |allow_target_subdomains| if true (1) all domains and IP addresses will be
# allowed.
#
# This function cannot be used to bypass the restrictions on local or display
# isolated schemes. See the comments on CefRegisterCustomScheme for more
# information.
#
# This function may be called on any thread. Returns false (0) if
# |source_origin| is invalid or the whitelist cannot be accessed.
proc ncAddCrossOriginWhitelistEntry*(source_origin, target_protocol, target_domain: string,
  allow_target_subdomains: bool): bool =
  wrapProc(cef_add_cross_origin_whitelist_entry, result, source_origin,
    target_protocol, target_domain, allow_target_subdomains)

# Remove an entry from the cross-origin access whitelist. Returns false (0) if
# |source_origin| is invalid or the whitelist cannot be accessed.
proc ncRemoveCrossOriginWhitelistEntry*(source_origin, target_protocol, target_domain: string,
  allow_target_subdomains: bool): bool =
  wrapProc(cef_remove_cross_origin_whitelist_entry, result, source_origin,
    target_protocol, target_domain, allow_target_subdomains)

# Remove all entries from the cross-origin access whitelist. Returns false (0)
# if the whitelist cannot be accessed.
proc ncClearCrossOriginWhitelist*(): bool =
  wrapProc(cef_clear_cross_origin_whitelist, result)
