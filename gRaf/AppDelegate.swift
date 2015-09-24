import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow
    var scrollView1: NSScrollView
    var scrollView2: NSScrollView
    var splitView: NSSplitView
    var mainView: NSView

    var paneController1: PaneController
    var paneController2: PaneController

    override init() {
        var contentSize = NSMakeRect(0.0, 0.0, 600.0, 400.0);
        var windowStyleMask = NSTitledWindowMask | NSResizableWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask;
        window = NSWindow(contentRect: contentSize, styleMask: windowStyleMask, backing: NSBackingStoreType.Buffered, defer: true);
        window.title = "gRaf";

        paneController1 = FileListPaneController()
        paneController2 = FileViewPaneController()

        scrollView1 = NSScrollView(frame: CGRectMake(0, 0, 1, 1))
        scrollView2 = NSScrollView(frame: CGRectMake(0, 0, 1, 1))

        var statusBarHeight: CGFloat = 20
        var topBarHeight: CGFloat = 20
        var splitViewHeight = window.frame.size.height - statusBarHeight - topBarHeight
        splitView = NSSplitView(frame: CGRectMake(0, statusBarHeight, window.frame.size.width, splitViewHeight))

        mainView = NSView(frame: window.frame)
    }

    func initPaneControllers() {
        paneController1.window = window
        paneController1.otherPaneController = paneController2

        paneController2.window = window
        paneController2.otherPaneController = paneController1
    }

    func initUI() {
        splitView.vertical = true

        scrollView1.documentView = paneController1.view
        scrollView2.documentView = paneController2.view

        splitView.addSubview(scrollView1)
        splitView.addSubview(scrollView2)

        mainView.addSubview(splitView)
        splitView.autoresizingMask = NSAutoresizingMaskOptions.ViewWidthSizable | NSAutoresizingMaskOptions.ViewHeightSizable
    }

    func initWindowController() {
        var controller = NSViewController(nibName: nil, bundle: nil)
        controller!.view = mainView

        controller!.addChildViewController(paneController1)
        controller!.addChildViewController(paneController2)

        window.contentViewController = controller
    }

    func applicationWillFinishLaunching(notification: NSNotification) {
        initPaneControllers()
        initUI()
        initWindowController()
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        window.makeKeyAndOrderFront(self)
    }

    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true;
    }
}
