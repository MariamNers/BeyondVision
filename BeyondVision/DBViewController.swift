//
//  DBViewController.swift
//  BeyondVision
//
//  Created by Mariam Nersisyan on 05/03/2016.
//  Copyright © 2016 MariamN. All rights reserved.
//

import Foundation
import UIKit


class DBViewController: UITableViewController {


    @IBOutlet weak var refreshbutton: UIButton!
    @IBOutlet weak var bbiconnect: UIButton!
    var dbRestClient: DBRestClient!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleDidLinkNotification:", name: "didLinkToDropboxAccountNotification", object: nil)
        
        if DBSession.sharedSession().isLinked() {
            bbiconnect.enabled = false // disables
            bbiconnect.setTitle("Disconnect", forState: UIControlState.Normal)
            initDropboxRestClient()
            
            
        }
        
        
        
        
    }
    
    
    func handleDidLinkNotification(notification: NSNotification) {
        initDropboxRestClient()
        bbiconnect.enabled = false // disables
        bbiconnect.setTitle("Disconnect", forState: UIControlState.Normal)
    }
    
    
    @IBAction func connectToDropbox(sender: AnyObject) {
        if !DBSession.sharedSession().isLinked() {
            DBSession.sharedSession().linkFromController(self)
        }
        else {
            DBSession.sharedSession().unlinkAll()
            bbiconnect.enabled = false // disables
            bbiconnect.setTitle("Connect", forState: UIControlState.Normal)
            dbRestClient = nil
            
        }

    }
    
        func initDropboxRestClient() {
            dbRestClient = DBRestClient(session: DBSession.sharedSession())
            // dbRestClient.delegate = self
        }
    
    
    
    
    
    
    
    @IBAction func performAction(sender: AnyObject) {
    if !DBSession.sharedSession().isLinked() {
        print("You're not connected to Dropbox")
        return
    }
    
    let actionSheet = UIAlertController(title: "Upload file", message: "Select file to upload", preferredStyle: UIAlertControllerStyle.ActionSheet)
    
    let uploadTextFileAction = UIAlertAction(title: "Upload text file", style: UIAlertActionStyle.Default) { (action) -> Void in
        
    }
    
    let uploadImageFileAction = UIAlertAction(title: "Upload image", style: UIAlertActionStyle.Default) { (action) -> Void in
        
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
        
    }
    
    actionSheet.addAction(uploadTextFileAction)
    actionSheet.addAction(uploadImageFileAction)
    actionSheet.addAction(cancelAction)
    
    presentViewController(actionSheet, animated: true, completion: nil)
}
        
        
        
      
    }


