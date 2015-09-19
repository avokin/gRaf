//
// Created by Andrey Vokin on 14/07/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Foundation

class PaneModel {
    private var root: File = File(name: "/", path: "/", size: UInt64.max, dateModified: NSDate(), isDirectory: true)
    private var sortBy: SortBy = .Name
    private var sortDirection: SortDirection = .Ascending
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
        }

        return cached!
    }

    func clearCaches() {
        cached = nil
    }
}
