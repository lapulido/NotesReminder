//
//  AccountTableViewController.swift
//  Passlet
//
//  Created by Sahith Bhamidipati on 7/6/16.
//  Copyright © 2016 Sahith Bhamidipati. All rights reserved.
//

import UIKit
import RealmSwift

class AccountTableViewController: UITableViewController {
    
    var myService:String = ""
    var myUsername:String = ""
    var myPassword:String = ""
    
    var accounts: Results<Account>! {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        accounts = RealmHelper.retrieveAccounts()
    }

    
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
    
    
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("accountTableViewCell", forIndexPath: indexPath) as! AccountTableViewCell

        // Configure the cell...
        let row = indexPath.row
        let currAcc = accounts[row]
        
        cell.accountLabel.text = currAcc.title
        
        
        
        
        
        return cell
    }
 

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
