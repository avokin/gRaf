//
// Created by Andrey Vokin on 29/06/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Foundation

public class FSUtil {
    static func getFilesOfDirectory(path: String) -> [String] {
        let fileManager = NSFileManager.defaultManager()

        var files = [String]()

        var allFiles = fileManager.contentsOfDirectoryAtPath(path, error: nil)
        var allSuperFiles = allFiles as! [String]
        for element: String in allSuperFiles {
            println(element)
            files.append(element)
        }

        return files
    }
}
