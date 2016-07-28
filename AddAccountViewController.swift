//
//  AddAccountViewController.swift
//  Passlet
//
//  Created by Sahith Bhamidipati on 7/6/16.
//  Copyright © 2016 Sahith Bhamidipati. All rights reserved.
//

import UIKit
import LocalAuthentication

class AddAccountViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var serviceTextField: UITextField!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var account: Account?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let accountTableViewController = segue.destinationViewController as! AccountTableViewController
        if segue.identifier == "Save" {
            if let account = account {
                let newAccount = Account()
                newAccount.title = serviceTextField.text ?? ""
                newAccount.username = usernameTextField.text ?? ""
                if let password = passwordTextField.text {
                    newAccount.password = password
                }
                else {
                    if let currentPW = passwordTextField.text {
                        newAccount.password = currentPW
                    }
                }
                RealmHelper.updateAccount(account, newAccount: newAccount)
            }
            else {
                let account = Account()
                account.title = serviceTextField.text ?? ""
                account.username = usernameTextField.text ?? ""
                if let password = passwordTextField.text {
                    account.password = password
                }
                else {
                    if let currentPW = passwordTextField.text {
                        account.password = currentPW
                    }
                }
                RealmHelper.addAccount(account)

            }
        }
        accountTableViewController.accounts = RealmHelper.retrieveAccounts()
    }
    // Generates a random password
    @IBAction func generateNewPassword(sender: AnyObject) {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()"
        
        let randomString : NSMutableString = NSMutableString(capacity: 16)
        
        for _ in 0 ..< 16 {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        passwordTextField.text = String(randomString)
    }
    
    @IBAction func lockAccount(sender: AnyObject) {
        
    }
    
    // 
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // 1
        if let account = self.account {
            // 2
            self.serviceTextField.text = account.title
            self.usernameTextField.text = account.username
            self.passwordTextField.text = account.password
//            if serviceTextField == "Facebook"{
//                iconImageView.image = UIImage()
//            }
        } else {
            // 3
            self.serviceTextField.text = ""
            self.usernameTextField.text = ""
            self.passwordTextField.text = ""

    }
    }

}
