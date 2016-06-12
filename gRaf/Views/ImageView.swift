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
        if superview == nil {
            return
        }
        if let im = image {
            var minMagnification = getMinimumMagnification()
            if magnification < minMagnification {
                magnification = minMagnification
            } else if (magnification > 1) {
                magnification = 1
            }

            let clipView = superview as! NSClipView

            var newWidth = max(im.size.width * magnification, clipView.frame.size.width)
            var newHeight = max(im.size.height * magnification, clipView.frame.size.height)

            var centerX = clipView.bounds.origin.x + clipView.bounds.width / 2
            var centerY = clipView.bounds.origin.y + clipView.bounds.height / 2
            let oldWidth = frame.size.width
            let oldHeight = frame.size.height

            setFrameSize(NSSize(width: newWidth, height: newHeight))

            var newCenterX = centerX * newWidth / oldWidth
            var newCenterY = centerY * newHeight / oldHeight

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
            if let sv = superview {
                return min(sv.frame.size.width / im.size.width, sv.frame.size.height / im.size.height)
            }
        }
        return 1
    }
}
