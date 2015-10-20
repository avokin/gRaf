//
// Created by Andrey Vokin on 18/10/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Foundation

class ImageUtil {
    static func isImageFile(file: File) -> Bool {
        var ext = NSURL(fileURLWithPath: file.name.lowercaseString).pathExtension
        return ext != nil && !file.isDirectory && "jpg".characters.elementsEqual(ext!.characters)
    }
}
