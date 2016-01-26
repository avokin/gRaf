//
// Created by Andrey Vokin on 16/10/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//
import Cocoa

import Foundation

class ImageViewPaneController : ChildController {
    var file: File!
    var imageView: ImageView!

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
        let image = NSImage(contentsOfFile: file.path)

        var superView = parentController.view.superview
        if superView == nil {
            superView = imageView.superview
        }

        var width = superView!.frame.width
        var height = superView!.frame.height
        imageView.frame = NSMakeRect(0, 0, width, height)
        imageView.image = image
        if let _image = image {
            imageView.magnification = width / _image.size.width
        }
    }

    override func viewWillDisappear() {
        super.viewWillDisappear()
        imageView.fitToSize()
    }

    func createView() {
        imageView = ImageView(frame: NSMakeRect(0, 0, 1, 1))
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
                    let candidate: File = parentController.model.getItems()[i]

                    if ImageUtil.isImageFile(candidate) {
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
                    let candidate: File = parentController.model.getItems()[i]
                    if ImageUtil.isImageFile(candidate) {
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
