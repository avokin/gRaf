//
// Created by user on 04/02/2018.
// Copyright (c) 2018 Andrey Vokin. All rights reserved.
//

import Foundation

class PaneModelListener : Equatable {
    typealias MyCall = (String) -> ();

    static func ==(lhs: PaneModelListener, rhs: PaneModelListener) -> Bool {
        return lhs == rhs
    }

    var rootChanged: MyCall = {(newValue: String) in }

    init(overrides: (PaneModelListener) -> PaneModelListener) {
        overrides(self)
    }
}
