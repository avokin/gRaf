//
// Created by Andrey Vokin on 29/06/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Foundation

public class FSUtil {
    static func getRoot() -> File {
        return File(name: "/", path: "/", size: UInt64.max, dateModified: NSDate(), isDirectory: true)
    }

    static func getFilesOfDirectory(path: String) -> [File] {
        let fileManager = NSFileManager.defaultManager()

        var files = [File]()

        var allFiles = try? fileManager.contentsOfDirectoryAtPath(path)

        if !"/".characters.elementsEqual(path.characters) {
            var linkToParent = File(name: "..", path: path, size: UInt64.max, dateModified: NSDate(), isDirectory: true)
            files.append(linkToParent)
        }
        if allFiles == nil {
            return files
        }

        for element: String in allFiles! {
            var size: UInt64 = UInt64.max
            var modificationDate: NSDate? = nil
            var isDirectory = false
            var elementPath = path + "/" + element

            var i = 0
            while i < 3 {
                i++
                var attributes:NSDictionary? = try? fileManager.attributesOfItemAtPath(elementPath)
                if let _attr = attributes {
                    size = _attr.fileSize()
                    modificationDate = _attr.fileModificationDate()

                    if let fileType1 = _attr.fileType() {
                        if ("NSFileTypeSymbolicLink".characters.elementsEqual(fileType1.characters)) {
                            var newPathElement = try? fileManager.destinationOfSymbolicLinkAtPath(elementPath)

                            if newPathElement != nil {
                                elementPath = path + "/" + newPathElement!
                            } else {
                                break;
                            }
                        } else {
                            if "NSFileTypeDirectory".characters.elementsEqual(fileType1.characters) {
                                isDirectory = true
                                size = UInt64.max
                                break;
                            }
                        }
                    }
                } else {
                    break
                }
            }

            var file = File(name: element, path: path + "/" + element, size: size, dateModified: modificationDate, isDirectory: isDirectory)

            files.append(file)
        }

        return files
    }

    static func copyFile(from: String, to: String) {
        do {
            try NSFileManager.defaultManager().copyItemAtPath(from, toPath: to)
        } catch _ {
        }
    }

    static func moveFile(from: String, to: String) {
        do {
            try NSFileManager.defaultManager().moveItemAtPath(from, toPath: to)
        } catch _ {
        }
    }

    static func deleteFile(filePath: String) {
        do {
            try NSFileManager.defaultManager().removeItemAtPath(filePath)
        } catch _ {
        }
    }

    static func fileSize(file: File) -> UInt64 {
        return fileSize(file.path)
    }

    static func fileSize(path: String) -> UInt64 {
        let attributes:NSDictionary? = try? NSFileManager.defaultManager().attributesOfItemAtPath(path)

        if let _attr = attributes {
            return _attr.fileSize()
        }
        return 0
    }

    static func getDestinationFileName(from: File, to: File) -> String {
        var destPath = to.path
        if to.isDirectory {
            destPath = to.path + "/" + from.name
        }
        return destPath
    }

    static func rename(file: File, newName: String) {
        if let newPath = NSURL(fileURLWithPath: file.path).URLByDeletingLastPathComponent!.path {
            do {
                try NSFileManager.defaultManager().moveItemAtPath(file.path, toPath: newPath)
            } catch _ {
            }
        }
    }

    static func getFileContent(file: File) -> String? {
        let result = try? String(contentsOfFile: file.path, encoding: NSUTF8StringEncoding)
        return result
    }

    static func setFileContent(file: File, content: String) {
        do {
            try content.writeToFile(file.path, atomically: false, encoding: NSUTF8StringEncoding)
        } catch _ {
        };
    }
}
