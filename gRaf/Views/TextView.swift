//
// Created by Andrey Vokin on 25/09/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//
import Cocoa

import Foundation

class TextView : NSTextView {
    var myDelegate: PaneController?

    class func create(_ frame: NSRect) -> TextView {
        let result = TextView(frame: frame)
        result.isRichText = false
        result.allowsUndo = true
        return result
    }

    override func keyDown(with theEvent: NSEvent) {
        if let d = myDelegate {
            if !d.viewKeyDown(theEvent) {
                return
            }
        }

        super.keyDown(with: theEvent)
    }
}
