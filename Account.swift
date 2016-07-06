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
    dynamic var username = ""
    dynamic var password = ""
    dynamic var title = ""
}