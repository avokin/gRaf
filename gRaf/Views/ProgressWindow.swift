//
// Created by Andrey Vokin on 26/08/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Cocoa
import Foundation

class ProgressWindow : NSWindow {
    var progressIndicator: NSProgressIndicator
    var progress: Progress
    var cancelled: Bool = false

    init() {
        let width: CGFloat = 400.0
        let height: CGFloat = 200.0
        let pbHeight: CGFloat = 20.0
        let contentSize = NSMakeRect(0.0, 0.0, width, height);
        let windowStyleMask = NSTitledWindowMask
        progress = Progress(totalUnitCount: 10000)
        progress.completedUnitCount = 0
        progressIndicator = NSProgressIndicator(frame: CGRect(x: 0.0, y: (height - pbHeight) / 2, width: width, height: pbHeight))

        super.init(contentRect: contentSize, styleMask: windowStyleMask, backing: NSBackingStoreType.buffered, defer: true)

        let buttonCancel: NSButton = NSButton(frame: NSMakeRect(20, 20, 100, 30))
        buttonCancel.title = "Cancel"
        buttonCancel.bezelStyle = NSBezelStyle.rounded
        buttonCancel.action = #selector(ProgressWindow.cancelAction(_:))

        progressIndicator.style = NSProgressIndicatorStyle.barStyle
        progressIndicator.isIndeterminate = false
        progressIndicator.minValue = 0.0
        progressIndicator.maxValue = 10000.0
        progressIndicator.doubleValue = 20.0

        contentView!.addSubview(progressIndicator)
        contentView!.addSubview(buttonCancel)
    }

    func cancelAction(_ obj:AnyObject?) {
        progress.cancel()
        NSApplication.shared().abortModal()
    }

    override func keyDown(with theEvent: NSEvent) {
        if theEvent.keyCode == 53 {
            cancelAction(nil)
        } else {
            super.keyDown(with: theEvent)
        }
    }

    func start(_ mainAction: @escaping () -> (), progressUpdater: @escaping () -> Int) {
        self.progressIndicator.doubleValue = 0

        DispatchQueue.global(qos: .userInitiated).async {
            mainAction()

            self.cancelAction(nil)
        }

        DispatchQueue.global(qos: .userInitiated).async {
            while true {
                if self.progress.isCancelled {
                    break;
                }
                usleep(100000)

                self.progress.completedUnitCount = Int64(progressUpdater())
                DispatchQueue.main.async {
                    if !self.progress.isCancelled {
                        self.progressIndicator.doubleValue = Double(self.progress.completedUnitCount)
                    }
                }
            }
        }
        NSApplication.shared().runModal(for: self)
    }
}
