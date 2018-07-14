import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    static var appDelegate: AppDelegate? = nil;

    let statusBarHeight: CGFloat = 20
    let padding: CGFloat = 2
    let titleBarHeight: CGFloat = 20

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
        let contentSize = NSMakeRect(0.0, 0.0, 600.0, 400.0)
        let windowStyleMask = NSWindowStyleMask(rawValue: (NSWindowStyleMask.titled.rawValue | NSWindowStyleMask.resizable.rawValue |  NSWindowStyleMask.closable.rawValue | NSWindowStyleMask.miniaturizable.rawValue))
        window = NSWindow(contentRect: contentSize, styleMask: windowStyleMask, backing: NSBackingStoreType.buffered,
                defer: true);
        window.title = "gRaf"

        scrollView1 = NSScrollView()
        scrollView2 = NSScrollView()

        splitView = NSSplitView()

        mainView = NSView(frame: window.frame)
        statusBar = NSTextField(frame: CGRect(x: 0, y: 0, width: window.frame.size.width, height: statusBarHeight))

        singleView = scrollView1

        window.center()

        super.init()

        AppDelegate.appDelegate = self
    }

    static func getAppDelegate() -> AppDelegate? {
        return appDelegate;
    }

    func createFileListController(_ root: File, from: File?) -> FileListPaneController {
        let result = FileListPaneController(root: root, from: from)!
        result.window = window

        return result
    }

    func createFileViewController(_ file: File, parentController: FileListPaneController) -> FileViewController {
        var result: FileViewController?
        if ImageUtil.isImageFile(file) {
            result = ImageViewController(file: file, parentController: parentController)
        } else {
            result = TextViewController(file: file, parentController: parentController)
        }

        result!.window = window

        return result!
    }

    func createFileListController(_ insteadOf: PaneController, root: File, from: File) {
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

    func dispose(_ controller: PaneController) {
        controller.window = nil
        controller.appDelegate = nil
    }

    func openFileViewController(_ insteadOf: FileListPaneController, file: File) {
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
        let defaults = UserDefaults.standard
        var leftFilePath: String? = defaults.value(forKey: "leftFilePath") as! String?
        if leftFilePath == nil {
           leftFilePath = "/"
        }
        var rightFilePath: String? = defaults.value(forKey: "rightFilePath") as! String?
        if rightFilePath == nil {
            rightFilePath = "/"
        }

        let root1 = File(path: leftFilePath!, size: UInt64.max, dateModified: Date(), isDirectory: true)
        let root2 = File(path: rightFilePath!, size: UInt64.max, dateModified: Date(), isDirectory: true)

        let c1 = createFileListController(root1, from: nil)
        c1.model.addListener(listener: PaneModelListener { ec in
            ec.rootChanged = {(newValue: String) in defaults.set(newValue, forKey: "leftFilePath")};
            return ec
        })
        let c2 = createFileListController(root2, from: nil)
        c2.model.addListener(listener: PaneModelListener { ec in
            ec.rootChanged = {(newValue: String) in defaults.set(newValue, forKey: "rightFilePath")};
            return ec
        })

        paneController1 = c1
        paneController2 = c2
    }

    func fillMainView(_ view: NSView) {
        var titleBarSpace: CGFloat = 0
        if (mainView.window != nil) {
            titleBarSpace = titleBarHeight
        }
        let viewHeight = window.frame.size.height - statusBarHeight - titleBarSpace - padding
        view.frame = CGRect(x: 0, y: statusBarHeight, width: window.frame.size.width, height: viewHeight)

        mainView.addSubview(view)
    }

    func setupLeftAndRight() {
        paneController1.otherPaneController = paneController2
        paneController2.otherPaneController = paneController1

        scrollView1.documentView = paneController1.view
        scrollView2.documentView = paneController2.view

        scrollView1.removeFromSuperview()
        scrollView1.frame = CGRect(x: 0, y: 0, width: 1, height: 1)

        scrollView2.removeFromSuperview()
        scrollView2.frame = CGRect(x: 0, y: 0, width: 1, height: 1)

        splitView.addSubview(scrollView1)
        splitView.addSubview(scrollView2)

        fillMainView(splitView)
    }

    func initUI() {
        splitView.isVertical = true
        splitView.autoresizingMask = [NSAutoresizingMaskOptions.viewWidthSizable,
                                      NSAutoresizingMaskOptions.viewHeightSizable]

        statusBar.autoresizingMask = [NSAutoresizingMaskOptions.viewWidthSizable]
        statusBar.backgroundColor = window.backgroundColor
        mainView.addSubview(statusBar)
    }

    func installSingleView() {
        splitView.removeFromSuperview()
        singleView.autoresizingMask = [NSAutoresizingMaskOptions.viewWidthSizable,
                                       NSAutoresizingMaskOptions.viewHeightSizable]
        fillMainView(singleView)
    }

    func initWindowController() {
        let controller = NSViewController(nibName: nil, bundle: nil)
        controller!.view = mainView

        controller!.addChildViewController(paneController1)
        controller!.addChildViewController(paneController2)

        window.contentViewController = controller
    }

    func applicationWillFinishLaunching(_ notification: Notification) {
        initPaneControllers()
        setupLeftAndRight()
        initUI()
        initWindowController()
        paneController1.focus()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window.makeKeyAndOrderFront(self)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true;
    }

    func updateStatus(_ status: String) {
        statusBar.stringValue = status
    }
}
