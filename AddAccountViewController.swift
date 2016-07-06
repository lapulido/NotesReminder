//
//  AddAccountViewController.swift
//  Passlet
//
//  Created by Sahith Bhamidipati on 7/6/16.
//  Copyright © 2016 Sahith Bhamidipati. All rights reserved.
//

import UIKit

class AddAccountViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var serviceTextField: UITextField!
    
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
        let account = Account()
        account.title = serviceTextField.text ?? ""
        account.username = usernameTextField.text ?? ""
        if let password = passwordTextField.text {
            account.password = password
        }
        else {
            if let currPW = passwordTextField.text {
                account.password = currPW
            }
        }
        accountTableViewController.accounts = RealmHelper.retrieveAccounts()
        
    }
    
    @IBAction func generateNewPassword(sender: AnyObject) {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()"
        
        let randomString : NSMutableString = NSMutableString(capacity: 16)
        
        for _ in 0 ..< 16{
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        passwordTextField.text = String(randomString)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
