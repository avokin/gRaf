//
// Created by Andrey Vokin on 22/09/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Cocoa
import Foundation

class FileViewPaneController : PaneController, NSTextViewDelegate {
    var textView: NSTextView!
    override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        createView()
        view = textView
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func createView() {
        textView = NSTextView(frame: NSMakeRect(0, 0, 1000, 1000))
        textView.delegate = self
    }

    func textDidChange(notification: NSNotification) {
        var a: NSString = self.textView.string!;
        var size = a.sizeWithAttributes([NSFontAttributeName: self.textView.font!])

        self.textView.frame = NSMakeRect(self.textView.frame.origin.x, self.textView.frame.origin.y, round(size.width + 15), round(size.height))
    }

    func textAttributes() -> [String: AnyObject] {
        return [NSFontAttributeName: self.textView.font!]
    }
}
