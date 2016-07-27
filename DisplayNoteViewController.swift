//
//  DisplayNoteViewController.swift
//  Passlet
//
//  Created by Pulido on 7/21/16.
//  Copyright © 2016 Sahith Bhamidipati. All rights reserved.
//

import UIKit
import RealmSwift

class DisplayNoteViewController: UIViewController {
    @IBOutlet weak var noteContentTextView: UITextView!
    @IBOutlet weak var noteTitleTextField: UITextField!
    var note: Account?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let noteTableViewController = segue.destinationViewController as! AccountTableViewController
        if segue.identifier == "Save" {
            // if note exists, update title and content
            if let note = note {
                // 1
                let newNote = Account()
                newNote.title = noteTitleTextField.text ?? ""
                newNote.content = noteContentTextView.text ?? ""
                RealmHelper.updateAccount(note, newAccount: newNote)
            } else {
                // if note does not exist, create new note
                let note = Account()
                note.title = noteTitleTextField.text ?? ""
                note.content = noteContentTextView.text ?? ""
                note.modificationTime = NSDate()
                // 2
                RealmHelper.addAccount(note)
            }
            // 3
            noteTableViewController.accounts = RealmHelper.retrieveAccounts()
        }
    }

    //
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // 1
        if let note = note {
            // 2
            noteTitleTextField.text = note.title
            noteContentTextView.text = note.content
        } else {
            // 3
            noteTitleTextField.text = ""
            noteContentTextView.text = ""
        }
    }
    
}