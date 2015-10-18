//
// Created by Andrey Vokin on 18/10/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Foundation

class ImageUtil {
    static func isImageFile(file: File) -> Bool {
        var ext = file.name.lowercaseString.pathExtension

        return !file.isDirectory && equal("jpg", ext)
    }
}
