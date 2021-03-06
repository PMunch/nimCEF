import nc_util, nc_util_impl, cef_context_menu_handler_api
import nc_types, nc_drag_data, nc_context_menu_params, nc_menu_model
include cef_import

# Callback structure used for continuation of custom context menu display.
wrapAPI(NCRunContextMenuCallback, cef_run_context_menu_callback, false)

# Complete context menu display by selecting the specified |command_id| and
# |event_flags|.
proc continueCallback*(self: NCRunContextMenuCallback, command_id: int, event_flags: cef_event_flags) =
  self.wrapCall(cont, command_id, event_flags)

# Cancel context menu display.
proc cancel*(self: NCRunContextMenuCallback) =
  self.wrapCall(cancel)

# Implement this structure to handle context menu events. The functions of this
# structure will be called on the UI thread.
wrapCallback(NCContextMenuHandler, cef_context_menu_handler):
  # Called before a context menu is displayed. |params| provides information
  # about the context menu state. |model| initially contains the default
  # context menu. The |model| can be cleared to show no context menu or
  # modified to show a custom menu. Do not keep references to |params| or
  # |model| outside of this callback.
  proc onBeforeContextMenu*(self: T, browser: NCBrowser,
    frame: NCFrame, params: NCContextMenuParams, model: NCMenuModel)

  # Called to allow custom display of the context menu. |params| provides
  # information about the context menu state. |model| contains the context menu
  # model resulting from OnBeforeContextMenu. For custom display return true
  # (1) and execute |callback| either synchronously or asynchronously with the
  # selected command ID. For default display return false (0). Do not keep
  # references to |params| or |model| outside of this callback.
  proc runContextMenu*(self: T, browser: NCBrowser,
    frame: NCFrame, params: NCContextMenuParams, model: NCMenuModel,
    callback: NCRunContextMenuCallback): int

  # Called to execute a command selected from the context menu. Return true (1)
  # if the command was handled or false (0) for the default implementation. See
  # cef_menu_id_t for the command ids that have default implementations. All
  # user-defined command ids should be between MENU_ID_USER_FIRST and
  # MENU_ID_USER_LAST. |params| will have the same values as what was passed to
  # on_before_context_menu(). Do not keep a reference to |params| outside of
  # this callback.
  proc onContextMenuCommand*(self: T, browser: NCBrowser,
    frame: NCFrame, params: NCContextMenuParams, command_id: cef_menu_id,
    event_flags: cef_event_flags): int

  # Called when the context menu is dismissed irregardless of whether the menu
  # was NULL or a command was selected.
  proc onContextMenuDismissed*(self: T,  browser: NCBrowser, frame: NCFrame)