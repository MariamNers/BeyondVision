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
    var array: [Double]! = []
    var data: String = ""     
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tblFiles?.delegate = self
        tblFiles?.dataSource = self
        tblFiles?.tableFooterView = UIView()
        tblFiles?.backgroundColor = UIColor.flatSandColor()
        self.viewY?.backgroundColor  = UIColor.flatSandColor()
        
        progressBar?.hidden = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleDidLinkNotification:", name: "didLinkToDropboxAccountNotification", object: nil)
        
        if DBSession.sharedSession().isLinked() {
            bbiConnect?.title = "Disconnect"
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
    
    func firstarray() -> [Double]? {
        
        let title = "Your file is empty"
        let message = "Please fill in the file with appropriate numbers as per instructions"
        let okText = "OK"
        
        let title1 = "Your file contains unrecognised characters"
        let message1 = "You should only have numbers seperated by a comma in your file. Please check your file again or refer to the instructions"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okayButton = UIAlertAction(title: okText, style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(okayButton)
        let alert1 = UIAlertController(title: title1, message: message1, preferredStyle: UIAlertControllerStyle.Alert)
        alert1.addAction(okayButton)
        
        let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        
        let localFilePath = (documentsDirectoryPath as NSString).stringByAppendingPathComponent("test123.txt")
        
        
        do{
            
            data = try String(contentsOfFile: localFilePath as String,
                                  encoding: NSASCIIStringEncoding)
            
            if data == "" {
            
            print("this file is empty")
            presentViewController(alert, animated: true, completion: nil)

            }
            
            let myStrings = data.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())

          var trial=myStrings[0].componentsSeparatedByString(",").flatMap{Double($0.stringByTrimmingCharactersInSet(.whitespaceCharacterSet()))}
            
           array = trial
            
            if array?.isEmpty == true{
                print("the array is empty")
                presentViewController(alert1, animated: true, completion: nil)
            }
            
            
        }
        
        
            
        catch let error {
            print(error)
        }
        
        return array
   
        
    }
    
    func secondarray() -> [Double]? {
        
        let title = "Your file is empty"
        let message = "Please fill in the file with appropriate numbers as per instructions"
        let okText = "OK"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okayButton = UIAlertAction(title: okText, style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(okayButton)
        
        
        let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        
        let localFilePath = (documentsDirectoryPath as NSString).stringByAppendingPathComponent("test123.txt")
        
        
        
        do{
            
            data = try String(contentsOfFile: localFilePath as String,
                              encoding: NSASCIIStringEncoding)
            
            let myStrings = data.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
            
            let textArr = data.componentsSeparatedByString("\r")
            let myCount = textArr.count
            
            if myCount == 1 {
                
                let trial=myStrings[0].componentsSeparatedByString(",").flatMap{Double($0.stringByTrimmingCharactersInSet(.whitespaceCharacterSet()))}
                
                array = trial
            
            }
            else{
                
                let trial=myStrings[1].componentsSeparatedByString(",").flatMap{Double($0.stringByTrimmingCharactersInSet(.whitespaceCharacterSet()))}
                print(trial)
                
                array = trial
            
            }
            
        }
            
        catch let error {
            print(error)
        }
        
        return array
        
        
    }
    
    
    func arraysize() -> [Double]? {
        
        let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        
        let localFilePath = (documentsDirectoryPath as NSString).stringByAppendingPathComponent("test123.txt")
        
        
        
        do{
            
            data = try String(contentsOfFile: localFilePath as String,
                              encoding: NSASCIIStringEncoding)
            
            
            let myStrings = data.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
            
            
            
        var trial = myStrings[0].componentsSeparatedByString(",").flatMap{Double($0.stringByTrimmingCharactersInSet(.whitespaceCharacterSet()))}
            
            array = trial
            trial = myStrings[1].componentsSeparatedByString(",").flatMap{Double($0.stringByTrimmingCharactersInSet(.whitespaceCharacterSet()))}
            
            array.appendContentsOf(trial)

            print(array)
            
        }
            
            
            
        catch let error {
            print(error)
        }
        
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
        
        firstarray()!
        secondarray()!
        
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

