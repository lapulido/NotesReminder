//
//  DisplayNoteViewController.swift
//  Passlet
//
//  Created by Pulido on 7/21/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import RealmSwift

class DisplayNoteViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var noteContentTextView: UITextView!
    @IBOutlet weak var noteTitleTextField: UITextField!
    var imagePickerController: UIImagePickerController?
    var photoTakingHelper: PhotoTakingHelper?
    var note: Account?

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Save" {
            let noteTableViewController = segue.destinationViewController as! AccountTableViewController

            // if note exists, update title and content
            if let note = note {
                // 1
                let newNote = Account()
                newNote.title = noteTitleTextField.text ?? ""
                newNote.content = noteContentTextView.text ?? ""
                newNote.category = "Note"
                newNote.modificationTime = NSDate()
                RealmHelper.updateAccount(note, newAccount: newNote)
//                var imageData = UIImageJPEGRepresentation(imagePicked.image!, 0.6)
//                var compressedJPGImage = UIImage(data: imageData!)
//                UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
//                UIImageView(image: imagePicked.image)
            } else {
                // if note does not exist, create new note
                let note = Account()
                note.title = noteTitleTextField.text ?? ""
                note.content = noteContentTextView.text ?? ""
                note.category = "Note" ?? ""
                note.modificationTime = NSDate()
                // 2
                RealmHelper.addAccount(note)
            }
            // 3
            noteTableViewController.accounts = RealmHelper.retrieveAccounts()
        }

    }
//    @IBAction func saveButt(sender: AnyObject) {
//
//        UIImageWriteToSavedPhotosAlbum(compressedJPGImage, nil, nil, nil)
//        
//        var alert = UIAlertView(title: "Wow",
//                                message: "Your image has been saved to Photo Library!",
//                                delegate: nil,
//                                cancelButtonTitle: "Ok")
//        alert.show()
//    }

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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imagePicked.image = image
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func photoAction(sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your picture from?", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Allows user to choose from library, will ask permission
        let photoLibraryAction = UIAlertAction(title: "Photo from Library", style: .Default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                imagePicker.allowsEditing = true
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
        alertController.addAction(photoLibraryAction)
        
        // Only show camera option if rear camera is available
        if (UIImagePickerController.isCameraDeviceAvailable(.Rear)) {
            let cameraAction = UIAlertAction(title: "Photo from Camera", style: .Default) { (action) in
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                    imagePicker.allowsEditing = false
                    self.presentViewController(imagePicker, animated: true, completion: nil)
                }
            }
            alertController.addAction(cameraAction)
        }
       self.presentViewController(alertController, animated: true, completion: nil)
    }
}