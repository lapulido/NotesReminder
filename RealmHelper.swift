//
//  RealmHelper.swift
//  MakeSchoolNotes
//
//  Created by Sahith Bhamidipati on 6/22/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import Foundation
import RealmSwift

class RealmHelper {
    
    static func addNote(account: Account){
        let realm = try! Realm()
        try! realm.write() {
            realm.add(account)
        }
    }
    
    static func deleteNote(account: Account){
        let realm = try! Realm()
        try! realm.write() {
            realm.delete(account)
        }
    }
    
    static func retrieveNotes() -> Results<Account>{
        let realm = try! Realm()
        return realm.objects(Account).sorted("title", ascending: false)
    }
}