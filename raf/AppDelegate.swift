import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow
    var view1: NSTableView
    var view2: NSTableView
    var splitView: NSSplitView

    var paneController1: PaneController = PaneController()
    var paneController2: PaneController = PaneController()

    override init() {
        var contentSize = NSMakeRect(0.0, 0.0, 600.0, 400.0);
        var windowStyleMask = NSTitledWindowMask | NSResizableWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask;
        window = NSWindow(contentRect: contentSize, styleMask: windowStyleMask, backing: NSBackingStoreType.Buffered, defer: true);
        window.title = "raf";

        view1 = NSTableView(frame: CGRectMake(0, 0, 600, 400))
        view2 = NSTableView(frame: CGRectMake(0, 0, 600, 400))
        splitView = NSSplitView(frame: window.frame)
        splitView.vertical = true
        splitView.addSubview(view1)
        splitView.addSubview(view2)
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        window.makeKeyAndOrderFront(self)
    }

    func createTable(tableView: NSTableView, paneController: PaneController) {
        tableView.addTableColumn(NSTableColumn(identifier: "Name"))
        tableView.addTableColumn(NSTableColumn(identifier: "Size"))
        tableView.addTableColumn(NSTableColumn(identifier: "Date modified"))
        tableView.setDataSource(paneController);
        tableView.setDelegate(paneController)
    }

    func applicationWillFinishLaunching(notification: NSNotification) {
        createTable(view1, paneController: paneController1)
        createTable(view2, paneController: paneController2)

        window.contentView = splitView
    }

    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true;
    }
}
