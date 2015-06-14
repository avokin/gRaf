import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate {

    var window: NSWindow
    var view: NSTableView

    override init() {
        var contentSize = NSMakeRect(0.0, 0.0, 600.0, 400.0);
        var windowStyleMask = NSTitledWindowMask | NSResizableWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask;
        window = NSWindow(contentRect: contentSize, styleMask:windowStyleMask, backing:NSBackingStoreType.Buffered, defer:true);

        window.backgroundColor = NSColor.blueColor();
        window.title = "raf";

        view = NSTableView(frame:CGRectMake(0, 0, 600, 400));
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        window.makeKeyAndOrderFront(self)
    }

    func applicationWillFinishLaunching(notification: NSNotification) {
        view.addTableColumn(NSTableColumn(identifier: "FirstName"))
        view.setDataSource(self);
        view.setDelegate(self)
        window.contentView = view
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
