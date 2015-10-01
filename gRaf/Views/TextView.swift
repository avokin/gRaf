//
// Created by Andrey Vokin on 25/09/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//
import Cocoa

import Foundation

class TextView : NSTextView {
    var myDelegate: PaneController?

    override func keyDown(theEvent: NSEvent) {
        if let d = myDelegate {
            if !d.viewKeyDown(theEvent) {
                return
            }
        }

        super.keyDown(theEvent)
    }
}
