//
//  FinalIteration2AddressViewController.swift
//  GoogleMapsAPI-4900
//
//  Created by Jan Ycasas on 2016-04-29.
//  Copyright © 2016 Jan Ycasas. All rights reserved.
//

import UIKit
import KRProgressHUD

class FinalIteration2AddressViewController: UIViewController, UITextFieldDelegate{
    
    var long                 : Double!
    var lat                  : Double!
    
    var locationList         : Array<Location>    = Array<Location>()
    
    @IBOutlet weak var inputLocation: UITextField!
    
    let util : Utility = Utility()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputLocation.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FinalIteration2FilterViewController.ReachabilityStatusChanged), name: "ReachStatusChanged", object: nil)
        
    }
    
    func ReachabilityStatusChanged(){
        if(reachabilityStatus == kNOTREACHABLE ){
            
            let alertController = UIAlertController(title: "Lost Internet Connection", message:
                "Please connect to internet to use the app", preferredStyle: .ActionSheet)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        } else if reachabilityStatus == kREACHABLE {
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let yourNextViewController = (segue.destinationViewController as! FinalIteration2ViewController)
        if(self.inputLocation.text != "") {
        
            KRProgressHUD.show()
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), {
                // Do something...
                
                self.util.doGeoCoding(self.inputLocation.text!) {
                    receivedLat,receivedLong in
                    
                    yourNextViewController.lat          = receivedLat
                    yourNextViewController.long         = receivedLong
                    
                    yourNextViewController.setUpLocation()
                    yourNextViewController.initialSetUp()
                    
                    KRProgressHUD.dismiss()
                }
            });
        } else {
            yourNextViewController.lat          = lat
            yourNextViewController.long         = long
            
            yourNextViewController.setUpLocation()
            yourNextViewController.initialSetUp()
        }
        
    }
    
    // MARK: -- TextField
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}


