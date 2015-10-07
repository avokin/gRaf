//
// Created by Andrey Vokin on 22/09/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Cocoa
import Foundation

class FileViewPaneController : PaneController {
    var file: File!
    var textView: TextView!

    init?(file: File) {
        super.init(nibName: nil, bundle: nil)
        self.file = file
        createView()
        view = textView
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func createView() {
        textView = TextView(frame: NSMakeRect(0, 0, 1000, 1000))
        textView.myDelegate = self
        var content = FSUtil.getFileContent(file)
        if content == nil {
            content = ""
        }

        textView.string = content
        textView.setSelectedRange(NSMakeRange(0, 0))
    }

    override func viewKeyDown(theEvent: NSEvent) -> Bool {
        if theEvent.keyCode == 1 {
            if theEvent.modifierFlags & NSEventModifierFlags.CommandKeyMask != nil {
                FSUtil.setFileContent(file, content: textView.string!)
            }
        } else if theEvent.keyCode == 53 {
            appDelegate.createFileListController(self, root:file.getParent()!, from: file)
            return false
        }
        return true
    }

    func textDidChange(notification: NSNotification) {
        var a: NSString = self.textView.string!;
        var size = a.sizeWithAttributes([NSFontAttributeName: self.textView.font!])

        self.textView.frame = NSMakeRect(self.textView.frame.origin.x, self.textView.frame.origin.y, round(size.width + 15), round(size.height))
    }

    override func focus() {
        window!.makeFirstResponder(textView)
        super.focus()
    }

    override func dispose() {
        textView.myDelegate = nil
        super.dispose()
    }
}

