import nc_types, nc_util

# Callback structure used for asynchronous continuation of authentication
# requests.
wrapAPI(NCAuthCallback, cef_auth_callback)

# Continue the authentication request.
proc continueAuth*(self: NCAuthCallback, username, password: string) =
  self.wrapCall(cont, username, password)

# Cancel the authentication request.
proc cancel*(self: NCAuthCallback) =
  self.wrapCall(cancel)