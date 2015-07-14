//
// Created by Andrey Vokin on 26/06/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import raf
import Foundation
import Cocoa
import XCTest
import raf

class FSUtilTest : XCTestCase {
    func testExample() {
        var files = FSUtil.getFilesOfDirectory("/")

        XCTAssertGreaterThan(files.count, 0)
        XCTAssertTrue(contains(files, "Users"))
    }
}
