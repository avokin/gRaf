//
// Created by Andrey Vokin on 08/09/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import gRaf
import Foundation
import Cocoa
import XCTest

class CopyFileTest : XCTestCase  {
    func testFileCopy() {
        var from = TestUtil.findFileInRoot(".DS_Store")
        XCTAssertNotNil(from)

        var to = TestUtil.findFileInRoot("tmp")
        XCTAssertNotNil(to)

        var newFilePath = to!.path + "/" + from!.name
        var err: NSError?
        NSFileManager.defaultManager().removeItemAtPath(newFilePath, error: &err);
        //XCTAssertNil(err)
        XCTAssertFalse(NSFileManager.defaultManager().fileExistsAtPath(newFilePath))

        CopyFileAction.perform(from!, to: to!)
        XCTAssert(NSFileManager.defaultManager().fileExistsAtPath(newFilePath))
    }
}
