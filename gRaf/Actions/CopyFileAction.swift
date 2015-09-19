//
// Created by Andrey Vokin on 08/09/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Foundation

class CopyFileAction {
    class func copyFileAction(from: File, to: File) {
        createFileFromSource(from, to: to, action: { (fromPath: String, destPath: String) -> Void in
            FSUtil.copyFile(fromPath, to: destPath)
        })
    }

    class func moveFileAction(from: File, to: File) {
        // ToDo: create closure like dispatch_async
        createFileFromSource(from, to: to, action: { (fromPath: String, destPath: String) -> Void in
            FSUtil.moveFile(fromPath, to: destPath)
        })
    }

    private class func createFileFromSource(from: File, to: File, action: (fromPath: String, destPath: String) -> ()) {
        var currentProgress = 0;
        var progressWindow = ProgressWindow();
        var sourceSize = FSUtil.fileSize(from)

        var destPath = FSUtil.getDestinationFileName(from, to: to)

        progressWindow.start({
            action(fromPath: from.path, destPath: destPath)
        }, progressUpdater: {
            if sourceSize <= 0 {
                return 0
            }
            var destSize = FSUtil.fileSize(destPath)
            currentProgress++
            var a = 10000 * destSize
            var b = a / sourceSize
            return Int(b + 1)
        })
    }
}
