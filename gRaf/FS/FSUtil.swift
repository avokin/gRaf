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
            var linkToParent = File(name: "..", path: path, size: UInt64.max, dateModified: NSDate(), isDirectory: true)
            files.append(linkToParent)
        }

        if allFiles is [String] {
            var allSuperFiles = allFiles as! [String]
            for element: String in allSuperFiles {
                var size: UInt64 = UInt64.max
                var modificationDate: NSDate? = nil
                var isDirectory = false
                var elementPath = path + "/" + element

                var i = 0
                while i < 3 {
                    i++
                    var attributes:NSDictionary? = fileManager.attributesOfItemAtPath(elementPath, error: nil)
                    if let _attr = attributes {
                        size = _attr.fileSize()
                        modificationDate = _attr.fileModificationDate()

                        if let fileType1 = _attr.fileType() {
                            if (equal("NSFileTypeSymbolicLink", fileType1)) {
                                var newPathElement = fileManager.destinationOfSymbolicLinkAtPath(elementPath, error: nil)

                                if newPathElement != nil {
                                    elementPath = path + "/" + newPathElement!
                                } else {
                                    break;
                                }
                            } else {
                                if equal("NSFileTypeDirectory", fileType1) {
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
        }

        return files
    }

    static func copyFile(from: String, to: String) {
        NSFileManager.defaultManager().copyItemAtPath(from, toPath: to, error: nil)
    }

    static func moveFile(from: String, to: String) {
        NSFileManager.defaultManager().moveItemAtPath(from, toPath: to, error: nil)
    }

    static func deleteFile(filePath: String) {
        NSFileManager.defaultManager().removeItemAtPath(filePath, error: nil)
    }

    static func fileSize(file: File) -> UInt64 {
        return fileSize(file.path)
    }

    static func fileSize(path: String) -> UInt64 {
        var attributes:NSDictionary? = NSFileManager.defaultManager().attributesOfItemAtPath(path, error: nil)

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

    static func getFileContent(file: File) {
        let text2 = String(contentsOfFile: file.path, encoding: NSUTF8StringEncoding, error: nil)
    }
}
