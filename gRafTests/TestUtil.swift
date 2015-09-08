//
// Created by Andrey Vokin on 08/09/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Foundation

class TestUtil {
    class func findFileInRoot(name: String) -> File? {
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
