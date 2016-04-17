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
       
        
        
        

            }

    
    @IBAction func pressMe(sender: UIButton) {
        
        
        let data = DBController().firstarray()
        
        var oscillator = AKOscillator()
        
        AudioKit.output = oscillator
        
        AudioKit.start()
        
        let updateRate = 3.0
        
        oscillator.rampTime = 1.0/updateRate
        
        oscillator.start()
        
        var counter = 0
        
        AKPlaygroundLoop(frequency: updateRate) {
            
            let frequency = data![counter % data!.count] * 50.0 + 1000.0
            
            oscillator.frequency = frequency
            
            counter += 1
           // usleep(290000)
            
            if counter == data!.count{
            
                oscillator.stop()
                AudioKit.stop()

            }
        }
    }
    
    override func viewDidDisappear(animated: Bool) {

    }
}