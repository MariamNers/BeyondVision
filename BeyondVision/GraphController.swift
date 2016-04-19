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

        maxLabel.text = "\(DBController().arraysize()!.maxElement()!)"
        
        
        button.isAccessibilityElement = true
        button.accessibilityValue = "Press me to hear the sound. You can always mute the sound by pressing the sound button again"
        
        
        button.layer.cornerRadius = 10;
        button.clipsToBounds = true;
       
        
        let title = "Please adjust your device's volume before pressing on the sound button"
        let message = "Approach sound triggers with caution so that you don't damage your ears"
        let okText = "Got it"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okayButton = UIAlertAction(title: okText, style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(okayButton)
        presentViewController(alert, animated: true, completion: nil)

        

            }

    
    @IBAction func pressMe(sender: UIButton) {
        
        
        let data = DBController().secondarray()
        print(data)
        AKSettings.audioInputEnabled = true
        
        var oscillator = AKOscillator()
        
//        AudioKit.output = oscillator
        
        
        let updateRate = 5.0
        
        oscillator.rampTime = 1.0/updateRate
        oscillator.start()
        
        var counter = 0
        
        var panner = AKPanner(oscillator)
        AudioKit.output = panner
        AudioKit.start()

        
        
        AKPlaygroundLoop(frequency: updateRate) {
            
            let frequency = data![counter % data!.count] * 100.0
//            let pan = Double(counter % 21) / 10.0  - 1.0 // [-1...1]
            let pan = sin(Double(counter) / 6.0)
            oscillator.frequency = frequency
            panner.pan = pan
            counter += 1
            if counter == data!.count{
            
                oscillator.stop()
                AudioKit.stop()

            }
        }
    }

}