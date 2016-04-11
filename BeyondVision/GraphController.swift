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
        
        
        button.isAccessibilityElement = true
        button.accessibilityValue = "Press me to hear the sound. You can always mute the sound by pressing the sound button again"
        
        
        button.layer.cornerRadius = 10;
        button.clipsToBounds = true;
       
        
        
        

            }

    
    @IBAction func pressMe(sender: UIButton) {
        let image : UIImage = UIImage(named:"mute.png")!
        let image2 : UIImage = UIImage(named:"vol1.png")!
        
        
       
        
        let volume = AKOperation.sineWave(frequency:6.8).scale(minimum: 0.3, maximum: 0.3)
        
        let minimum = Double(10)
        let maximum = Double(500)
        let frequency = AKOperation.sineWave(frequency: 0.7).scale(minimum: minimum, maximum: maximum)
        let oscillator = AKOperation.sineWave(frequency: frequency, amplitude: volume)
        let oscillatorNode = AKOperationGenerator(operation: oscillator)
        AudioKit.output = oscillatorNode
        AudioKit.start()

        
        if oscillatorNode.isPlaying {
            
            print("am i here??")
            oscillatorNode.stop()
            sender.setImage(image, forState: .Normal)

        }
        
        else{
            
            oscillatorNode.start()
            sender.setImage(image2, forState: .Normal)
            print("I am here")
            usleep(2900000)
            oscillatorNode.stop()

        }
        
        AudioKit.stop()
        
        AKPlaygroundLoop (every: 0.12){
        
        }

    }
    
    override func viewDidDisappear(animated: Bool) {

    }



}