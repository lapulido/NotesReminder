//
//  AccountTableViewController.swift
//  Passlet
//
//  Created by Sahith Bhamidipati on 7/6/16.
//  Copyright © 2016 Sahith Bhamidipati. All rights reserved.
//

import UIKit
import RealmSwift
import LocalAuthentication
import WebKit

class AccountTableViewController: UITableViewController, UIAlertViewDelegate {
    
    var myService:String = ""
    var myUsername:String = ""
    var myPassword:String = ""
    var currSegueId:String = ""
    var authenticated:Bool = false
    let searchController = UISearchController(searchResultsController: nil)
    var filteredAccounts = [Account]()
    
    var accounts: Results<Account>! {
        didSet {
            tableView.reloadData()
        }
    }
    // accounts = candies
    // Account = Candy

    override func viewDidLoad() {
        super.viewDidLoad()
//        showPasswordAlert()
        accounts = RealmHelper.retrieveAccounts()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
//    func filterContentForSearchText(searchText: String, scope: String = "All") {
//        filteredAccounts = accounts.filter { account in
//            return account.username.lowercaseString.containsString(searchText.lowercaseString)
//        }
//        
//        tableView.reloadData()
//    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredAccounts = accounts.filter { account in
            let categoryMatch = (scope == "All") || (account.title == scope)
            return  categoryMatch && account.username.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
        if searchController.active && searchController.searchBar.text != "" {
            return filteredAccounts.count
        }
        return accounts.count
    }
        
    @IBAction func addActtion(sender: AnyObject) {
        let alertVC = UIAlertController(title: "Note Type", message: "Which type would you like to add?", preferredStyle: .ActionSheet)
        
        // Alert action is needed for alert view controller
        let notesAction = UIAlertAction(title: "Accounts", style: .Default) { action in
            self.performSegueWithIdentifier("AccountsSegue", sender: self)
        }
        
        let accountsAction = UIAlertAction(title: "Notes", style: .Default) { action in
        self.performSegueWithIdentifier("NotesSegue", sender: self)
        }
        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { action in
//            
//        }
        
        alertVC.addAction(notesAction)
        alertVC.addAction(accountsAction)
        
        // Present controller
        self.presentViewController(alertVC, animated: true, completion: nil)
    }
    
    // Original
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("accountTableViewCell", forIndexPath: indexPath) as! AccountTableViewCell
//            
//            // Configure the cell...
//        let row = indexPath.row
//        let currAcc = accounts[row]
//            
//        cell.accountLabel.text = currAcc.title
//            
//        return cell
//    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("accountTableViewCell", forIndexPath: indexPath) as! AccountTableViewCell
        let account: Account
        // Configure the cell...
        if searchController.active && searchController.searchBar.text != "" {
            account = filteredAccounts[indexPath.row]
        } else {
            account = accounts[indexPath.row]
        }
        //let currAcc = accounts[indexPath.row]
        
        cell.accountLabel.text = account.title
        
        return cell
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if someCondition {
//            performSegueWithIdentifier("segue1", sender: indexPath)
//        } else {
//            performSegueWithIdentifier("segue2", sender: indexPath)
//        }
//    }
    
    @IBAction func unwindToAccountViewController(segue: UIStoryboardSegue) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if let identifier = segue.identifier {
        let account: Account
            if identifier == "UpdateAccount"{
                print("Table view cell tapped")
                let indexPath = tableView.indexPathForSelectedRow!
                
                if searchController.active && searchController.searchBar.text != "" {
                    account = filteredAccounts[indexPath.row]
                } else {
                    account = accounts[indexPath.row]
                }
                let addAccountViewController = segue.destinationViewController as! AddAccountViewController
                // 4
                addAccountViewController.account = account
            }
            
            else if identifier == "UpdateNote"{
                print("Updatenote Tapped")
                let indexPath = tableView.indexPathForSelectedRow!
                
                if searchController.active && searchController.searchBar.text != "" {
                    
                    account = filteredAccounts[indexPath.row]
                } else {
                    account = accounts[indexPath.row]
                }
                //self.performSegueWithIdentifier("NotesSegue", sender: self)
                
                let displayNoteViewController = segue.destinationViewController as! DisplayNoteViewController
                // 4
                displayNoteViewController.note = account

                
                // Distinguishes the one from notes
//                if account.content != "" {
//                    print("Note type")
//                    performSegueWithIdentifier("UpdateNote", sender: account)
//                    let displayNoteViewController = segue.destinationViewController as! DisplayNoteViewController
//                    // 4
//                    displayNoteViewController.note = account
                
//                    let displayNote = segue.destinationViewController as! DisplayNoteViewController
//                    let addAccountViewController = displayNote.DisplayNoteViewController as! AddAccountViewController
//                    addAccountViewController.note = account
//                }
        
//                if segue.identifier == "fromEventTableToAddEvent" {
//                    
//                    let nav = segue.destinationViewController as! UINavigationController
//                    let addEventViewController = nav.topViewController as! AddEventViewController
//                    
//                    addEventViewController.newTagArray = newTagArray
//                else {
//                
//                let addAccountViewController = segue.destinationViewController as! AddAccountViewController
//                // 4
//                addAccountViewController.account = account
//                
//                }
            

    }

    // asks for authentication
//    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
//        currSegueId = identifier
//        if authenticated {
//            return true
//        } else {
//            authenticateUser()
//            return false
//        }
        }
    }
    
    // Swipe right delete option
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // 2
        if editingStyle == .Delete {
            // 3
            RealmHelper.deleteAccount(accounts[indexPath.row])
            // 4
            accounts = RealmHelper.retrieveAccounts()
        }
    }
    
    // Implementing Touch ID Functionality for security
    // http://www.appcoda.com/touch-id-api-ios8/
    func authenticateUser() -> Bool {
        // Get the local authentication context.
        let context : LAContext = LAContext()
        
        // Declare a NSError variable.
        var error: NSError?
        
        // Set the reason string that will appear on the authentication alert.
        var reasonString = "Authentication is needed to access your notes."
        
        // Check if the device can evaluate the policy.
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            [context .evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success: Bool, evalPolicyError: NSError?) -> Void in
                
                if success {
                    print("fp success")
                    self.authenticated = true
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.performSegueWithIdentifier(self.currSegueId, sender: nil)
                    })

                } else {
                    // If authentication failed then show a message to the console with a short description.
                    // In case that the error is a user fallback, then show the password alert view.
                    print(evalPolicyError?.localizedDescription)
                    
                    switch evalPolicyError!.code {
                        
                    case LAError.SystemCancel.rawValue:
                        print("Authentication was cancelled by the system")
                        
                    case LAError.UserCancel.rawValue:
                        print("Authentication was cancelled by the user")
                        
                    case LAError.UserFallback.rawValue:
                        print("User selected to enter custom password")
                        dispatch_async(dispatch_get_main_queue(), {
                            self.showPasswordAlert()
                        })
                        
                    default:
                        print("Authentication failed")
                        dispatch_async(dispatch_get_main_queue(), {
                            self.showPasswordAlert()
                        })
                    }
                }
                
            })]
        } else {
            // If the security policy cannot be evaluated then show a short message depending on the error.
            switch error!.code{
                
            case LAError.TouchIDNotEnrolled.rawValue:
                print("TouchID is not enrolled")
                
            case LAError.PasscodeNotSet.rawValue:
                print("A passcode has not been set")
                
            default:
                // The LAError.TouchIDNotAvailable case.
                print("TouchID not available")
            }
            
            // Optionally the error description can be displayed on the console.
            print(error?.localizedDescription)
            
            // Show the custom alert view to allow users to enter the password.
            dispatch_async(dispatch_get_main_queue(), {
            self.showPasswordAlert()
            })
        }
        return false
    }
    
    func showPasswordAlert() {
        var passwordAlert : UIAlertView = UIAlertView(title: "TouchID", message: "Please type your password", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Enter")
        passwordAlert.alertViewStyle = UIAlertViewStyle.SecureTextInput
        passwordAlert.show()
    }
    
    
    
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            if !alertView.textFieldAtIndex(0)!.text!.isEmpty {
                if alertView.textFieldAtIndex(0)!.text == "password" {
                    print("success")
                    self.authenticated = true
                    self.performSegueWithIdentifier(self.currSegueId, sender: nil)
                    
                }
                else{
                    print("failed")
                    showPasswordAlert()
                }
            } else {
                print("failed")
                showPasswordAlert()
            }
        }
    }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*@IBAction func createNewAccount(sender: AnyObject) {
        
        let alertView = UIAlertController(title: "Create An Account", message: "", preferredStyle: .Alert)
        
        
        alertView.addTextFieldWithConfigurationHandler( {
            (textField) in
            textField.placeholder = "Input Account"
        })
        alertView.addTextFieldWithConfigurationHandler( {
            (textField) in
            textField.placeholder = "Input your Username"
        })
        alertView.addAction((UIAlertAction(title: "Add Your Own Password", style: .Default, handler: {
            (action) -> Void in
            
            alertView.dismissViewControllerAnimated(true, completion: nil)
            let ownPW = UIAlertController(title: "Input Your Password", message: "", preferredStyle: .Alert)
            ownPW.addTextFieldWithConfigurationHandler( {
                (textField) in
                textField.placeholder = "Input Your Password"
            })
            ownPW.addAction((UIAlertAction(title: "Create", style: .Default, handler: {
                (action) -> Void in
                
            })))
            ownPW.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            self.presentViewController(ownPW, animated: true, completion: nil)
        })))
        alertView.addAction((UIAlertAction(title: "Generate Random Password", style: .Default, handler: {
            (action) -> Void in
            let serviceTF = alertView.textFields![0] as UITextField
            let usernameTF = alertView.textFields![1] as UITextField
            let newPassword = self.generateRandomPassword()
            self.myService = serviceTF.text ?? ""
            self.myUsername = usernameTF.text ?? ""
            self.myPassword = newPassword
            
            
        })))
        alertView.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    func inputOwnPassword() {
        
    }
    
    //http://stackoverflow.com/questions/26845307/generate-random-alphanumeric-string-in-swift
    
    func generateRandomPassword() -> String{
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()"
        
        let randomString : NSMutableString = NSMutableString(capacity: 16)
        
        for _ in 0 ..< 16{
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return String(randomString)
    }
    
    func saveAccountInfo() {
        
    }*/
    
    
    

    // MARK: - Table view data sourc
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AccountTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

extension AccountTableViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

