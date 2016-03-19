//
//  AppDelegate.swift
//  BeyondVision
//
//  Created by Mariam Nersisyan on 05/03/2016.
//  Copyright © 2016 MariamN. All rights reserved.
//

import UIKit
import ChameleonFramework

class DBController: UIViewController, UITableViewDelegate, UITableViewDataSource, DBRestClientDelegate {
    
    @IBOutlet weak var viewY: UIView!
    @IBOutlet weak var tblFiles: UITableView!
    
    @IBOutlet weak var bbiConnect: UIBarButtonItem!
    
    @IBOutlet weak var progressBar: UIProgressView!
    var dbRestClient: DBRestClient!
    var dropboxMetadata: DBMetadata!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tblFiles.delegate = self
        tblFiles.dataSource = self
        tblFiles.tableFooterView = UIView()
        tblFiles.backgroundColor = UIColor.flatSandColor()
        self.viewY.backgroundColor  = UIColor.flatSandColor()
        
        progressBar.hidden = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleDidLinkNotification:", name: "didLinkToDropboxAccountNotification", object: nil)
        
        if DBSession.sharedSession().isLinked() {
            bbiConnect.title = "Disconnect"
            initDropboxRestClient()
        }
        
        
        
        
    }
    
    
     func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.init(
            gradientStyle: UIGradientStyle.TopToBottom,
            withFrame: view.frame,
            andColors : [ UIColor.flatSandColor(), UIColor.flatBlackColor()]
            
        )}
    
    
    
    func initDropboxRestClient() {
        dbRestClient = DBRestClient(session: DBSession.sharedSession())
        dbRestClient.delegate = self
        dbRestClient.loadMetadata("/")
    }
    
    func handleDidLinkNotification(notification: NSNotification) {
        func handleDidLinkNotification(notification: NSNotification) {
            initDropboxRestClient()
            bbiConnect.title = "Disconnect"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: IBAction method implementation
    
    @IBAction func connectToDropbox(sender: AnyObject) {
        if !DBSession.sharedSession().isLinked() {
            DBSession.sharedSession().linkFromController(self)
        }
        else {
            DBSession.sharedSession().unlinkAll()
            bbiConnect.title = "Connect"
            dbRestClient = nil
            
        }
    }
    
    
    @IBAction func performAction(sender: AnyObject) {
        if !DBSession.sharedSession().isLinked() {
            print("You're not connected to Dropbox")
            return
        }
        
        let actionSheet = UIAlertController(title: "Upload file", message: "Select file to upload", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let uploadTextFileAction = UIAlertAction(title: "Upload text file", style: UIAlertActionStyle.Default) { (action) -> Void in
            
            let uploadFilename = "testtext.txt"
            let sourcePath = NSBundle.mainBundle().pathForResource("testtext", ofType: "txt")
            let destinationPath = "/"
            
            self.dbRestClient.uploadFile(uploadFilename, toPath: destinationPath, withParentRev: nil, fromPath: sourcePath)
            
            
        }
        
        let uploadImageFileAction = UIAlertAction(title: "Upload image", style: UIAlertActionStyle.Default) { (action) -> Void in
            let uploadFilename = "nature.jpg"
            let sourcePath = NSBundle.mainBundle().pathForResource("nature", ofType: "jpg")
            let destinationPath = "/"
            
            self.dbRestClient.uploadFile(uploadFilename, toPath: destinationPath, withParentRev: nil, fromPath: sourcePath)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            
        }
        
        actionSheet.addAction(uploadTextFileAction)
        actionSheet.addAction(uploadImageFileAction)
        actionSheet.addAction(cancelAction)
        
        presentViewController(actionSheet, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func reloadFiles(sender: AnyObject) {
        
       
         if let variable = dbRestClient{
            dbRestClient.loadMetadata("/")
            print("success")
        }
         else{
            print("failure")
        }
        
        
        
    }
    
    
    // MARK: UITableview method implementation
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let metadata = dropboxMetadata {
            return metadata.contents.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idCellFile", forIndexPath: indexPath) as! UITableViewCell
        
        let currentFile: DBMetadata = dropboxMetadata.contents[indexPath.row] as! DBMetadata
        cell.textLabel?.text = currentFile.filename
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    
    
    func restClient(client: DBRestClient!, uploadedFile destPath: String!, from srcPath: String!, metadata: DBMetadata!) {
        print("The file has been uploaded.")
        print(metadata.path)
        dbRestClient.loadMetadata("/")
        
    }
    
    func restClient(client: DBRestClient!, uploadFileFailedWithError error: NSError!) {
        print("File upload failed.")
        print(error.description)
    }
    
    
    
    func restClient(client: DBRestClient!, loadedMetadata metadata: DBMetadata!) {
        dropboxMetadata = metadata;
        tblFiles.reloadData()
    }
    
    
    func restClient(client: DBRestClient!, loadMetadataFailedWithError error: NSError!) {
        print(error.description)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedFile: DBMetadata = dropboxMetadata.contents[indexPath.row] as! DBMetadata
        
        let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! NSString
        
        
        // let localFilePath = documentsDirectoryPath.stringByAppendingPathComponent(selectedFile.filename)
        
        //  print("The documents directory path to download to is : \(documentsDirectoryPath)")
        // print("The local file should be: \(localFilePath)")
        
        
        
        
        
        
        
        showProgressBar()
        
        dbRestClient.loadFile(selectedFile.path, intoPath: documentsDirectoryPath as String)
    }
    
    
    func restClient(client: DBRestClient!, loadedFile destPath: String!, contentType: String!, metadata: DBMetadata!) {
        
       
        
        
        
        let title = "This format is incorrect"
        let message = "You can only download file that is in .txt format"
        let okText = "OK"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okayButton = UIAlertAction(title: okText, style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(okayButton)
        
        if contentType.rangeOfString("text") != nil{
            print("this is text")
            self.performSegueWithIdentifier("segue", sender: nil)
        }
        else{
            print("this is an error")
            presentViewController(alert, animated: true, completion: nil)
            return;
        }
        
        
        let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! NSString
        print("The file \(metadata.filename) was downloaded. Content type: \(contentType). The path to it is : \(documentsDirectoryPath)" )
        progressBar.hidden = true
        
      
        
        
        
        
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        
        
        let localFilePath = documentsURL.URLByAppendingPathComponent("Documents")
        
        let checkValidation = NSFileManager.defaultManager()
        
        if (checkValidation.fileExistsAtPath(localFilePath.path!))
        {
            print("FILE AVAILABLE");
        }
        else
        {
            print("FILE NOT AVAILABLE");
        }
        
    }
    
    func restClient(client: DBRestClient!, loadFileFailedWithError error: NSError!) {
        print(error.description)
        progressBar.hidden = true
    }
    
    
    func restClient(client: DBRestClient!, loadProgress progress: CGFloat, forFile destPath: String!) {
        progressBar.progress = Float(progress)
    }
    
    func showProgressBar() {
        progressBar.progress = 0.0
        progressBar.hidden = false
    }
    
    
    
    
    
}

