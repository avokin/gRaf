//
// Created by Andrey Vokin on 16/10/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//
import Cocoa

import Foundation

class ImageViewController: FileViewController {
    var imageView: ImageView!

    override init?(file: File, parentController: FileListPaneController) {
        super.init(file: file, parentController: parentController)
        self.appDelegate = parentController.appDelegate
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

        let width = superView!.frame.width
        let height = superView!.frame.height
        imageView.frame = NSMakeRect(0, 0, width, height)
        imageView.image = image
        if let _image = image {
            imageView.magnification = width / _image.size.width
        }
        super.updateView()
    }

    func createView() {
        imageView = ImageView(frame: NSMakeRect(0, 0, 1, 1))
        resetImage()
    }

    func getCurrentFileIndex() -> Int? {
        for i in 0 ..< parentController.model.getItems().count {
            if parentController.model.getItems()[i] == file {
                return i
            }
        }
        return nil
    }

    override func keyDown(with theEvent: NSEvent) {
        if theEvent.keyCode == 51 || theEvent.keyCode == 100 {
            // del and F8
            FSUtil.deleteFile(file.path)
            openNextImage()
        }
        if theEvent.keyCode == 53 {
            appDelegate.createFileListController(self, root:file.getParent()!, from: file)
        } else if theEvent.keyCode == 123 {
            // <-
            openPreviousImage()
        } else if theEvent.keyCode == 124 {
            // ->
            openNextImage()
        }
    }

    override func focus() {
        window!.makeFirstResponder(self)
        super.focus()
    }

    override func updateView() {
        super.updateView()
        imageView.updateImageSize()
    }

    private func openPreviousImage() {
        if var i = getCurrentFileIndex() {
            while i > 0 {
                i -= 1
                let candidate: File = parentController.model.getItems()[i]

                if ImageUtil.isImageFile(candidate) {
                    file = candidate
                    resetImage()
                    break
                }
            }
        }
    }

    private func openNextImage() {
        if var i = getCurrentFileIndex() {
            while i < parentController.model.getItems().count - 1 {
                i += 1
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
