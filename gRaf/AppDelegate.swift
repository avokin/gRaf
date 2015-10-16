import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow
    var scrollView1: NSScrollView
    var scrollView2: NSScrollView
    var splitView: NSSplitView
    var mainView: NSView

    var paneController1: PaneController!
    var paneController2: PaneController!

    override init() {
        var contentSize = NSMakeRect(0.0, 0.0, 600.0, 400.0);
        var windowStyleMask = NSTitledWindowMask | NSResizableWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask;
        window = NSWindow(contentRect: contentSize, styleMask: windowStyleMask, backing: NSBackingStoreType.Buffered, defer: true);
        window.title = "gRaf";

        scrollView1 = NSScrollView(frame: CGRectMake(0, 0, 1, 1))
        scrollView2 = NSScrollView(frame: CGRectMake(0, 0, 1, 1))

        var statusBarHeight: CGFloat = 20
        var topBarHeight: CGFloat = 20
        var splitViewHeight = window.frame.size.height - statusBarHeight - topBarHeight
        splitView = NSSplitView(frame: CGRectMake(0, statusBarHeight, window.frame.size.width, splitViewHeight))

        mainView = NSView(frame: window.frame)
    }

    func createFileListController(root: File, from: File?) -> PaneController {
        var result = FileListPaneController(root: root, from: from)!
        result.window = window
        result.appDelegate = self

        return result
    }

    func createFileViewController(file: File) -> PaneController  {
        var result: PaneController?
        var a = file.name.lastPathComponent
        if equal("jpg", file.name.lastPathComponent.pathExtension) {
            result = ImageViewPaneController(file: file)
        } else {
            result = FileViewPaneController(file: file)
        }

        result!.window = window
        result!.appDelegate = self

        return result!
    }

    func createFileListController(insteadOf: PaneController, root: File, from: File) {
        var newController = createFileListController(root, from: from)
        var oldController: PaneController
        if paneController1 == insteadOf {
            oldController = paneController1
            paneController1 = newController
        } else {
            oldController = paneController2
            paneController2 = newController
        }

        setupLeftAndRight()
        newController.focus()
        oldController.dispose()
    }

    func dispose(controller: PaneController) {
        controller.window = nil
        controller.appDelegate = nil
    }

    func createFileViewController(insteadOf: PaneController, file: File) {
        var newController = createFileViewController(file)
        if paneController1 == insteadOf {
            paneController1 = newController
        } else {
            paneController2 = newController
        }

        setupLeftAndRight()
        newController.focus()
    }

    func initPaneControllers() {
        var root = FSUtil.getRoot()
        paneController1 = createFileListController(root, from: nil)
        paneController2 = createFileListController(root, from: nil)
    }

    func setupLeftAndRight() {
        paneController1.otherPaneController = paneController2
        paneController2.otherPaneController = paneController1

        scrollView1.documentView = paneController1.view
        scrollView2.documentView = paneController2.view
    }

    func initUI() {
        splitView.vertical = true

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
        setupLeftAndRight()
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
