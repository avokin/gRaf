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
        textView.font = NSFont(name: "Monaco", size: 12);
        textView.myDelegate = self
        var content = FSUtil.getFileContent(file)
        if content == nil {
            content = ""
        }

        textView.string = content
        textView.setSelectedRange(NSMakeRange(0, 0))
    }

    override func viewKeyDown(_ theEvent: NSEvent) -> Bool {
        if theEvent.keyCode == 1 {
            if theEvent.modifierFlags.intersection(NSEventModifierFlags.command) != [] {
                // Command + S
                FSUtil.setFileContent(file, content: textView.string!)
                return false
            }
        } else if theEvent.keyCode == 53 {
            // Esc
            appDelegate.createFileListController(self, root:file.getParent()!, from: file)
            return false
        }
        return true
    }

    func textDidChange(_ notification: Notification) {
        let a: NSString = self.textView.string! as NSString;
        let size = a.size(withAttributes: [NSFontAttributeName: self.textView.font!])

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

