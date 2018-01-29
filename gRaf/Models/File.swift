//
// Created by Andrey Vokin on 14/07/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Foundation

class File: NSObject{
    var name: String
    var path: String
    var size: UInt64
    var dateModified: Date?
    var isDirectory: Bool

    fileprivate var parent: File?

    init(name: String, path: String, size: UInt64, dateModified: Date?, isDirectory: Bool) {
        self.name = name
        self.path = path
        self.size = size
        self.dateModified = dateModified
        self.isDirectory = isDirectory
    }

    init(path: String, size: UInt64, dateModified: Date?, isDirectory: Bool) {
        self.name = NSURL(fileURLWithPath: path).lastPathComponent!
        self.path = path
        self.size = size
        self.dateModified = dateModified
        self.isDirectory = isDirectory
    }

    func getParent() -> File? {
        if parent == nil && path.characters.count > 1 {
        let parentPath = NSURL(fileURLWithPath: path).deletingLastPathComponent!.path
            parent = File(path: parentPath, size: UInt64.max, dateModified: Date(), isDirectory: true)
        }

        return parent
    }

    override var debugDescription: String { get {return self.path} }
    override var description: String { get {return self.path} }
}
