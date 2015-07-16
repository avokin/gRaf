//
// Created by Andrey Vokin on 14/07/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Cocoa
import Foundation

class PaneController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    var model = PaneModel()
    var otherPaneController: PaneController!
    var window: NSWindow? = nil
    var tableView: NSTableView!

    let COLUMN_TYPE_ID = "Type"
    let COLUMN_NAME_ID = "Name"
    let COLUMN_SIZE_ID = "Size"
    let COLUMN_DATE_MODIFIED_ID = "Date modified"

    func focus() {
        let tableView: NSTableView = view as! NSTableView
        window!.makeFirstResponder(tableView)
    }

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return model.getItems().count
    }

    func tableView(tableView: NSTableView!, objectValueForTableColumn tableColumn: NSTableColumn!, row: Int) -> AnyObject! {
        var file: File = model.getItems()[row]
        if (equal(tableColumn.identifier, COLUMN_TYPE_ID)) {
            return nil
        } else if (equal(tableColumn.identifier, COLUMN_NAME_ID)) {
            return file.name
        } else if (equal(tableColumn.identifier, COLUMN_SIZE_ID)) {
            return String(file.size)
        } else {
            return file.dateModified
        }
    }

    func tableView(tableView: NSTableView, dataCellForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSCell? {
        if (tableColumn != nil && equal(tableColumn!.identifier, COLUMN_TYPE_ID)) {
            var image = NSImage(named: "folder")
            return NSCell(imageCell: image)
        } else {
            return nil
        }
    }

    func tableView(tableView: NSTableView, shouldEditTableColumn tableColumn: NSTableColumn?, row: Int) -> Bool {
        return false
    }

    override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        createTable()
        view = tableView
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func keyDown(theEvent: NSEvent) {
        if theEvent.keyCode == 36 {
            let tableView: NSTableView = view as! NSTableView
            var file : File = model.getItems()[tableView.selectedRow]

            if (equal("..", file.name)) {
                var previousName = model.getPath().lastPathComponent
                model.setPath(model.getPath().stringByDeletingLastPathComponent)
                var index = 0
                for file: File in model.getItems() {
                    if equal(previousName, file.name) {
                        break
                    }
                    index++
                }
                if (index >= model.getItems().count) {
                    index = 0
                }
                model.selectedIndex = index
            } else {
                model.selectedIndex = 0
                model.setPath(model.getPath() + "/" + file.name)
            }

            tableView.reloadData()
            tableView.selectRowIndexes(NSIndexSet(index: model.selectedIndex), byExtendingSelection: false)
        } else if theEvent.keyCode == 48 {
            otherPaneController.focus()
        }
    }

    func createColumn(name: String) -> NSTableColumn {
        var column = NSTableColumn(identifier: name)
        var headerCell = NSTableHeaderCell()
        headerCell.objectValue = name
        column.headerCell = headerCell
        return column
    }

    func createTable() {
        tableView = NSTableView(frame: CGRectMake(0, 0, 1, 1))
        var typeColumn = createColumn(COLUMN_TYPE_ID)
        typeColumn.width = 30
        tableView.addTableColumn(typeColumn)
        tableView.addTableColumn(createColumn(COLUMN_NAME_ID))
        tableView.addTableColumn(createColumn(COLUMN_SIZE_ID))
        tableView.addTableColumn(createColumn(COLUMN_DATE_MODIFIED_ID))

        tableView.setDataSource(self);
        tableView.setDelegate(self)
    }
}
