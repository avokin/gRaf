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

            var width = max(im.size.width * magnification, superview!.frame.size.width)
            var height = max(im.size.height * magnification, superview!.frame.size.height)
            var newSize = NSSize(width: width, height: height)
            setFrameSize(newSize)
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
