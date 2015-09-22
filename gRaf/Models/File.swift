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

    init(name: String, path: String, size: UInt64, dateModified: NSDate?, isDirectory: Bool) {
        self.name = name
        self.path = path
        self.size = size
        self.dateModified = dateModified
        self.isDirectory = isDirectory
    }

    override var debugDescription: String { get {return self.path} }
    override var description: String { get {return self.path} }
}
