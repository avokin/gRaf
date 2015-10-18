//
// Created by Andrey Vokin on 18/10/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Foundation
import XCTest

class ImageUtilTest : XCTestCase {
    func testIsImageFile() {
        var imageFile = File(name: "abc.jpg", path: "/abc.jpg", size: UInt64.max, dateModified: NSDate(), isDirectory: false)
        XCTAssertTrue(ImageUtil.isImageFile(imageFile))
    }

    func testIsImageFileWithUpCaseExtension() {
        var imageFile = File(name: "ABC.JPG", path: "/ABC.JPG", size: UInt64.max, dateModified: NSDate(), isDirectory: false)
        XCTAssertTrue(ImageUtil.isImageFile(imageFile))
    }

    func testWhenDirectory() {
        var directory = File(name: "abc.jpg", path: "/abc.jpg", size: UInt64.max, dateModified: NSDate(), isDirectory: true)
        XCTAssertFalse(ImageUtil.isImageFile(directory))
    }

    func testTextFile() {
        var textFile = File(name: "abc.txt", path: "/abc.txt", size: UInt64.max, dateModified: NSDate(), isDirectory: false)
        XCTAssertFalse(ImageUtil.isImageFile(textFile))
    }
}
