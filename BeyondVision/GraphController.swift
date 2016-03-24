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
        button.accessibilityValue = "Press me to hear the sound. You can always mute the sound by pressing the sound button again"
        
        
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
            
            
            
             newarray = data.characters.split(){$0 == ","}.map{
                Int(String.init($0).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))!}
            
            
            print(newarray)
            
            
        }
        catch{
            
            print("error")
        }
        
        
        return newarray
       
        
    }
    
    @IBAction func pressMe(sender: UIButton) {
        let image : UIImage = UIImage(named:"mute.png")!
        let image2 : UIImage = UIImage(named:"vol1.png")!
        
        
       
        
        let volume = AKOperation.sineWave(frequency:0.8).scale(minimum: 0.3, maximum: 0.3)
        
        let minimum = Double(10)
        let maximum = Double(500)
        let frequency = AKOperation.sineWave(frequency: 0.7).scale(minimum: minimum, maximum: maximum)
        let oscillator = AKOperation.sineWave(frequency: frequency, amplitude: volume)
        let oscillatorNode = AKOperationGenerator(operation: oscillator)
        AudioKit.output = oscillatorNode
        AudioKit.start()

        
        if oscillatorNode.isPlaying {

            oscillatorNode.stop()
            sender.setImage(image, forState: .Normal)

        }
        
        else{
            
            oscillatorNode.start()
            sender.setImage(image2, forState: .Normal)
            print("I am here")
            sleep(2)
            oscillatorNode.stop()

        }
        
        AudioKit.stop()

    }
    
    override func viewDidDisappear(animated: Bool) {

    }



}