import winapi, os, strutils
import nc_menu_model, nc_process_message, nc_app, nc_client, nc_types
import nc_context_menu_params, nc_browser, nc_scheme, nc_resource_handler
import nc_request, nc_callback, nc_util, nc_response, nc_settings, nc_task
import nc_urlrequest, nc_auth_callback, nc_frame, nc_web_plugin
import nc_request_context_handler, nc_request_context
import nc_life_span_handler, nc_context_menu_handler
import test_runner, nc_resource_manager, nc_request_handler
import nc_display_handler

type
  myApp = ref object of NCApp

  myScheme = ref object of NCResourceHandler
    mData: string
    mMimeType: string
    mOffset: int

  myClient = ref object of NCClient
    abc: int
    name: string
    cmh: NCContextMenuHandler
    lsh: NCLifeSpanHandler
    reqh: NCRequestHandler
    disph: NCDisplayHandler

MENU_ID:
  MY_MENU_ID
  MY_QUIT_ID
  MY_PLUGIN_ID
  MY_SHOW_DEVTOOLS
  MY_CLOSE_DEVTOOLS
  MY_INSPECT_ELEMENT
  MY_OTHER_TESTS

handlerImpl(NCClient)

proc showDevTool(host: NCBrowserHost; x, y: int = 0) =
  let screenW = getSystemMetrics(SM_CXSCREEN)
  let screenH = getSystemMetrics(SM_CYSCREEN)
  let devToolW = screenW - screenW div 3
  let devToolH = screenH - screenH div 3
  var windowInfo: NCWindowInfo
  windowInfo.style = WS_OVERLAPPEDWINDOW or WS_CLIPCHILDREN or  WS_CLIPSIBLINGS or WS_VISIBLE
  windowInfo.parent_window = cef_window_handle(0)
  windowInfo.x = (screenW - devToolW) div 2
  windowInfo.y = (screenH - devToolH) div 2
  windowInfo.width = devToolW
  windowInfo.height = devToolH

  var setting: NCBrowserSettings
  host.showDevTools(windowInfo, NCClient.ncCreate(), setting, NCPoint(x:x, y:y))

handlerImpl(NCContextMenuHandler):
  proc onBeforeContextMenu(self: NCContextMenuHandler, browser: NCBrowser,
    frame: NCFrame, params: NCContextMenuParams, model: NCMenuModel) =
    discard model.addSeparator()
    discard model.addItem(MY_PLUGIN_ID, "Plugin Info")
    discard model.addItem(MY_MENU_ID, "Hello There")
    discard model.addSeparator()
    discard model.addItem(MY_SHOW_DEVTOOLS, "Show DevTools")
    discard model.addItem(MY_CLOSE_DEVTOOLS, "Close DevTools")
    discard model.addItem(MY_INSPECT_ELEMENT, "Inspect Element")
    discard model.addSeparator()
    discard model.addItem(MY_OTHER_TESTS, "Other Tests")
    discard model.addItem(MY_QUIT_ID, "Quit")

  proc onContextMenuCommand(self: NCContextMenuHandler, browser: NCBrowser,
    frame: NCFrame, params: NCContextMenuParams, command_id: cef_menu_id,
    event_flags: cef_event_flags): int =

    case command_id
    of MY_MENU_ID:
      frame.executeJavaScript("alert('Hello There Clicked!');", frame.getURL(), 0)

    of MY_QUIT_ID:
      var host = browser.getHost()
      host.closeBrowser(true)

    of MY_SHOW_DEVTOOLS:
      showDevTool(browser.getHost())

    of MY_CLOSE_DEVTOOLS:
      browser.getHost().closeDevTools()

    of MY_INSPECT_ELEMENT:
      showDevTool(browser.getHost(), params.getXCoord(), params.getYCoord())

    of MY_OTHER_TESTS:
      browser.getMainFrame().loadURL("http://tests/other_tests")
    else:
      echo "unsupported MENU ID"
    #if command_id == MY_PLUGIN_ID:
    #  echo "PLUGIN INFO"
    #  let visitor = makeNCWebPluginInfoVisitor(visitor_impl)
    #  NCVisitWebPluginInfo(visitor)

handlerImpl(myScheme):
  proc processRequest(self: myScheme, request: NCRequest, callback: NCCallback): bool =
    NC_REQUIRE_IO_THREAD()

    var handled = false
    var url = request.getURL()
    if url.find("handler.html") != -1:
      #Build the response html
      self.mData = """<html><head><title>Client Scheme Handler</title></head>
<body bgcolor="white">
This contents of this page are served by the
myScheme object handling the client:// protocol.
<h2>Google</h2>
<a href="https://www.google.com/">https://www.google.com/</a>
<br/>You should see an image:
<br/><img src="client://tests/logo.png"><pre>"""

      #Output a string representation of the request
      self.mData.add dumpRequestContents(request)

      self.mData.add """</pre><br/>Try the test form:
<form method="POST" action="handler.html">
<input type="text" name="field1">
<input type="text" name="field2">
<input type="submit">
</form></body></html>"""

      handled = true

      #Set the resulting mime type
      self.mMimeType = "text/html"
    elif url.find("logo.png") != -1:
      #Load the response image
      self.mData = readFile("resources" & DirSep & "logo.png")
      handled = true
      #Set the resulting mime type
      self.mMimeType = "image/png"

    if handled:
      #Indicate the headers are available.
      callback.continueCallback()
      return true

    result = false

  proc getResponseHeaders(self: myScheme, response: NCResponse, response_length: var int64, redirectUrl: var string) =
    NC_REQUIRE_IO_THREAD()
    doAssert(self.mData.len != 0)

    response.setMimeType(self.mMimeType)
    response.setStatus(200)

    #Set the resulting response length
    response_length = self.mData.len

  proc readResponse(self: myScheme, data_out: cstring, bytes_to_read: int, bytes_read: var int, callback: NCCallback): bool =
    NC_REQUIRE_IO_THREAD()
    var has_data = false
    bytes_read = 0

    if self.mOffset < self.mData.len:
      #Copy the next block of data into the buffer.
      let transfer_size = min(bytes_to_read, self.mData.len - self.mOffset)
      copyMem(data_out, self.mData[self.mOffset].addr, transfer_size)
      inc(self.mOffset, transfer_size)
      bytes_read = transfer_size
      has_data = true

    result = has_data

handlerImpl(myApp):
  proc onRegisterCustomSchemes*(self: myApp, registrar: NCSchemeRegistrar) =
    discard registrar.addCustomScheme("client", true, false, false)

handlerImpl(NCSchemeHandlerFactory):
  proc create*(self: NCSchemeHandlerFactory, browser: NCBrowser, frame: NCFrame, schemeName: string, request: NCRequest): NCResourceHandler =
    NC_REQUIRE_IO_THREAD()
    result = myScheme.ncCreate()

proc registerSchemeHandler() =
  ncRegisterSchemeHandlerFactory("client", "tests", NCSchemeHandlerFactory.ncCreate())

handlerImpl(NCLifeSpanHandler):
  proc onBeforeClose(self: NCLifeSpanHandler, browser: NCBrowser) =
    ncQuitMessageLoop()

handlerImpl(NCRequestHandler):
  proc onBeforeResourceLoad*(self: NCRequestHandler, browser: NCBrowser,
  frame: NCFrame, request: NCRequest, callback: NCRequestCallback): cef_return_value =
    NC_REQUIRE_IO_THREAD()
    var resourceManager = getResourceManager()
    result = resourceManager.onBeforeResourceLoad(browser, frame, request, callback)

  proc getResourceHandler*(self: NCRequestHandler, browser: NCBrowser,
    frame: NCFrame, request: NCRequest): NCResourceHandler =
    NC_REQUIRE_IO_THREAD()
    var resourceManager = getResourceManager()
    result = resourceManager.getResourceHandler(browser, frame, request)

handlerImpl(NCDisplayHandler):
  proc onTitleChange*(self: NCDisplayHandler, browser: NCBrowser, title: string) =
    var host = browser.getHost()
    var hWnd = host.getWindowHandle()
    discard setWindowText(hWnd, title)

handlerImpl(myClient):
  proc getContextMenuHandler*(self: myClient): NCContextMenuHandler =
    return self.cmh

  proc getLifeSpanHandler*(self: myClient): NCLifeSpanHandler =
    return self.lsh

  proc getRequestHandler*(self: myClient): NCRequestHandler =
    return self.reqh

  proc getDisplayHandler*(self: myClient): NCDisplayHandler =
    return self.disph

proc newClient(no: int, name: string): myClient =
  result = myClient.ncCreate()
  result.abc = no
  result.name = name
  result.cmh = NCContextMenuHandler.ncCreate()
  result.lsh = NCLifeSpanHandler.ncCreate()
  result.reqh = NCRequestHandler.ncCreate()
  result.disph = NCDisplayHandler.ncCreate()
  setupResourceManager()

proc onBeforePluginLoad*(self: NCRequestContextHandler, mime_type, plugin_url, top_origin_url: string,
  plugin_info: NCWebPluginInfo, plugin_policy: var cef_plugin_policy): bool =

  # Always allow the PDF plugin to load.
  if plugin_policy != PLUGIN_POLICY_ALLOW and mime_type == "application/pdf":
    plugin_policy = PLUGIN_POLICY_ALLOW
    return true

  result = false

proc main() =
  # Main args.
  var mainArgs = makeNCMainArgs()
  var app = myApp.ncCreate()

  var code = ncExecuteProcess(mainArgs, app)
  if code >= 0:
    echo "failure execute process ", code
    quit(code)

  var settings: NCSettings
  settings.no_sandbox = true
  discard ncInitialize(mainArgs, settings, app)

  var windowInfo: NCWindowInfo
  windowInfo.style = WS_OVERLAPPEDWINDOW or WS_CLIPCHILDREN or  WS_CLIPSIBLINGS or WS_VISIBLE or WS_MAXIMIZE
  windowInfo.parent_window = cef_window_handle(0)
  windowInfo.x = 0
  windowInfo.y = 0
  windowInfo.width = getSystemMetrics(SM_CXSCREEN)
  windowInfo.height = getSystemMetrics(SM_CYSCREEN)

  registerSchemeHandler()

  #Initial url.
  #let cwd = getCurrentDir()
  #let url = "file://$1/example.html" % [cwd]
  let url = "client://tests/handler.html"

  #Browser settings.
  #It is mandatory to set the "size" member.
  var browserSettings: NCBrowserSettings
  #browserSettings.plugins = STATE_ENABLED
  var client = newClient(123, "myClient")

  #var rch = makeNCRequestContextHandler(rch_impl)
  #var rcsetting: NCRequestContextSettings
  #var ctx = NCRequestContextCreateContext(rcsetting, rch)

  # Create browser.
  discard ncBrowserHostCreateBrowser(windowInfo, client, url, browserSettings)

  # Message loop.
  ncRunMessageLoop()
  ncShutdown()

main()