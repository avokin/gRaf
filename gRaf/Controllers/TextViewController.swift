//
// Created by Andrey Vokin on 22/09/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Cocoa
import Foundation

class TextViewController: FileViewController {
    var textView: TextView!

    override init?(file: File, parentController: FileListPaneController) {
        super.init(file: file, parentController: parentController)
        createView()
        view = textView
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func createView() {
        textView = TextView.create(NSMakeRect(0, 0, 1000, 1000))
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
            if theEvent.modifierFlags.intersect(NSEventModifierFlags.CommandKeyMask) != [] {
                FSUtil.setFileContent(file, content: textView.string!)
            }
        } else if theEvent.keyCode == 53 {
            appDelegate.createFileListController(self, root:file.getParent()!, from: file)
            return false
        }
        return true
    }

    func textDidChange(notification: NSNotification) {
        let a: NSString = self.textView.string!;
        let size = a.sizeWithAttributes([NSFontAttributeName: self.textView.font!])

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

