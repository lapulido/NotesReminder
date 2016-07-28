//
//  NSDate+convertToString.swift
//  Passlet
//
//  Created by Pulido on 7/21/16.
//  Copyright © 2016 Sahith Bhamidipati. All rights reserved.
//

import Foundation
extension NSDate {
    func convertToString() -> String {
        return NSDateFormatter.localizedStringFromDate(self, dateStyle: NSDateFormatterStyle.MediumStyle, timeStyle: NSDateFormatterStyle.MediumStyle)
    }
}