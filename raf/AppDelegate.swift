import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow

    override init() {
        var contentSize = NSMakeRect(500.0, 500.0, 1000.0, 1000.0);
        var windowStyleMask = NSTitledWindowMask | NSResizableWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask;
        window = NSWindow(contentRect: contentSize, styleMask:windowStyleMask, backing:NSBackingStoreType.Buffered, defer:true);

        window.backgroundColor = NSColor.whiteColor();
        window.title = "raf";
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        window.makeKeyAndOrderFront(self);     // Show the window
    }

    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true;
    }
}
