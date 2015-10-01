//
// Created by Andrey Vokin on 21/09/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Foundation

import XCTest

class PaneModelTest : XCTestCase {
    func testParentIsAlwaysOnTop() {
        var model = PaneModel()

        var bin = TestUtil.findFileInRoot("bin")
        model.setRoot(bin!)

        model.setSortDescriptor(NSSortDescriptor(key: "size", ascending: false))

        var first = model.getItems()[0]
        XCTAssertEqual("..", first.name)
    }

    func testSelectChild() {
        var root = File(name: "/", path: "/", size: UInt64.max, dateModified: NSDate(), isDirectory: true);
        var v  = TestUtil.findFileInRoot("var")!

        var model = PaneModel(root: root, from: v)

        XCTAssertEqual("var", model.getItems()[model.selectedIndex].name)
    }
}
