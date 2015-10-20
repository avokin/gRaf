//
// Created by Andrey Vokin on 18/10/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Cocoa
import Foundation

class ImageView : NSImageView {
    override func viewDidEndLiveResize() {
        setFrameSize(superview!.frame.size)
    }
}
