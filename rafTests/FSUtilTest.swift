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
        var users = findFileInRoot("Users")

        XCTAssertNotNil(users)
    }

    func testDirectoryCheck() {
        var v  = findFileInRoot("var")
        XCTAssertNotNil(v)
        XCTAssert(v!.isDirectory)
    }

    private

    func findFileInRoot(name: String) -> File? {
        var files = FSUtil.getFilesOfDirectory("/")

        var result: File? = nil
        for file: File in files {
            if equal(file.name, name) {
                result = file
                break;
            }
        }

        return result
    }
}
