//
// Created by Andrey Vokin on 03/10/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Cocoa

import Foundation

class FileTableView: NSTableView {
    override func keyDown(with theEvent: NSEvent) {
        if theEvent.keyCode == 36 || theEvent.keyCode == 48 {
            if let responder = delegate as? NSResponder {
                responder.keyDown(with: theEvent)
            }
            return
        }
        super.keyDown(with: theEvent)
    }

    override func becomeFirstResponder() -> Bool {
        if let responder = delegate as? NSResponder {
            responder.becomeFirstResponder()
        }
        return super.becomeFirstResponder()
    }
}
