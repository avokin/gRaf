//
// Created by Andrey Vokin on 14/07/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Foundation

class PaneModel {
    private var root: File
    private var sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "Name", ascending: true)
    public var callback: (() -> Void)?
    var selectedIndex = 0

    private var cached: [File]? = nil

    convenience init() {
        var file = File(name: "/", path: "/", size: UInt64.max, dateModified: NSDate(), isDirectory: true);
        self.init(root: file, from: nil)
    }

    init(root: File, from: File?) {
        self.root = root
        clearCaches()
        if from != nil {
            selectChild(from!.name)
        }

        FileSystemWatcher.instance.subscribeToFsEvents(self)
    }

    func selectChild(name: String) {
        var index = 0
        for file: File in getItems() {
            if name.characters.elementsEqual(file.name.characters) {
                break
            }
            index++
        }
        if (index >= getItems().count) {
            index = 0
        }
        selectedIndex = index
    }

    func getPath() -> String {
        return root.path;
    }

    func getRoot() -> File {
        return root
    }

    func setRoot(root: File) {
        self.root = root;
        refresh()
    }

    func calculateCache() -> [File] {
        var result = FSUtil.getFilesOfDirectory(root.path)
        result.sortInPlace({
            if "..".characters.elementsEqual($0.name.characters) {
                return true
            }
            if "..".characters.elementsEqual($1.name.characters) {
                return false
            }

            if $0.isDirectory && !$1.isDirectory {
                return self.sortDescriptor.ascending
            }
            if $1.isDirectory && !$0.isDirectory {
                return !self.sortDescriptor.ascending
            }

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

            let key: String? = self.sortDescriptor.key
            if key! == "Size" {
                if first.size == UInt64.max {
                    return false
                }
                if second.size == UInt64.max {
                    return true
                }

                return first.size > second.size
            }
            return first.name.localizedCompare(second.name) == NSComparisonResult.OrderedAscending
        })

        return result;
    }

    func getItems() -> [File] {
        if (cached == nil) {
            cached = calculateCache()
        }

        return cached!
    }

    func refresh() {
        cached = calculateCache();
        if callback != nil {
            callback!()
        }
    }

    func clearCaches() {
        cached = nil
    }

    func setSortDescriptor(value: NSSortDescriptor) {
        sortDescriptor = value
        clearCaches()
    }

    func refreshCallback() {
        refresh()
    }
}
