//
// Created by Andrey Vokin on 14/07/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Foundation

class PaneModel {
    private var path: String = "/"
    private var sortBy: SortBy = .Name
    private var sortDirection: SortDirection = .Ascending

    private var cached: [File]? = nil

    func getPath() -> String {
        return path;
    }

    func setPath(path: String) {
        self.path = path;
        cached = nil
    }

    func getItems() -> [File] {
        if (cached == nil) {
            cached = FSUtil.getFilesOfDirectory(path)
        }

        return cached!
    }
}
