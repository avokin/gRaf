//
// Created by Andrey Vokin on 18/10/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Foundation

class ChildController : PaneController {
    var parentController: FileListPaneController!;

    init?(parentController: FileListPaneController) {
        super.init(nibName: nil, bundle: nil)

        self.parentController = parentController
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
