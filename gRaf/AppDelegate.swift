import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let statusBarHeight: CGFloat = 20
    let topBarHeight: CGFloat = 20

    var window: NSWindow
    var scrollView1: NSScrollView
    var scrollView2: NSScrollView
    var splitView: NSSplitView
    var singleView: NSScrollView
    var mainView: NSView
    var statusBar: NSTextField

    var paneController1: PaneController!
    var paneController2: PaneController!

    override init() {
        let contentSize = NSMakeRect(0.0, 0.0, 600.0, 400.0);
        let windowStyleMask = NSTitledWindowMask | NSResizableWindowMask | NSClosableWindowMask |
                NSMiniaturizableWindowMask;
        window = NSWindow(contentRect: contentSize, styleMask: windowStyleMask, backing: NSBackingStoreType.Buffered,
                defer: true);
        window.title = "gRaf";

        scrollView1 = NSScrollView()
        scrollView2 = NSScrollView()

        splitView = NSSplitView()

        mainView = NSView(frame: window.frame)
        statusBar = NSTextField(frame: CGRectMake(0, 0, window.frame.size.width, statusBarHeight))

        singleView = scrollView1

        window.center()
    }

    func createFileListController(root: File, from: File?) -> PaneController {
        let result = FileListPaneController(root: root, from: from)!
        result.window = window
        result.appDelegate = self

        return result
    }

    func createFileViewController(file: File, parentController: FileListPaneController) -> FileViewController {
        var result: FileViewController?
        if ImageUtil.isImageFile(file) {
            result = ImageViewController(file: file, parentController: parentController)
        } else {
            result = TextViewController(file: file, parentController: parentController)
        }

        result!.window = window
        result!.appDelegate = self

        return result!
    }

    func createFileListController(insteadOf: PaneController, root: File, from: File) {
        let newController = createFileListController(root, from: from)
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

    func openFileViewController(insteadOf: FileListPaneController, file: File) {
        let newController = createFileViewController(file, parentController: insteadOf)
        if paneController1 == insteadOf {
            paneController1 = newController
            singleView = scrollView1
        } else {
            paneController2 = newController
            singleView = scrollView2
        }
        singleView.documentView = newController.view
        installSingleView()
        newController.updateView()
        newController.focus()
    }

    func initPaneControllers() {
        let root = FSUtil.getRoot()
        paneController1 = createFileListController(root, from: nil)
        paneController2 = createFileListController(root, from: nil)
    }

    func fillMainView(view: NSView) {
        let viewHeight = window.frame.size.height - statusBarHeight - topBarHeight
        view.frame = CGRectMake(0, statusBarHeight, window.frame.size.width, viewHeight)

        mainView.addSubview(view)
    }

    func setupLeftAndRight() {
        paneController1.otherPaneController = paneController2
        paneController2.otherPaneController = paneController1

        scrollView1.documentView = paneController1.view
        scrollView2.documentView = paneController2.view

        scrollView1.removeFromSuperview()
        scrollView1.frame = CGRectMake(0, 0, 1, 1)

        scrollView2.removeFromSuperview()
        scrollView2.frame = CGRectMake(0, 0, 1, 1)

        splitView.addSubview(scrollView1)
        splitView.addSubview(scrollView2)

        fillMainView(splitView)
    }

    func initUI() {
        splitView.vertical = true
        splitView.autoresizingMask = [NSAutoresizingMaskOptions.ViewWidthSizable,
                                      NSAutoresizingMaskOptions.ViewHeightSizable]

        statusBar.autoresizingMask = [NSAutoresizingMaskOptions.ViewWidthSizable]
        statusBar.backgroundColor = window.backgroundColor
        mainView.addSubview(statusBar)
    }

    func installSingleView() {
        splitView.removeFromSuperview()
        singleView.autoresizingMask = [NSAutoresizingMaskOptions.ViewWidthSizable,
                                       NSAutoresizingMaskOptions.ViewHeightSizable]
        fillMainView(singleView)
    }

    func initWindowController() {
        let controller = NSViewController(nibName: nil, bundle: nil)
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

    func updateStatus(status: String) {
        statusBar.stringValue = status
    }
}
