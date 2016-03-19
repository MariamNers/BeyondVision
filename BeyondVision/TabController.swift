//
//  TabController.swift
//  BeyondVision
//
//  Created by Mariam Nersisyan on 13/03/2016.
//  Copyright © 2016 MariamN. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework


class TabController : UITableViewController {
   
    
    
    override func viewDidLoad() {
      
        self.navigationController?.hidesNavigationBarHairline = true
        

        navigationController!.navigationBar.barTintColor = UIColor.flatSandColor()
        self.tableView.backgroundColor = UIColor.flatSandColor()
        
        tableView.tableFooterView = UIView()
        
    }

    var image : UIImage = UIImage(named:"test.png")!
    var image1 : UIImage = UIImage(named:"guide.png")!
    var image2 : UIImage = UIImage(named:"upload.png")!
    var image3 : UIImage = UIImage(named:"plot.png")!


    
    let MinHeight: CGFloat = 1.0
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let tHeight = tableView.bounds.height
        
        let temp = tHeight/CGFloat(4)
        
        return temp > MinHeight ? temp : MinHeight
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.init(
            gradientStyle: UIGradientStyle.Radial,
            withFrame: view.frame,
            andColors : [ UIColor.flatSandColor(), UIColor.flatSandColorDark() ]
            
        )
        
        switch (indexPath.row){
        case 0:
            cell.imageView?.image = image
            
            break;
        case 1:
            cell.imageView?.image = image1
            break;
        case 2:
            cell.imageView?.image = image2
            break;
        case 3:
            cell.imageView?.image = image3
            break;
        default: break;
        }
        
    }

    }

    

