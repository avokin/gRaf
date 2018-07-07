//
// Created by Andrey Vokin on 08/09/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Foundation

class FileActions {
    class func copyFileAction(_ from: [File], to: File) {
        createFilesFromSource(from, to: to) { (fromPath: String, destPath: String) -> Void in
            FSUtil.copyFile(fromPath, to: destPath)
        }
    }

    class func moveFileAction(_ files: [File], to: File) {
        createFilesFromSource(files, to: to) { (fromPath: String, destPath: String) -> Void in
            FSUtil.moveFile(fromPath, to: destPath)
        }
    }

    class func deleteFileAction(_ files: [File]) {
        let progressWindow = ProgressWindow();

        progressWindow.start({
            for file in files {
                FSUtil.deleteFile(file.path)
            }
        }, progressUpdater: {
            return -1
        })
    }

    fileprivate class func createFilesFromSource(_ files: [File], to: File, action: @escaping (_ fromPath: String, _ destPath: String) -> Void) {
        let progressWindow = ProgressWindow();
        var totalSize: UInt64 = 0
        files.forEach { file in totalSize += FSUtil.fileSize(file) }

        var copiedSize: UInt64 = 0;
        var destPath = ""
        var destSize: UInt64 = 0;
        progressWindow.start({
            for file in files {
                destPath = FSUtil.getDestinationFileName(file, to: to)
                destSize = FSUtil.fileSize(file)
                action(file.path, destPath)
                copiedSize += destSize
            }
        }, progressUpdater: {
            if totalSize <= 0 {
                return 0
            }
            let destSize = FSUtil.fileSize(destPath)
            let a = 100 * (copiedSize + destSize)
            let b = a / totalSize
            return Int(b + 1)
        })
    }
}
