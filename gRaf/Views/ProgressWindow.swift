//
// Created by Andrey Vokin on 26/08/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Cocoa
import Foundation

class ProgressWindow : NSWindow {
    var progressIndicator: NSProgressIndicator
    var progress: NSProgress
    var cancelled: Bool = false

    required init?(coder aDecoder: NSCoder) {
        progress = NSProgress(totalUnitCount: 100)
        progressIndicator = NSProgressIndicator(frame: CGRectMake(0.0, 0, 0, 0))
        super.init(coder: aDecoder)
    }

    init() {
        var width: CGFloat = 600.0
        var height: CGFloat = 400.0
        var pbHeight: CGFloat = 20.0
        var contentSize = NSMakeRect(0.0, 0.0, width, height);
        var windowStyleMask = NSTitledWindowMask
        progress = NSProgress(totalUnitCount: 100)
        progress.completedUnitCount = 0
        progressIndicator = NSProgressIndicator(frame: CGRectMake(0.0, (height - pbHeight) / 2, width, pbHeight))

        super.init(contentRect: contentSize, styleMask: windowStyleMask, backing: NSBackingStoreType.Buffered, defer: true)

        var buttonCancel: NSButton = NSButton(frame: NSMakeRect(20, 20, 100, 30))
        buttonCancel.title = "Cancel"
        buttonCancel.bezelStyle = NSBezelStyle.RoundedBezelStyle
        buttonCancel.action = "cancelAction:"

        progressIndicator.style = NSProgressIndicatorStyle.BarStyle
        progressIndicator.indeterminate = false
        progressIndicator.minValue = 0.0
        progressIndicator.maxValue = 100.0
        progressIndicator.doubleValue = 20.0

        contentView.addSubview(progressIndicator)
        contentView.addSubview(buttonCancel)
    }

    func cancelAction(obj:AnyObject?) {
        progress.cancel()
        NSApplication.sharedApplication().abortModal()
    }

    override func keyDown(theEvent: NSEvent) {
        if theEvent.keyCode == 53 {
            cancelAction(nil)
        } else {
            super.keyDown(theEvent)
        }
    }

    func start(mainAction: () -> (), progressUpdater: () -> Int) {
        self.progressIndicator.doubleValue = 0

        let priority = Int(QOS_CLASS_USER_INITIATED.value)
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            mainAction()
        }

        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            while true {
                if self.progress.cancelled {
                    break;
                }
                usleep(1000000)

                self.progress.completedUnitCount = Int64(progressUpdater())
                dispatch_async(dispatch_get_main_queue()) {
                    if !self.progress.cancelled {
                        self.progressIndicator.doubleValue = Double(self.progress.completedUnitCount)
                    }
                }
            }
        }
        NSApplication.sharedApplication().runModalForWindow(self)
    }
}
