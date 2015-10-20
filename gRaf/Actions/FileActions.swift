//
// Created by Andrey Vokin on 08/09/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Foundation

class FileActions {
    class func copyFileAction(from: File, to: File) {
        createFileFromSource(from, to: to) { (fromPath: String, destPath: String) -> Void in
            FSUtil.copyFile(fromPath, to: destPath)
        }
    }

    class func moveFileAction(from: File, to: File) {
        createFileFromSource(from, to: to) { (fromPath: String, destPath: String) -> Void in
            FSUtil.moveFile(fromPath, to: destPath)
        }
    }

    class func deleteFileAction(file: File) {
        let progressWindow = ProgressWindow();

        progressWindow.start({
            FSUtil.deleteFile(file.path)
        }, progressUpdater: {
            return -1
        })
    }

    private class func createFileFromSource(from: File, to: File, action: (fromPath: String, destPath: String) -> Void) {
        let progressWindow = ProgressWindow();
        let sourceSize = FSUtil.fileSize(from)

        let destPath = FSUtil.getDestinationFileName(from, to: to)

        progressWindow.start({
            action(fromPath: from.path, destPath: destPath)
        }, progressUpdater: {
            if sourceSize <= 0 {
                return 0
            }
            let destSize = FSUtil.fileSize(destPath)
            let a = 10000 * destSize
            let b = a / sourceSize
            return Int(b + 1)
        })
    }
}
