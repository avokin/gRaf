//
// Created by Andrey Vokin on 26/08/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Cocoa
import Foundation

class ProgressWindow : NSWindow {
    var progressIndicator: NSProgressIndicator
    var operation: Operation?

    init() {
        let width: CGFloat = 400.0
        let height: CGFloat = 200.0
        let pbHeight: CGFloat = 20.0
        let contentSize = NSMakeRect(0.0, 0.0, width, height);
        let windowStyleMask = NSWindowStyleMask.titled
        progressIndicator = NSProgressIndicator(frame: CGRect(x: 0.0, y: (height - pbHeight) / 2, width: width, height: pbHeight))

        super.init(contentRect: contentSize, styleMask: windowStyleMask, backing: NSBackingStoreType.buffered, defer: true)

        let buttonCancel: NSButton = NSButton(frame: NSMakeRect(20, 20, 100, 30))
        buttonCancel.title = "Cancel"
        buttonCancel.bezelStyle = NSBezelStyle.rounded
        buttonCancel.action = #selector(ProgressWindow.cancelAction(_:))

        progressIndicator.style = NSProgressIndicatorStyle.barStyle
        progressIndicator.isIndeterminate = false
        progressIndicator.minValue = 0.0
        progressIndicator.maxValue = 100.0
        progressIndicator.doubleValue = 20.0

        contentView!.addSubview(progressIndicator)
        contentView!.addSubview(buttonCancel)
    }

    func cancelAction(_ obj:AnyObject?) {
        self.operation?.cancel()
    }

    override func keyDown(with theEvent: NSEvent) {
        if theEvent.keyCode == 53 {
            cancelAction(nil)
        } else {
            super.keyDown(with: theEvent)
        }
    }

    func start(_ mainAction: @escaping () -> (), progressUpdater: @escaping () -> Int) {
        let operationQueue: OperationQueue = OperationQueue()

        self.progressIndicator.doubleValue = 0

        self.operation = MyOperation(action: {
            mainAction()
        }, completionBlock: {
            DispatchQueue.main.async {
                NSApplication.shared().stopModal()
                self.close()
                AppDelegate.appDelegate!.window.makeKey()
            }
        })

        let controlOperation: Operation = MyOperation(action: {
            while true {
                if self.operation!.isFinished {
                    break;
                }
                usleep(50000)

                DispatchQueue.main.async {
                    self.progressIndicator.doubleValue = Double(progressUpdater())
                }
            }
        }, completionBlock: {})

        operationQueue.addOperations([self.operation!, controlOperation], waitUntilFinished: false)

        NSApplication.shared().runModal(for: self)
    }

    class MyOperation: Operation {
        let action: () -> ()
        let myCompletionBlock: () -> ()

        init(action: @escaping () -> (), completionBlock: @escaping () -> ()) {
            self.action = action
            self.myCompletionBlock = completionBlock
        }

        override func main() {
            self.completionBlock = myCompletionBlock
            action()
        }
    }
}
