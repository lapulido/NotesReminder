//
//  RealmHelper.swift
//  MakeSchoolNotes
//
//  Created by Pulido on 7/21/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import RealmSwift

class RealmHelper {
    
    static func addAccount(account: Account){
        let realm = try! Realm()
        try! realm.write() {
            realm.add(account)
        }
    }

    static func deleteAccount(account: Account){
        let realm = try! Realm()
        try! realm.write() {
            realm.delete(account)
        }
    }

    
    static func updateAccount(accountToBeUpdated: Account, newAccount: Account) {
        let realm = try! Realm()
        try! realm.write() {
            accountToBeUpdated.title = newAccount.title
            accountToBeUpdated.username = newAccount.username
            accountToBeUpdated.password = newAccount.password
            accountToBeUpdated.content = newAccount.content
            accountToBeUpdated.category = newAccount.category
            accountToBeUpdated.modificationTime = newAccount.modificationTime
        }
    }
    
    static func retrieveAccounts() -> Results<Account> {
        let realm = try! Realm()
        return realm.objects(Account).sorted("modificationTime", ascending: false)
    }

}