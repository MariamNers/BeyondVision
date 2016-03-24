import UIKit
import ChameleonFramework


class ViewController : UIViewController{
    @IBOutlet weak var textView: UITextView!

    @IBOutlet weak var myButton: UIButton!
    
    
    @IBOutlet weak var navigation: UINavigationItem!
    override func viewDidLoad() {

        self.navigationController?.hidesNavigationBarHairline = true

        
        navigationController?.navigationBar.barTintColor = UIColor.flatSandColor()


        

        view.backgroundColor = UIColor.flatSandColor()
        
        textView?.userInteractionEnabled = true
        textView?.editable = false
        
        textView?.backgroundColor = UIColor.clearColor()
        
        myButton?.layer.cornerRadius = 10;
        myButton?.clipsToBounds = true;
        
    }
    
   
    
    @IBAction func pressMe(sender: AnyObject) {
        
        self.performSegueWithIdentifier("segue", sender: nil)
    }


}