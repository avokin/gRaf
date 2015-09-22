//
// Created by Andrey Vokin on 20/09/15.
// Copyright (c) 2015 Andrey Vokin. All rights reserved.
//

import Foundation

class TextUtil {
    static let SIZE_SUFFIXES: [String] = ["bytes", "KB", "MB", "GB"]

    static func getSizeText(size: UInt64) -> String {
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
            i++;
        }

        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        var sizeAsString = formatter.stringFromNumber(quotient)!

        return "\(sizeAsString) \(SIZE_SUFFIXES[i])"
    }

    static func getDateText(date: NSDate) -> String {
        return NSDateFormatter.localizedStringFromDate(date, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.MediumStyle)
    }
}
