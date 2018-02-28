//
// Created by Andrey Vokin on 29/06/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Foundation

open class FSUtil {
    static func getRoot() -> File {
        return File(path: "/", size: UInt64.max, dateModified: Date(), isDirectory: true)
    }

    static func getFilesOfDirectory(_ path: String) -> [File] {
        let fileManager = FileManager.default

        var files = [File]()

        var allFiles = try? fileManager.contentsOfDirectory(atPath: path)

        if !"/".characters.elementsEqual(path.characters) {
            var linkToParent = File(name: "..", path: path, size: UInt64.max, dateModified: Date(), isDirectory: true)
            files.append(linkToParent)
        }
        if allFiles == nil {
            return files
        }

        for element: String in allFiles! {
            var size: UInt64 = UInt64.max
            var modificationDate: Date? = nil
            var isDirectory = false
            var elementPath = path + "/" + element

            var i = 0
            while i < 3 {
                i += 1
                let attributes = try? fileManager.attributesOfItem(atPath: elementPath) as NSDictionary
                if (attributes != nil) {
                    let _attr = attributes!
                    size = _attr.fileSize()
                    modificationDate = _attr.fileModificationDate()

                    if let fileType1 = _attr.fileType() {
                        if ("NSFileTypeSymbolicLink".characters.elementsEqual(fileType1.characters)) {
                            var newPathElement = try? fileManager.destinationOfSymbolicLink(atPath: elementPath)

                            if newPathElement != nil {
                                if newPathElement!.hasPrefix("/") {
                                    elementPath = newPathElement!
                                } else {
                                    elementPath = path + "/" + newPathElement!
                                }
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

            var prefix = path
            if !prefix.hasSuffix("/") {
                prefix = prefix + "/"
            }
            let file = File(path: prefix + element, size: size, dateModified: modificationDate, isDirectory: isDirectory)

            files.append(file)
        }

        return files
    }

    static func copyFile(_ from: String, to: String) {
        do {
            try FileManager.default.copyItem(atPath: from, toPath: to)
        } catch _ {
        }
    }

    static func moveFile(_ from: String, to: String) {
        do {
            try FileManager.default.moveItem(atPath: from, toPath: to)
        } catch _ {
        }
    }

    static func deleteFile(_ filePath: String) {
        do {
            try FileManager.default.removeItem(atPath: filePath)
        } catch _ {
        }
    }

    static func fileSize(_ file: File) -> UInt64 {
        return fileSize(file.path)
    }

    static func fileSize(_ path: String) -> UInt64 {
        let attributes:NSDictionary? = try! FileManager.default.attributesOfItem(atPath: path) as NSDictionary?

        if let _attr = attributes {
            return _attr.fileSize()
        }
        return 0
    }

    static func getDestinationFileName(_ from: File, to: File) -> String {
        var destPath = to.path
        if to.isDirectory {
            destPath = to.path + "/" + from.name
        }
        return destPath
    }

    static func rename(_ file: File, newName: String) {
        let newPath = NSURL(fileURLWithPath: file.path).deletingLastPathComponent!.path
        do {
            try FileManager.default.moveItem(atPath: file.path, toPath: newPath)
        } catch _ {
        }
    }

    static func getFileContent(_ file: File) -> String? {
        let result = try? String(contentsOfFile: file.path, encoding: String.Encoding.utf8)
        return result
    }

    static func setFileContent(_ file: File, content: String) {
        do {
            try content.write(toFile: file.path, atomically: false, encoding: String.Encoding.utf8)
        } catch _ {
        };
    }

    static func resolveSymlink(at url: URL) -> String? {
        do {
            let resourceValues = try url.resourceValues(forKeys: [.isAliasFileKey])
            if resourceValues.isAliasFile! {
                let originalURL = try URL(resolvingAliasFileAt: url)
                return originalURL.path
            }
        } catch  {
           // ignore
        }
        return nil
    }
}
