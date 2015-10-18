//
// Created by Andrey Vokin on 16/10/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//
import Cocoa

import Foundation

class ImageViewPaneController : ChildController {
    var file: File!
    var imageView: NSImageView!

    init?(file: File, parentController: FileListPaneController) {
        super.init(parentController: parentController)
        self.file = file
        createView()
        view = imageView
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func resetImage() {
        var image = NSImage(contentsOfFile: file.path)

        var width = image != nil ? image!.size.width : 0
        var height = image != nil ? image!.size.height : 0
        imageView.frame = NSMakeRect(0, 0, width, height)
        imageView.image = image
    }

    func createView() {
        imageView = NSImageView(frame: NSMakeRect(0, 0, 1, 1))
        resetImage()
    }

    func getCurrentFileIndex() -> Int? {
        for (var i = 0; i < parentController.model.getItems().count; i++) {
            if parentController.model.getItems()[i] == file {
                return i
            }
        }
        return nil
    }

    override func keyDown(theEvent: NSEvent) {
        if theEvent.keyCode == 53 {
            appDelegate.createFileListController(self, root:file.getParent()!, from: file)
        } else if theEvent.keyCode == 123 {
            if var i = getCurrentFileIndex() {
                while i > 0 {
                    i--
                    var candidate: File = parentController.model.getItems()[i]
                    if equal(candidate.name.lowercaseString.pathExtension, "jpg") {
                        file = candidate
                        resetImage()
                        break
                    }
                }
            }
        } else if theEvent.keyCode == 124 {
            if var i = getCurrentFileIndex() {
                while i < parentController.model.getItems().count - 1 {
                    i++
                    var candidate: File = parentController.model.getItems()[i]
                    if equal(candidate.name.lowercaseString.pathExtension, "jpg") {
                        file = candidate
                        resetImage()
                        break
                    }
                }
            }
        }
    }

    override func focus() {
        window!.makeFirstResponder(self)
        super.focus()
    }
}
