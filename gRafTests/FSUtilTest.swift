//
// Created by Andrey Vokin on 26/06/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import gRaf
import Foundation
import Cocoa
import XCTest

class FSUtilTest : XCTestCase {
    func testExample() {
        var users = TestUtil.findFileInRoot("Users")

        XCTAssertNotNil(users)
    }

    func testDirectoryCheck() {
        var v  = TestUtil.findFileInRoot("var")
        XCTAssertNotNil(v)
        XCTAssert(v!.isDirectory)
    }

    func testCopyFile() {
        var from = TestUtil.findFileInRoot(".DS_Store")
        XCTAssertNotNil(from)

        var to = TestUtil.findFileInRoot("tmp")
        XCTAssertNotNil(to)

        var newFilePath = FSUtil.getDestinationFileName(from!, to: to!)
        var err: NSError?
        NSFileManager.defaultManager().removeItemAtPath(newFilePath, error: &err);

        XCTAssertFalse(NSFileManager.defaultManager().fileExistsAtPath(newFilePath))

        FSUtil.copyFile(from!.path, to: newFilePath)
        XCTAssert(NSFileManager.defaultManager().fileExistsAtPath(newFilePath))
    }
}
