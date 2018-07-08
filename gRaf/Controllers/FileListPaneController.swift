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
        self.appDelegate.updateStatus(root.path)
        if from != nil {
            model.selectFiles([from!.name])
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

        tableView.selectRowIndexes(model.selectedIndexSet, byExtendingSelection: false)
        tableView.scrollRowToVisible(model.selectedIndexSet.first!)
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
            model.selectFiles(["\(object!)"])
            // ToDo: make as callback of refresh()
            tableView.reloadData()
            tableView.selectRowIndexes(model.selectedIndexSet, byExtendingSelection: false)
            tableView.scrollRowToVisible(model.selectedIndexSet.first!)
        }
    }

    public func tableViewSelectionDidChange(_ notification: Notification) {
        model.selectFiles(tableView.selectedRowIndexes)
    }

    override func keyDown(with theEvent: NSEvent) {
        if KeyboardUtil.isCommand_C_Pressed(theEvent) {
            var selectedFiles = model.getSelectedFiles()
            if selectedFiles.count == 1 {
                KeyboardUtil.copyToClipboard(selectedFiles[0].path)
            }

            return
        }
        if theEvent.keyCode == 48 {
            // Tab
            otherPaneController.focus()
            return
        }

        if theEvent.keyCode == 98 {
            // F7
            let newDirectoryName = UIUtil.getString(title: "Create New Directory")
            if newDirectoryName != nil {
                let newDirectoryPath = model.getRoot().path + "/" + newDirectoryName!
                FSUtil.createFolder(newDirectoryPath)
                model.refresh(false)
                model.selectFiles([newDirectoryName!])
                refresh()
            }
            return
        }
        if (tableView.selectedRow < 0) {
            return
        }
        let file = model.getItems()[tableView.selectedRow]
        if theEvent.keyCode == 99 {
            let file = model.getItems()[tableView.selectedRow]
            appDelegate.openFileViewController(self, file: file)
        } else if theEvent.keyCode == 36 { // Enter
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
                model.selectFile(previousRoot.name)
            } else {
                var selectedFiles = model.getSelectedFiles()
                if selectedFiles.count == 1 {
                    model.setRoot(selectedFiles[0])
                }
            }

            refresh()
        } else if theEvent.keyCode == 96 {
            // F5
            if let fileListController = otherPaneController as? FileListPaneController {
                let to = fileListController.model.getRoot();
                let selectedFiles = getSelectedFiles()
                FileActions.copyFileAction(selectedFiles, to: to)
                tableView.selectRowIndexes(IndexSet(), byExtendingSelection: false)
            }
        } else if theEvent.keyCode == 97 {
            // F6
            if let fileListController = otherPaneController as? FileListPaneController {
                let to = fileListController.model.getRoot();
                let filesFrom = getSelectedFiles()
                FileActions.moveFileAction(filesFrom, to: to)
            }
        } else if theEvent.keyCode == 100 {
            // Backspace
            let selectedFiles = getSelectedFiles()
            FileActions.deleteFileAction(selectedFiles)
        }
    }

    func refresh() {
        DispatchQueue.main.async {
            let selectedIndexSet = self.model.selectedIndexSet
            self.appDelegate.updateStatus(self.model.getRoot().path)
            self.tableView.reloadData()
            self.model.selectFiles(selectedIndexSet)
            self.tableView.selectRowIndexes(selectedIndexSet, byExtendingSelection: false)
            self.tableView.scrollRowToVisible(self.model.selectedIndexSet.first!)
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
        tableView.allowsMultipleSelection = true

        tableView.dataSource = self;
        tableView.delegate = self
    }

    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        var descriptors = tableView.sortDescriptors
        
        model.setSortDescriptor(descriptors[0])
        tableView.reloadData()
    }

    private func getSelectedFiles() -> [File] {
        return tableView.selectedRowIndexes.map{model.getItems()[$0]}
    }
}
