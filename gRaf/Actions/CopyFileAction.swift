//
// Created by Andrey Vokin on 08/09/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Foundation

class CopyFileAction {
    class func perform(from: File, to: File) {
        var destPath = to.path
        if to.isDirectory {
            destPath = to.path + "/" + from.name
        }

        var err: NSError?
        let priority = Int(QOS_CLASS_USER_INITIATED.value)
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            NSFileManager.defaultManager().copyItemAtPath(from.path, toPath: destPath, error: &err)
        }
    }
}
