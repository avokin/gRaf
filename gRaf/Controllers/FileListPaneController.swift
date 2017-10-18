//
// Created by Andrey Vokin on 22/09/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Cocoa
import Foundation

class FileListPaneController : PaneController, NSTableViewDataSource, NSTableViewDelegate {
    var model = PaneModel()
    var tableView: NSTableView!

    let COLUMN_TYPE_ID = "Type"
    let COLUMN_NAME_ID = "Name"
    let COLUMN_SIZE_ID = "Size"
    let COLUMN_DATE_MODIFIED_ID = "Date modified"

    init?(root: File, from: File?) {
        super.init(nibName: nil, bundle: nil)

        model.setRoot(root)
        self.appDelegate.updateTopBar(root.path)
        if from != nil {
            model.selectChild(from!.name)
        }

        createTable()
        view = tableView

        model.callback = refresh
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        tableView.selectRowIndexes(IndexSet(integer: model.selectedIndex), byExtendingSelection: false)
        tableView.scrollRowToVisible(model.selectedIndex)
    }

    override func focus() {
        super.focus()
        window!.makeFirstResponder(tableView)
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return model.getItems().count
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let file: File = model.getItems()[row]
        if (tableColumn!.identifier.characters.elementsEqual(COLUMN_TYPE_ID.characters)) {
            return nil
        } else if (tableColumn!.identifier.characters.elementsEqual(COLUMN_NAME_ID.characters)) {
            return file.name
        } else if (tableColumn!.identifier.characters.elementsEqual(COLUMN_SIZE_ID.characters)) {
            if file.isDirectory {
                return ""
            }
            return TextUtil.getSizeText(file.size)
        } else {
            if let modificationDate = file.dateModified {
                return TextUtil.getDateText(modificationDate)
            } else {
                return ""
            }
        }
    }

    func tableView(_ tableView: NSTableView, dataCellFor tableColumn: NSTableColumn?, row: Int) -> NSCell? {
        if tableColumn != nil && tableColumn!.identifier.characters.elementsEqual(COLUMN_TYPE_ID.characters) {
            let file: File = model.getItems()[row]
            var image = NSImage(named: "file")
            if file.isDirectory {
                image = NSImage(named: "folder")
            }
            return NSCell(imageCell: image)
        } else {
            return nil
        }
    }

    func tableView(_ tableView: NSTableView, shouldEdit tableColumn: NSTableColumn?, row: Int) -> Bool {
        return tableColumn != nil && tableColumn!.identifier.characters.elementsEqual(COLUMN_NAME_ID.characters)
    }

    func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int) {
        if object != nil {
            let file = model.getItems()[row]
            FSUtil.rename(file, newName: "\(object!)")
            model.clearCaches()
            model.selectChild("\(object!)")
            // ToDo: make as callback of refresh()
            tableView.reloadData()
            tableView.selectRowIndexes(IndexSet(integer: model.selectedIndex), byExtendingSelection: false)
            tableView.scrollRowToVisible(model.selectedIndex)
        }
    }

    override func keyDown(with theEvent: NSEvent) {
        if theEvent.keyCode == 99 {
            let file = model.getItems()[tableView.selectedRow]
            appDelegate.openFileViewController(self, file: file)
        } else if theEvent.keyCode == 36 { // Enter
            let tableView: NSTableView = view as! NSTableView
            let file : File = model.getItems()[tableView.selectedRow]

            if theEvent.modifierFlags.intersection(NSEventModifierFlags.shift) != [] || !file.isDirectory {
                let showFolder = Process()
                if file.isDirectory {
                    showFolder.launchPath = "/usr/bin/open"
                    showFolder.arguments = [file.path]
                    showFolder.launch()
                } else {
                    NSWorkspace.shared().openFile(file.path)
                }

                return
            }

            if ("..".characters.elementsEqual(file.name.characters)) {
                let previousRoot = model.getRoot()
                let newRoot = previousRoot.getParent()
                model.setRoot(newRoot!)
                model.selectChild(previousRoot.name)
            } else {
                // ToDo: use model.selectedIndex
                let selectedFile = model.getItems()[tableView.selectedRow]
                model.selectedIndex = 0
                model.setRoot(selectedFile)
            }

            self.appDelegate.updateTopBar(model.getRoot().path)
            tableView.reloadData()
            tableView.selectRowIndexes(IndexSet(integer: model.selectedIndex), byExtendingSelection: false)
            tableView.scrollRowToVisible(model.selectedIndex)
        } else if theEvent.keyCode == 48 {
            otherPaneController.focus()
        } else if theEvent.keyCode == 96 {
            // ToDo: use model.selectedIndex
            if let fileListController = otherPaneController as? FileListPaneController {
                let from = model.getItems()[tableView.selectedRow]
                let to = fileListController.model.getRoot();

                FileActions.copyFileAction(from, to: to)
            }
        } else if theEvent.keyCode == 97 {
            if let fileListController = otherPaneController as? FileListPaneController {
                let from = model.getItems()[tableView.selectedRow]
                let to = fileListController.model.getRoot();

                FileActions.moveFileAction(from, to: to)
            }
        } else if theEvent.keyCode == 100 {
            let file = model.getItems()[tableView.selectedRow]
            FileActions.deleteFileAction(file)
        } else if theEvent.keyCode == 116 {
            if theEvent.modifierFlags.intersection(NSEventModifierFlags.function) != [] {
                model.selectedIndex = 0
                tableView.selectRowIndexes(IndexSet(integer: model.selectedIndex), byExtendingSelection: false)
                tableView.scrollRowToVisible(model.selectedIndex)
            }
        } else {
            super.keyDown(with: theEvent)
        }
    }

    func refresh() {
        DispatchQueue.main.async {
            self.appDelegate.updateTopBar(self.model.getRoot().path)
            self.tableView.reloadData()
        }
    }

    func createColumn(_ name: String) -> NSTableColumn {
        let column = NSTableColumn(identifier: name)
        let headerCell = NSTableHeaderCell()
        headerCell.objectValue = name
        column.headerCell = headerCell

        column.sortDescriptorPrototype = NSSortDescriptor(key: name, ascending: true)
        return column
    }

    func createTable() {
        tableView = FileTableView()
        let typeColumn = createColumn(COLUMN_TYPE_ID)
        typeColumn.width = 30
        tableView.addTableColumn(typeColumn)

        let nameColumn = createColumn(COLUMN_NAME_ID)
        nameColumn.width = 300
        tableView.addTableColumn(nameColumn)

        let sizeColumn = createColumn(COLUMN_SIZE_ID)
        sizeColumn.width = 80
        tableView.addTableColumn(sizeColumn)

        tableView.addTableColumn(createColumn(COLUMN_DATE_MODIFIED_ID))

        tableView.focusRingType = NSFocusRingType.none

        tableView.dataSource = self;
        tableView.delegate = self
    }

    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        var descriptors = tableView.sortDescriptors
        
        model.setSortDescriptor(descriptors[0])
        tableView.reloadData()
    }
}
