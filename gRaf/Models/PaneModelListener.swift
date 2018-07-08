//
// Created by user on 04/02/2018.
// Copyright (c) 2018 Andrey Vokin. All rights reserved.
//

import Foundation

class PaneModelListener {
    var rootChanged: (String) -> () = {(newValue: String) in }
    var selectedFilesChanged: () -> () = {() in }
    var refreshed: () -> () = {() in }

    init(overrides: (PaneModelListener) -> PaneModelListener) {
        overrides(self)
    }
}
