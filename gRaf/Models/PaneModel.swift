//
// Created by Andrey Vokin on 14/07/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Foundation

class PaneModel {
    private var root: File = File(name: "/", path: "/", size: UInt64.max, dateModified: NSDate(), isDirectory: true)
    private var sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "Name", ascending: true)
    var selectedIndex = 0

    private var cached: [File]? = nil

    func getPath() -> String {
        return root.path;
    }

    func getRoot() -> File {
        return root
    }

    func setRoot(root: File) {
        self.root = root;
        clearCaches()
    }

    func getItems() -> [File] {
        if (cached == nil) {
            cached = FSUtil.getFilesOfDirectory(root.path)
            cached!.sort({
                var first: File
                var second: File
                if self.sortDescriptor.ascending {
                    first = $0
                    second = $1
                } else {
                    first = $1
                    second = $0
                }

                var left : String = $0.name
                var right : String = $1.name

                var key: String? = self.sortDescriptor.key()
                if key! == "Size" {
                    return first.size > second.size
                }
                return first.name.localizedCompare(second.name) == NSComparisonResult.OrderedAscending
            })
        }

        return cached!
    }

    func clearCaches() {
        cached = nil
    }

    func setSortDescriptor(value: NSSortDescriptor) {
        sortDescriptor = value
        clearCaches()
    }
}
