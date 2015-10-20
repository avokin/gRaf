//
// Created by Andrey Vokin on 18/10/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Foundation
import XCTest

class ImageUtilTest : XCTestCase {
    func testIsImageFile() {
        let imageFile = File(name: "abc.jpg", path: "/abc.jpg", size: UInt64.max, dateModified: NSDate(), isDirectory: false)
        XCTAssertTrue(ImageUtil.isImageFile(imageFile))
    }

    func testIsImageFileWithUpCaseExtension() {
        let imageFile = File(name: "ABC.JPG", path: "/ABC.JPG", size: UInt64.max, dateModified: NSDate(), isDirectory: false)
        XCTAssertTrue(ImageUtil.isImageFile(imageFile))
    }

    func testWhenDirectory() {
        let directory = File(name: "abc.jpg", path: "/abc.jpg", size: UInt64.max, dateModified: NSDate(), isDirectory: true)
        XCTAssertFalse(ImageUtil.isImageFile(directory))
    }

    func testTextFile() {
        let textFile = File(name: "abc.txt", path: "/abc.txt", size: UInt64.max, dateModified: NSDate(), isDirectory: false)
        XCTAssertFalse(ImageUtil.isImageFile(textFile))
    }
}
