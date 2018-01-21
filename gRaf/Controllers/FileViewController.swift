//
// Created by Andrey Vokin on 18/10/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Foundation

class FileViewController: PaneController {
    var file: File!
    var parentController: FileListPaneController!;

    init?(file: File, parentController: FileListPaneController) {
        super.init(nibName: nil, bundle: nil)

        self.file = file
        self.parentController = parentController
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func updateView() {
        self.appDelegate.updateStatus(self.file.path)
    }
}
