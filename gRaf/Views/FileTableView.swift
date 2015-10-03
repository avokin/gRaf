//
// Created by Andrey Vokin on 03/10/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Cocoa

import Foundation

class FileTableView: NSTableView {
    override func keyDown(theEvent: NSEvent) {
        if theEvent.keyCode == 36 {
            if let responder = delegate() as? NSResponder {
                responder.keyDown(theEvent)
            }
            return
        }
        super.keyDown(theEvent)
    }
}
