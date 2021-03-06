import nc_util, nc_util_impl, cef_load_handler_api, nc_types
include cef_import

# Implement this structure to handle events related to browser load status. The
# functions of this structure will be called on the browser process UI thread
# or render process main thread (TID_RENDERER).
wrapCallback(NCLoadHandler, cef_load_handler):
  # Called when the loading state has changed. This callback will be executed
  # twice -- once when loading is initiated either programmatically or by user
  # action, and once when loading is terminated due to completion, cancellation
  # of failure. It will be called before any calls to OnLoadStart and after all
  # calls to OnLoadError and/or OnLoadEnd.
  proc onLoadingStateChange*(self: T, browser: NCBrowser,
    isLoading, canGoBack, canGoForward: bool)

  # Called when the browser begins loading a frame. The |frame| value will
  # never be NULL -- call the is_main() function to check if this frame is the
  # main frame. |transition_type| provides information about the source of the
  # navigation and an accurate value is only available in the browser process.
  # Multiple frames may be loading at the same time. Sub-frames may start or
  # continue loading after the main frame load has ended. This function will
  # always be called for all frames irrespective of whether the request
  # completes successfully. For notification of overall browser load status use
  # OnLoadingStateChange instead.
  proc onLoadStart*(self: T, browser: NCBrowser, frame: NCFrame)

  # Called when the browser is done loading a frame. The |frame| value will
  # never be NULL -- call the is_main() function to check if this frame is the
  # main frame. Multiple frames may be loading at the same time. Sub-frames may
  # start or continue loading after the main frame load has ended. This
  # function will always be called for all frames irrespective of whether the
  # request completes successfully. For notification of overall browser load
  # status use OnLoadingStateChange instead.
  proc onLoadEnd*(self: T, browser: NCBrowser, frame: NCFrame, httpStatusCode: int)

  # Called when the resource load for a navigation fails or is canceled.
  # |errorCode| is the error code number, |errorText| is the error text and
  # |failedUrl| is the URL that failed to load. See net\base\net_error_list.h
  # for complete descriptions of the error codes.
  proc onLoadError*(self: T, browser: NCBrowser, frame: NCFrame,
    errorCode: cef_errorcode, errorText, failedUrl: string)