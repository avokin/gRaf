//
// Created by Andrey Vokin on 20/09/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Foundation

class TextUtil {
    static let SIZE_SUFFIXES: [String] = ["bytes", "KB", "MB", "GB"]

    static func getSizeText(_ size: UInt64) -> String {
        if size == 1 {
            return "1 byte"
        }
        if size == 0 {
            return "0 bytes"
        }

        var quotient = Double(size)

        var i = 0;
        while (quotient > 1024 && i < SIZE_SUFFIXES.count) {
            quotient = quotient / 1024
            i += 1;
        }

        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        let sizeAsString = formatter.string(from: NSNumber(value: quotient))!

        return "\(sizeAsString) \(SIZE_SUFFIXES[i])"
    }

    static func getDateText(_ date: Date) -> String {
        return DateFormatter.localizedString(from: date, dateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.medium)
    }
}
