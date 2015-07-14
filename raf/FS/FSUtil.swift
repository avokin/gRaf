//
// Created by Andrey Vokin on 29/06/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Foundation

public class FSUtil {
    static func getFilesOfDirectory(path: String) -> [File] {
        let fileManager = NSFileManager.defaultManager()

        var files = [File]()

        var allFiles = fileManager.contentsOfDirectoryAtPath(path, error: nil)
        var allSuperFiles = allFiles as! [String]
        for element: String in allSuperFiles {
            var size: UInt64 = 0
            var attributes:NSDictionary? = fileManager.attributesOfItemAtPath(path + "/" + element, error: nil)
            if let _attr = attributes {
                size = _attr.fileSize()
            }
            var file = File(name: element, size: size, dateModified: NSDate())

            files.append(file)
        }

        return files
    }
}
