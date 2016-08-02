//
//  Account.swift
//  Passlet
//
//  Created by Sahith Bhamidipati on 7/6/16.
//  Copyright © 2016 Sahith Bhamidipati. All rights reserved.
//

import Foundation
import RealmSwift

class Account: Object {
    dynamic var title = ""
    dynamic var category = ""
    // only found in account
    dynamic var username = ""
    dynamic var password = ""
    // only found in note
    dynamic var content = ""
    dynamic var modificationTime = NSDate()
}

