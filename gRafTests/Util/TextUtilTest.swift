//
// Created by Andrey Vokin on 20/09/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Foundation
import XCTest

class TextUtilTest : XCTestCase {
    func testGetSizeTextZero() {
        var result = TextUtil.getSizeText(0)
        XCTAssertEqual("0 bytes", result)
    }

    func testGetSizeText1Byte() {
        var result = TextUtil.getSizeText(1)
        XCTAssertEqual("1 byte", result)
    }

    func testGetSizeTextLessThanKb() {
        var result = TextUtil.getSizeText(523)
        XCTAssertEqual("523 bytes", result)
    }

    func testGetSizeTextLessThanMb() {
        var result = TextUtil.getSizeText(1536)
        XCTAssertEqual("1,5 KB", result)
    }

    func testGetSizeTextLessThanGb() {
        var result = TextUtil.getSizeText(1387386)
        XCTAssertEqual("1,32 MB", result)
    }

    func testGetSizeTextMoreThanGb() {
        var result = TextUtil.getSizeText(1368666858)
        XCTAssertEqual("1,27 GB", result)
    }

    func testGetDateText() {
        var result = TextUtil.getDateText(NSDate(timeIntervalSince1970: 123000))
        XCTAssertEqual("02/01/70 13:10:00", result)
    }
}
