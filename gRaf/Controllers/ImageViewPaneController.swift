//
// Created by Andrey Vokin on 16/10/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//
import Cocoa

import Foundation

class ImageViewPaneController : PaneController {
    var file: File!
    var imageView: NSImageView!

    init?(file: File) {
        super.init(nibName: nil, bundle: nil)
        self.file = file
        createView()
        view = imageView
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func createView() {
        var image = NSImage(contentsOfFile: file.path)

        var width = image != nil ? image!.size.width : 0
        var height = image != nil ? image!.size.height : 0

        imageView = NSImageView(frame: NSMakeRect(0, 0, width, height))
        imageView.image = image
    }

    override func keyDown(theEvent: NSEvent) {
        if theEvent.keyCode == 53 {
            appDelegate.createFileListController(self, root:file.getParent()!, from: file)
        }
    }

    override func focus() {
        window!.makeFirstResponder(self)
        super.focus()
    }
}
