//
// Created by Andrey Vokin on 14/07/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Foundation

class PaneModel {
    var listeners = [PaneModelListener]()
    fileprivate var root: File
    fileprivate var rootOriginalPath: String! = nil
    fileprivate var sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "Name", ascending: true)
    open var callback: (() -> Void)?
    var selectedIndex = 0

    fileprivate var cached: [File]? = nil

    convenience init() {
        let file = File(path: "/", size: UInt64.max, dateModified: Date(), isDirectory: true);
        self.init(root: file, from: nil)
    }

    init(root: File, from: File?) {
        self.root = root
        self.rootOriginalPath = calculateRootOriginalPath()
        clearCaches()
        if from != nil {
            selectChild(from!.name)
        }

        FileSystemWatcher.instance.subscribeToFsEvents(self)
    }

    func addListener(listener: PaneModelListener) {
        listeners.append(listener)
    }

    func removeListener(listener: PaneModelListener) {
        if let index = listeners.index(of: listener) {
            listeners.remove(at: index)
        }
    }

    func selectChild(_ name: String) {
        var index = 0
        for file: File in getItems() {
            if name.characters.elementsEqual(file.name.characters) {
                break
            }
            index += 1
        }
        if (index >= getItems().count) {
            index = 0
        }
        selectedIndex = index
    }

    func selectChild(_ index: Int) {
        selectedIndex = index
    }

    func getPath() -> String {
        return root.path;
    }

    func getRoot() -> File {
        return root
    }

     func getRootOriginalPath() -> String {
         return rootOriginalPath
     }

    private func calculateRootOriginalPath() -> String {
        let url = URL.init(fileURLWithPath: root.path)
        var result =  FSUtil.resolveSymlink(at: url)
        if result == nil {
            result = root.path
        }

        return result!
    }

    func setRoot(_ root: File) {
        self.root = root;
        self.rootOriginalPath = calculateRootOriginalPath()
        refresh()

        for listener in listeners {
            listener.rootChanged(root.path)
        }
    }

    func calculateCache() -> [File] {
        var result = FSUtil.getFilesOfDirectory(root.path)
        result.sort(by: {
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
            return first.name.localizedCompare(second.name) == ComparisonResult.orderedAscending
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

    func setSortDescriptor(_ value: NSSortDescriptor) {
        sortDescriptor = value
        clearCaches()
    }

    func refreshCallback() {
        refresh()
    }

    func getSelectedFile() -> File {
        if (selectedIndex == 0) {
            return root
        }

        return getItems()[selectedIndex]
    }
}
