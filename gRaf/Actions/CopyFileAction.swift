//
// Created by Andrey Vokin on 08/09/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Foundation

class CopyFileAction {
    class func perform(from: File, to: File) {
        var destPath = FSUtil.getDestinationFileName(from, to: to)

        var err: NSError?
        NSFileManager.defaultManager().copyItemAtPath(from.path, toPath: destPath, error: &err)
        if err != nil {
            println("err \(err)")
        }
    }
}
