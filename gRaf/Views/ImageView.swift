//
// Created by Andrey Vokin on 18/10/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Cocoa
import Foundation

class ImageView : NSImageView {
    var magnification: CGFloat = 1

    override func viewDidEndLiveResize() {
        updateImageSize()
    }

    override func magnifyWithEvent(event: NSEvent) {
        super.magnifyWithEvent(event)
        magnification += event.magnification
        updateImageSize()
    }

    func updateImageSize() {
        if let im = image {
            var minMagnification = getMinimumMagnification()
            if magnification < minMagnification {
                magnification = minMagnification
            } else if (magnification > 1) {
                magnification = 1
            }

            var newWidth = max(im.size.width * magnification, superview!.frame.size.width)
            var newHeight = max(im.size.height * magnification, superview!.frame.size.height)
            var newSize = NSSize(width: newWidth, height: newHeight)

            let clipView = superview as! NSClipView
            var centerX = clipView.bounds.origin.x + clipView.bounds.width / 2
            var centerY = clipView.bounds.origin.y + clipView.bounds.height / 2
            let oldWidth = frame.size.width
            let oldHeight = frame.size.height

            setFrameSize(newSize)

            var newCenterX = centerX * newSize.width / oldWidth
            var newCenterY = centerY * newSize.height / oldHeight

            var minX = newCenterX - clipView.bounds.width / 2
            var minY = newCenterY - clipView.bounds.height / 2

            var rect = NSMakeRect(minX, minY, clipView.bounds.width, clipView.bounds.height)
            clipView.scrollRectToVisible(rect)
        }
    }

    func fitToSize() {
        magnification = 0
        updateImageSize()
    }

    private func getMinimumMagnification() -> CGFloat {
        if let im = image {
            return min(superview!.frame.size.width / im.size.width, superview!.frame.size.height / im.size.height)
        } else {
            return 1
        }
    }
}
