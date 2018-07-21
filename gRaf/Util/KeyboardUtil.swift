//
// Created by user on 18/10/2017.
// Copyright (c) 2017 Andrey Vokin. All rights reserved.
//
import Cocoa
import Foundation

class KeyboardUtil {
    static func copyToClipboard(_ text: String) {
        let pasteboard = NSPasteboard.general()
        pasteboard.declareTypes([NSPasteboardTypeString], owner: nil)
        pasteboard.setString(text, forType: NSPasteboardTypeString)
    }

    static func isCommandPressed(_ theEvent: NSEvent) -> Bool {
        return theEvent.modifierFlags.contains(.command)
    }

    static func isCommand_C_Pressed(_ theEvent: NSEvent) -> Bool {
        return isCommandPressed(theEvent) && theEvent.keyCode == 8;
    }

    static func isCommandShiftPressed(_ theEvent: NSEvent) -> Bool {
        return isCommandPressed(theEvent) && theEvent.modifierFlags.contains(.shift);
    }
}
