import nc_util, nc_util_impl, cef_geolocation_handler_api, nc_types, nc_drag_data
include cef_import

# Callback structure used for asynchronous continuation of geolocation
# permission requests.
wrapAPI(NCGeolocationCallback, cef_geolocation_callback, false)

# Call to allow or deny geolocation access.
proc continueCallback*(self: NCGeolocationCallback, allow: bool): bool =
  self.wrapCall(cont, result, allow)

# Implement this structure to handle events related to geolocation permission
# requests. The functions of this structure will be called on the browser
# process UI thread.
wrapCallback(NCGeolocationHandler, cef_geolocation_handler):
  # Called when a page requests permission to access geolocation information.
  # |requesting_url| is the URL requesting permission and |request_id| is the
  # unique ID for the permission request. Return true (1) and call
  # NCGeolocationCallback::Continue() either in this function or at a later
  # time to continue or cancel the request. Return false (0) to cancel the
  # request immediately.
  proc onRequestGeolocationPermission*(self: T, browser: NCBrowser,
    requesting_url: string, request_id: int, callback: NCGeolocationCallback): bool

  # Called when a geolocation access request is canceled. |request_id| is the
  # unique ID for the permission request.
  proc onCancelGeolocationPermission*(self: T, browser: NCBrowser, request_id: int)