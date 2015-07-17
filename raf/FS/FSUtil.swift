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

        if !equal("/", path) {
            var linkToParent = File(name: "..", size: UInt64.max, dateModified: NSDate(), isDirectory: true)
            files.append(linkToParent)
        }

        if allFiles is [String] {
            var allSuperFiles = allFiles as! [String]
            for element: String in allSuperFiles {
                var size: UInt64 = 0
                var isDirectory = false
                var attributes:NSDictionary? = fileManager.attributesOfItemAtPath(path + "/" + element, error: nil)
                if let _attr = attributes {
                    size = _attr.fileSize()
                    if let fileType1 = _attr.fileType() {
                        if equal("NSFileTypeDirectory", fileType1) {
                            isDirectory = true
                        }
                    }
                }
                var file = File(name: element, size: size, dateModified: NSDate(), isDirectory: isDirectory)

                files.append(file)
            }
        }

        return files
    }
}
