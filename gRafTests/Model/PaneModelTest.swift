//
// Created by Andrey Vokin on 21/09/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Foundation

import XCTest

class PaneModelTest : XCTestCase {
    func testParentIsAlwaysOnTop() {
        let model = PaneModel()

        let bin = TestUtil.findFileInRoot("bin")
        model.setRoot(bin!)

        model.setSortDescriptor(NSSortDescriptor(key: "size", ascending: false))

        let first = model.getItems()[0]
        XCTAssertEqual("..", first.name)
    }

    func testSelectChild() {
        let root = File(name: "/", path: "/", size: UInt64.max, dateModified: Date(), isDirectory: true);
        let v  = TestUtil.findFileInRoot("var")!

        let model = PaneModel(root: root, from: v)

        XCTAssertEqual("var", model.getItems()[model.selectedIndex].name)
    }
}
