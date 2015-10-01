//
// Created by Andrey Vokin on 02/10/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Foundation

import XCTest

class FileTest : XCTestCase {
    func testGetParentWhenRoot() {
        var root = FSUtil.getRoot()

        XCTAssertNil(root.getParent())
    }

    func testParentRootForTmp() {
        var tmp = TestUtil.findFileInRoot("tmp")!
        XCTAssertNotNil(tmp.getParent())
        XCTAssertEqual(tmp.getParent()!.name, "/")
    }
}
