import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate {

    var window: NSWindow
    var view1: NSTableView
    var view2: NSTableView
    var splitView: NSSplitView

    var left: String = "/Users/avokin"
    var right: String = "/"

    var files1 = [String]()
    var files2 = [String]()

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

    func createTable(tableView: NSTableView) {
        tableView.addTableColumn(NSTableColumn(identifier: "name"))
        tableView.addTableColumn(NSTableColumn(identifier: "size"))
        tableView.setDataSource(self);
        tableView.setDelegate(self)
    }

    func updateTable(path: String, table: NSTableView, inout files: [String]) {
        files = FSUtil.getFilesOfDirectory(path);
        table.reloadData()
    }

    func applicationWillFinishLaunching(notification: NSNotification) {
        createTable(view1)
        createTable(view2)

        updateTable(left, table: view1, files: &files1)
        updateTable(right, table: view2, files: &files2)

        window.contentView = splitView
    }

    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true;
    }

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        var files = files1
        if (tableView == view2) {
            files = files2
        }
        return files.count
    }

    func tableView(tableView: NSTableView!, objectValueForTableColumn tableColumn: NSTableColumn!, row: Int) -> AnyObject! {
        var files = files1
        if (tableView == view2) {
            files = files2
        }
        return files[row]
    }
}
