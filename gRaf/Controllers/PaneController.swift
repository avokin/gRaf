//
// Created by Andrey Vokin on 14/07/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Cocoa
import Foundation

class PaneController : NSViewController {
    var otherPaneController: PaneController!
    var window: NSWindow? = nil
    var appDelegate: AppDelegate! = nil

    override required init?(coder: NSCoder) {
        super.init(coder: coder)
        appDelegate = AppDelegate.getAppDelegate();
    }

    override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        appDelegate = AppDelegate.getAppDelegate()!;
    }

    func focus() {
        window!.makeKeyWindow()
    }

    func viewKeyDown(event: NSEvent) -> Bool {
        return true
    }

    func dispose() {
        otherPaneController = nil
        window = nil
        appDelegate = nil
    }
}
