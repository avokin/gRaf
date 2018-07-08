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
    // replace with listener
    open var callback: (() -> Void)?
    var selectedIndexSet = IndexSet()

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
            selectFiles([from!.name])
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

    func selectFile(_ name: String) {
        selectFiles([name])
    }

    func selectFiles(_ names: [String]) {
        var index = 0
        var newSelectedIndexSet = IndexSet()

        for file: File in getItems() {
            if names.contains(where: {$0.characters.elementsEqual(file.name.characters)}) {
                newSelectedIndexSet.insert(index)
            }
            index += 1
        }
        if (newSelectedIndexSet.count == 0) {
            newSelectedIndexSet.insert(0)
        }
        selectedIndexSet = newSelectedIndexSet
    }

    func selectFiles(_ indexSet: IndexSet) {
        selectedIndexSet = indexSet
    }

    func getSelectedFiles() -> [File] {
        return selectedIndexSet.map{getItems()[$0]}
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
        let previousRoot = self.root
        self.root = root;
        self.rootOriginalPath = calculateRootOriginalPath()
        refresh(false)

        self.selectedIndexSet.removeAll();
        if FSUtil.isAncestor(root, file: previousRoot) {
            for (index, file) in getItems().enumerated() {
                if file.name == previousRoot.name {
                    self.selectedIndexSet.insert(index)
                }
            }
        }
        if (self.selectedIndexSet.count == 0) {
            self.selectedIndexSet.insert(0)
        }

        if (callback != nil) {
            callback!()
        }
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
        refresh(true);
    }

    func refresh(_ withCallback: Bool) {
        cached = calculateCache();
        if withCallback && callback != nil {
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

    // ToDo: delete
    func refreshCallback() {
        refresh()
    }
}
