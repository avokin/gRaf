//
// Created by Andrey Vokin on 14/07/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Foundation

class File: NSObject{
    var name: String
    var path: String
    var size: UInt64
    var dateModified: NSDate?
    var isDirectory: Bool

    private var parent: File?

    init(name: String, path: String, size: UInt64, dateModified: NSDate?, isDirectory: Bool) {
        self.name = name
        self.path = path
        self.size = size
        self.dateModified = dateModified
        self.isDirectory = isDirectory
    }

    func getParent() -> File? {
        if parent == nil && path.characters.count > 1 {
            if let parentPath = NSURL(fileURLWithPath: path).URLByDeletingLastPathComponent!.path {
                if let parentName = NSURL(fileURLWithPath: parentPath).lastPathComponent {
                    parent = File(name: parentName, path: parentPath, size: UInt64.max, dateModified: NSDate(), isDirectory: true)
                }
            }
        }

        return parent
    }

    override var debugDescription: String { get {return self.path} }
    override var description: String { get {return self.path} }
}
