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
        window!.makeKeyWindow()
        let tableView: NSTableView = view as! NSTableView
        window!.makeFirstResponder(tableView)
    }

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return model.getItems().count
    }

    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        var file: File = model.getItems()[row]
        if (equal(tableColumn!.identifier, COLUMN_TYPE_ID)) {
            return nil
        } else if (equal(tableColumn!.identifier, COLUMN_NAME_ID)) {
            return file.name
        } else if (equal(tableColumn!.identifier, COLUMN_SIZE_ID)) {
            if file.isDirectory {
                return ""
            }
            return TextUtil.getSizeText(file.size)
        } else {
            return file.dateModified
        }
    }

    func tableView(tableView: NSTableView, dataCellForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSCell? {
        if (tableColumn != nil && equal(tableColumn!.identifier, COLUMN_TYPE_ID)) {
            var file: File = model.getItems()[row]
            var image = NSImage(named: "file")
            if file.isDirectory {
                image = NSImage(named: "folder")
            }
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

            if theEvent.modifierFlags & NSEventModifierFlags.ShiftKeyMask != nil {
                let showFolder = NSTask()
                if file.isDirectory {
                    showFolder.launchPath = "/usr/bin/open"
                    showFolder.arguments = [file.path]
                    showFolder.launch()
                } else {
                    NSWorkspace.sharedWorkspace().openFile(file.path)
                }

                return
            }

            if (equal("..", file.name)) {
                var previousName = model.getPath().lastPathComponent

                // ToDo: get parent from current root
                var newPath = model.getPath().stringByDeletingLastPathComponent
                var newRoot = File(name: newPath.lastPathComponent, path: newPath, size: UInt64.max, dateModified: NSDate(), isDirectory: true)
                model.setRoot(newRoot)

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
                // ToDo: use model.selectedIndex
                var selectedFile = model.getItems()[tableView.selectedRow]
                model.selectedIndex = 0
                model.setRoot(selectedFile)
            }

            tableView.reloadData()
            tableView.selectRowIndexes(NSIndexSet(index: model.selectedIndex), byExtendingSelection: false)
            tableView.scrollRowToVisible(model.selectedIndex)
        } else if theEvent.keyCode == 48 {
            otherPaneController.focus()
        } else if theEvent.keyCode == 96 {
            // ToDo: use model.selectedIndex
            var from = model.getItems()[tableView.selectedRow]
            var to = otherPaneController.model.getRoot();

            FileActions.copyFileAction(from, to: to)
            refresh()
        } else if theEvent.keyCode == 97 {
            var from = model.getItems()[tableView.selectedRow]
            var to = otherPaneController.model.getRoot();

            FileActions.moveFileAction(from, to: to)
            refresh()
        } else if theEvent.keyCode == 100 {
            var file = model.getItems()[tableView.selectedRow]
            FileActions.deleteFileAction(file)
            refresh()
        } else if theEvent.keyCode == 116 {
            if theEvent.modifierFlags & NSEventModifierFlags.FunctionKeyMask != nil {
                model.selectedIndex = 0
                tableView.selectRowIndexes(NSIndexSet(index: model.selectedIndex), byExtendingSelection: false)
                tableView.scrollRowToVisible(model.selectedIndex)
            }
        }
    }

    func refresh() {
        focus()
        model.clearCaches()
        tableView.reloadData()
        otherPaneController.model.clearCaches()
        otherPaneController.tableView.reloadData()
    }

    func createColumn(name: String) -> NSTableColumn {
        var column = NSTableColumn(identifier: name)
        var headerCell = NSTableHeaderCell()
        headerCell.objectValue = name
        column.headerCell = headerCell

        column.sortDescriptorPrototype = NSSortDescriptor(key: name, ascending: true)
        return column
    }

    func createTable() {
        tableView = NSTableView(frame: CGRectMake(0, 0, 1, 1))
        var typeColumn = createColumn(COLUMN_TYPE_ID)
        typeColumn.width = 30
        tableView.addTableColumn(typeColumn)

        var nameColumn = createColumn(COLUMN_NAME_ID)
        nameColumn.width = 300
        tableView.addTableColumn(nameColumn)

        var sizeColumn = createColumn(COLUMN_SIZE_ID)
        sizeColumn.width = 80
        tableView.addTableColumn(sizeColumn)

        tableView.addTableColumn(createColumn(COLUMN_DATE_MODIFIED_ID))

        tableView.focusRingType = NSFocusRingType.None

        tableView.setDataSource(self);
        tableView.setDelegate(self)
    }

    func tableView(tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [AnyObject]) {
        var descriptors = tableView.sortDescriptors
        var first = descriptors[0]
        model.setSortDescriptor(first as! NSSortDescriptor)
        tableView.reloadData()
    }

}
