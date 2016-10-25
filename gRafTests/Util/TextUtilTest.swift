//
// Created by Andrey Vokin on 20/09/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Foundation
import XCTest

class TextUtilTest : XCTestCase {
    func testGetSizeTextZero() {
        let result = TextUtil.getSizeText(0)
        XCTAssertEqual("0 bytes", result)
    }

    func testGetSizeText1Byte() {
        let result = TextUtil.getSizeText(1)
        XCTAssertEqual("1 byte", result)
    }

    func testGetSizeTextLessThanKb() {
        let result = TextUtil.getSizeText(523)
        XCTAssertEqual("523 bytes",
                result)
    }

    func testGetSizeTextLessThanMb() {
        let result = TextUtil.getSizeText(1536)
        XCTAssertEqual("1,5 KB", result)
    }

    func testGetSizeTextLessThanGb() {
        let result = TextUtil.getSizeText(1387386)
        XCTAssertEqual("1,32 MB", result)
    }

    func testGetSizeTextMoreThanGb() {
        let result = TextUtil.getSizeText(1368666858)
        XCTAssertEqual("1,27 GB", result)
    }

    func testGetDateText() {
        let result = TextUtil.getDateText(Date(timeIntervalSince1970: 123000))
        XCTAssertEqual("02/01/70 13:10:00", result)
    }
}
