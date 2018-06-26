//
// Created by user on 26/06/2018.
// Copyright (c) 2018 Andrey Vokin. All rights reserved.
//

import Cocoa
import Foundation

open class UIUtil {
    static func getString(title: String) -> String? {
        let msg = NSAlert()
        msg.addButton(withTitle: "OK")
        msg.addButton(withTitle: "Cancel")
        msg.messageText = title

        let rect = NSRect(x: 0, y: 0, width: 200, height: 24)
        let inputTextField = NSTextField(frame: rect)

        msg.accessoryView = inputTextField
        msg.window.initialFirstResponder = msg.accessoryView
        let result: NSModalResponse = msg.runModal()

        if result == NSAlertFirstButtonReturn {
            return inputTextField.stringValue
        } else {
            return nil
        }
    }
}