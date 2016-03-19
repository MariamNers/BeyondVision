//
//  File.swift
//  BeyondVision
//
//  Created by Mariam Nersisyan on 17/03/2016.
//  Copyright © 2016 MariamN. All rights reserved.
//

import Foundation
import UIKit
import AudioKit

class GraphController: UIViewController{

    
    @IBOutlet weak var graphView: GraphPlotter!
    //Label outlets
    
 
    
    @IBOutlet weak var ymaxpoint: UILabel!
    
    @IBOutlet weak var maxLabel: UILabel!
    
    @IBOutlet weak var button: UIButton!

    
    override func viewDidLoad() {
        
        view.backgroundColor = UIColor.flatSandColor()
      
        
        
        graphView.isAccessibilityElement = true
        graphView.accessibilityValue = "This is a visual representation of your data output in a graph. Press play to hear the sound of what it looks like"
        
        
     
        
        maxLabel.text = "\(graphView.graphPoints.maxElement()!)"
        ymaxpoint.text = "\(graphView.graphPoints2.maxElement()!)"
        
        
        button.isAccessibilityElement = true
        button.accessibilityValue = "Press me to hear the sound"
        
        
        button.layer.cornerRadius = 10;
        button.clipsToBounds = true;
       
        
        
        

            }
    
    
    func somefunc() -> [Int] {
        
        let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        
        print(documentsDirectoryPath)
        
        
        var newarray = [Int]()
        
        do{
            let data = try String(contentsOfFile: documentsDirectoryPath as String,
                encoding: NSASCIIStringEncoding)
            print(data)
            
             newarray = data.characters.filter{Int(String($0)) != nil}.map{Int(String($0))! }
            print(newarray)
            
            
        }
        catch{
            
            print("error")
        }
        
        
        return newarray
       
        
    }

}