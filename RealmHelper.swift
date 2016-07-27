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
    
    static func addAccount(account: Account){
        let realm = try! Realm()
        try! realm.write() {
            realm.add(account)
        }
    }
    
//    static func addNote(note: Note) {
//        let realm = try! Realm()
//        try! realm.write() {
//            realm.add(note)
//        }
//    }

    static func deleteAccount(account: Account){
        let realm = try! Realm()
        try! realm.write() {
            realm.delete(account)
        }
    }
    
//    static func deleteNote(note: Note) {
//        let realm = try! Realm()
//        try! realm.write() {
//            realm.delete(note)
//        }
//    }
    
    static func updateAccount(accountToBeUpdated: Account, newAccount: Account) {
        let realm = try! Realm()
        try! realm.write() {
            accountToBeUpdated.title = newAccount.title
            accountToBeUpdated.username = newAccount.username
            accountToBeUpdated.password = newAccount.password
            accountToBeUpdated.content = newAccount.content
            accountToBeUpdated.modificationTime = newAccount.modificationTime
        }
    }
    
//    static func updateNote(noteToBeUpdated: Note, newNote: Note){
//        let realm = try! Realm()
//        try! realm.write() {
//            noteToBeUpdated.title = newNote.title
//            noteToBeUpdated.content = newNote.content
//            noteToBeUpdated.modificationTime = newNote.modificationTime
//        }
//    }
    
    static func retrieveAccounts() -> Results<Account> {
        let realm = try! Realm()
        return realm.objects(Account).sorted("modificationTime", ascending: false)
    }
//    
//    static func retrieveNotes() -> Results <Note> {
//        let realm = try! Realm()
//        return realm.objects(Note).sorted("modificationTime", ascending: false)
//    }
}