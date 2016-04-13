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
    var array: [Int]? = []
    var data: String = ""     
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
        
       
         if let _ = dbRestClient{
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
        let cell = tableView.dequeueReusableCellWithIdentifier("idCellFile", forIndexPath: indexPath) 
        
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
        print("i am at the rest client load metata")
        print(error.description)
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){


        
        
        let selectedFile: DBMetadata = dropboxMetadata.contents[indexPath.row] as! DBMetadata
        
        let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        
        let localFilePath = (documentsDirectoryPath as NSString).stringByAppendingPathComponent("test123.txt")
        
        print("The file to download is at: \(selectedFile.path)")
        print("The documents directory path to download to is : \(documentsDirectoryPath)")
        print("The local file should be: \(localFilePath)")
        
        showProgressBar()
        
    
    
    
        
        dbRestClient.loadFile(selectedFile.path, intoPath: localFilePath as String)
        
        
        
        
    
    }
    
    func dosmth() -> [Int]? {
        
        let title = "Your file contains unrecognised characters"
        let message = "You should only have numbers seperated by a comma in your file. Please check your file again or refer to the instructions"
        let okText = "OK"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okayButton = UIAlertAction(title: okText, style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(okayButton)

        
        let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        
        let localFilePath = (documentsDirectoryPath as NSString).stringByAppendingPathComponent("test123.txt")
        
        
        
        do{
            
            data = try String(contentsOfFile: localFilePath as String,
                                  encoding: NSASCIIStringEncoding)
            
            
        
            array = data.characters.split(){$0 == ","}.flatMap{
            (Int(String.init($0).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())))}
            
            if array?.isEmpty == true{
                print("the array is empty")
                presentViewController(alert, animated: true, completion: nil)
                
            
            }
            
          //  print(data)
            
            print("i am at the do statement")
            
        }
        
        
            
        catch let error {
            print(error)
            print("i am at the error statement hahah")
        }
        
        print(array, "i am here buddy")
        return array
   
        
    }
    
    
    func restClient(client: DBRestClient!, loadedFile destPath: String!, contentType: String!, metadata: DBMetadata!){
        

        
        let title = "This format is incorrect"
        let message = "You can only download file that is in .txt format"
        let okText = "OK"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okayButton = UIAlertAction(title: okText, style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(okayButton)
        
        if contentType.rangeOfString("text") != nil{
            print("this is text")
//            dispatch_async(dispatch_get_main_queue(),{
//                           self.performSegueWithIdentifier("segue", sender: nil)
//                       });
          
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
        
        
        let localFilePath = documentsURL.URLByAppendingPathComponent("test123.txt")
        
        let checkValidation = NSFileManager.defaultManager()
        
        if (checkValidation.fileExistsAtPath(localFilePath.path!))
        {
            print("FILE AVAILABLE");
        }
        else
        {
            print("FILE NOT AVAILABLE");
        }
        
        
        dosmth()
        
        
        self.performSegueWithIdentifier("segue", sender: nil)

        return  
        
    }
    
    func restClient(client: DBRestClient!, loadFileFailedWithError error: NSError!) {
        print("i am at the rest client error")
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

