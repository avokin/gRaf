//
// Created by Andrey Vokin on 14/07/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Foundation

class File: NSObject {
    var name: String
    var size: UInt64
    var dateModified: NSDate

    init(name: String, size: UInt64, dateModified: NSDate) {
        self.name = name
        self.size = size
        self.dateModified = dateModified
    }
}
