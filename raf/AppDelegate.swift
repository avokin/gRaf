import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow
    var scrollView1: NSScrollView
    var scrollView2: NSScrollView
    var tableView1: NSTableView
    var tableView2: NSTableView
    var splitView: NSSplitView

    var paneController1: PaneController = PaneController()
    var paneController2: PaneController = PaneController()

    override init() {
        var contentSize = NSMakeRect(0.0, 0.0, 600.0, 400.0);
        var windowStyleMask = NSTitledWindowMask | NSResizableWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask;
        window = NSWindow(contentRect: contentSize, styleMask: windowStyleMask, backing: NSBackingStoreType.Buffered, defer: true);
        window.title = "raf";

        scrollView1 = NSScrollView(frame: CGRectMake(0, 0, 1, 1))
        scrollView2 = NSScrollView(frame: CGRectMake(0, 0, 1, 1))

        tableView1 = NSTableView(frame: CGRectMake(0, 0, 1, 1))
        paneController1.view = tableView1
        paneController1.otherPaneController = paneController2

        tableView2 = NSTableView(frame: CGRectMake(0, 0, 1, 1))
        paneController2.view = tableView2
        paneController2.otherPaneController = paneController1

        splitView = NSSplitView(frame: window.frame)
        splitView.vertical = true

        scrollView1.documentView = tableView1
        scrollView2.documentView = tableView2

        splitView.addSubview(scrollView1)
        splitView.addSubview(scrollView2)
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        window.makeKeyAndOrderFront(self)
    }

    func createColumn(name: String) -> NSTableColumn {
        var column = NSTableColumn(identifier: name)
        var headerCell = NSTableHeaderCell()
        headerCell.objectValue = name
        column.headerCell = headerCell
        return column
    }

    func createTable(tableView: NSTableView, paneController: PaneController) {
        tableView.addTableColumn(createColumn("Name"))
        tableView.addTableColumn(createColumn("Size"))
        tableView.addTableColumn(createColumn("Date Modified"))

        tableView.setDataSource(paneController);
        tableView.setDelegate(paneController)
    }

    func applicationWillFinishLaunching(notification: NSNotification) {
        paneController1.window = window
        paneController2.window = window

        createTable(tableView1, paneController: paneController1)
        createTable(tableView2, paneController: paneController2)

        var controller = NSViewController(nibName: nil, bundle: nil)
        controller!.view = splitView

        controller!.addChildViewController(paneController1)
        controller!.addChildViewController(paneController2)

        window.contentViewController = controller
        window.makeFirstResponder(tableView2)
    }

    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true;
    }
}
