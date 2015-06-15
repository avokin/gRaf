import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate {

    var window: NSWindow
    var view1: NSTableView
    var view2: NSTableView
    var splitView: NSSplitView

    override init() {
        var contentSize = NSMakeRect(0.0, 0.0, 600.0, 400.0);
        var windowStyleMask = NSTitledWindowMask | NSResizableWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask;
        window = NSWindow(contentRect: contentSize, styleMask:windowStyleMask, backing:NSBackingStoreType.Buffered, defer:true);
        window.title = "raf";

        view1 = NSTableView(frame:CGRectMake(0, 0, 600, 400))
        view2 = NSTableView(frame:CGRectMake(0, 0, 600, 400))
        splitView = NSSplitView(frame: window.frame)
        splitView.vertical = true
        splitView.addSubview(view1)
        splitView.addSubview(view2)
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        window.makeKeyAndOrderFront(self)
    }

    func createTable(tableView: NSTableView) {
        tableView.addTableColumn(NSTableColumn(identifier: "FirstName"))
        tableView.addTableColumn(NSTableColumn(identifier: "LastName"))
        tableView.setDataSource(self);
        tableView.setDelegate(self)
    }

    func applicationWillFinishLaunching(notification: NSNotification) {
        createTable(view1)
        createTable(view2)

        window.contentView = splitView
    }

    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true;
    }

    func numberOfRowsInTableView(tableView: NSTableView) -> Int
    {
        let numberOfRows:Int = getDataArray().count
        return numberOfRows
    }

    func getDataArray () -> NSArray{
        var dataArray:[NSDictionary] = [["FirstName": "Debasis", "LastName": "Das"],
                                        ["FirstName": "Nishant", "LastName": "Singh"],
                                        ["FirstName": "John", "LastName": "Doe"],
                                        ["FirstName": "Jane", "LastName": "Doe"],
                                        ["FirstName": "Mary", "LastName": "Jane"]];
        return dataArray;
    }

    func tableView(tableView: NSTableView!, objectValueForTableColumn tableColumn: NSTableColumn!, row: Int) -> AnyObject!
    {
        var newString = getDataArray().objectAtIndex(row).objectForKey(tableColumn.identifier)
        return newString;
    }
}
