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
    var passwordMaster:String = ""
    var textField: UITextField?
    
    var accounts: Results<Account>! {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        showPasswordAlert()
        accounts = RealmHelper.retrieveAccounts()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.delegate = self

        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["All", "Account", "Note"]
        tableView.tableHeaderView = searchController.searchBar

    }
    
    //candy = account
    //candies = accounts
    
    
    // Search content
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredAccounts = accounts.filter { account in
            let categoryMatch = (scope == "All") || (account.category == scope)
            return  categoryMatch && account.title.lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.reloadData()
    }
    
    // Returns the number of Rows
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
        if searchController.active && searchController.searchBar.text != "" {
            return filteredAccounts.count
        }
        return accounts.count
    }
    
    // Returns the proper cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("accountTableViewCell", forIndexPath: indexPath) as! AccountTableViewCell
        let account: Account
        // Configure the cell...
        if searchController.active && searchController.searchBar.text != "" {
            account = filteredAccounts[indexPath.row]
        } else {
            account = accounts[indexPath.row]
        }
        cell.accountLabel.text = account.title
        cell.categoryLabel.text = account.category
        
        if account.username.characters.count > 0 {
            cell.tag = 0
        } else {
            cell.tag = 1
        }
        

        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell!.tag == 0 {
            let controller = storyboard?.instantiateViewControllerWithIdentifier("AddAccountViewController") as? AddAccountViewController
            controller?.account = accounts[indexPath.row]
            navigationController?.pushViewController(controller!, animated: true)
        } else {
            let controller = storyboard?.instantiateViewControllerWithIdentifier("DisplayNoteViewController") as? DisplayNoteViewController
            controller?.note = accounts[indexPath.row]
            navigationController?.pushViewController(controller!, animated: true)
        }
    }
    
    
    // For reverting back to original view controller
    @IBAction func unwindToAccountViewController(segue: UIStoryboardSegue) {
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    // asks for authentication
//    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
//        currSegueId = identifier
//        if authenticated {
//            return true
//        } else {
//            authenticateUser()
//            return false
//            }
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
    
    // Add button is given two options: Accounts and Notes
    @IBAction func addAction(sender: AnyObject) {
        let alertVC = UIAlertController(title: "Note Type", message: "Which type would you like to add?", preferredStyle: .ActionSheet)
        
        // Alert action is needed for alert view controller
        let notesAction = UIAlertAction(title: "Accounts", style: .Default) { action in
            self.performSegueWithIdentifier("AccountsSegue", sender: self)
        }
        
        let accountsAction = UIAlertAction(title: "Notes", style: .Default) { action in
            self.performSegueWithIdentifier("NotesSegue", sender: self)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action in
        }
        
        alertVC.addAction(notesAction)
        alertVC.addAction(accountsAction)
        alertVC.addAction(cancelAction)
        
        // Present controller
        self.presentViewController(alertVC, animated: true, completion: nil)
    }
    
    
    // The lock bar item and user creation of password
    @IBAction func lockAccount(sender: AnyObject) {
        inputOwnPassword()
    }
    
    func inputOwnPassword() {
        // Alert action needed for view controller
        let lockAlert = UIAlertController(title: "Create a New Password", message: "For Security Purposes", preferredStyle: .Alert)
        
        // Adds the text field
        lockAlert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = ""
        })
        
        // Grab the value from the text field, and print it when the user clicks OK.
        lockAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.textField = lockAlert.textFields![0] as UITextField
            print("Text field: \(self.textField!.text)")
        }))
        
        // Adds the Cancel Button
        lockAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
        }))
        
        // Present controller
        self.presentViewController(lockAlert, animated: true, completion: nil)
        
//        let check = true
//        
//        if check == true {
//            let alertLock = UIAlertController(title: "Locked Account", message: "Your Account is now Locked!", preferredStyle: .Alert)
//            let okAction = UIAlertAction(title: "OK", style: .Default) { action in
//            }
//            alertLock.addAction(okAction)
//            self.presentViewController(alertLock, animated: true, completion: nil)
//        }

    }

    
    // Shows the options between TouchID or Password
    func showPasswordAlert() {
        let passwordAlert : UIAlertView = UIAlertView(title: "TouchID", message: "Please type your password", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Enter")
        passwordAlert.alertViewStyle = UIAlertViewStyle.SecureTextInput
        passwordAlert.show()
    }
    
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            if !alertView.textFieldAtIndex(0)!.text!.isEmpty {
                if alertView.textFieldAtIndex(0)!.text == textField?.text {
                    print("success")
                    self.authenticated = true
                    self.performSegueWithIdentifier("AccountTableViewController", sender: nil)
                    
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
    
    // Implementing Touch ID Functionality for security
    // http://www.appcoda.com/touch-id-api-ios8/
    func authenticateUser() -> Bool {
        // Get the local authentication context.
        let context : LAContext = LAContext()
        
        // Declare a NSError variable.
        var error: NSError?
        
        // Set the reason string that will appear on the authentication alert.
        let reasonString = "Authentication is needed to access your notes."
        
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
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}

extension AccountTableViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}


