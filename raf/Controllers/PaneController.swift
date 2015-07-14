//
// Created by Andrey Vokin on 14/07/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Cocoa
import Foundation

class PaneController: NSObject, NSTableViewDataSource, NSTableViewDelegate {
    var model: PaneModel = PaneModel()

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return model.getItems().count
    }

    func tableView(tableView: NSTableView!, objectValueForTableColumn tableColumn: NSTableColumn!, row: Int) -> AnyObject! {
        var file: File = model.getItems()[row]
        if (equal(tableColumn.identifier, "Name")) {
            return file.name
        } else if (equal(tableColumn.identifier, "Size")) {
            return String(file.size)
        } else {
            return file.dateModified
        }
    }
}
