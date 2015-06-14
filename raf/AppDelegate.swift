import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow
    var view: NSView

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
        window.contentView = view
    }

    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true;
    }
}
