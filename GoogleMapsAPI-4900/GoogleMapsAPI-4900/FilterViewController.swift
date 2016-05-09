//
//  FilterViewController.swift
//  GoogleMapsAPI-4900
//
//  Created by Jan Ycasas on 2016-04-29.
//  Copyright © 2016 Jan Ycasas. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class FilterViewController: UIViewController {
    
    var long            : Double?
    var lat             : Double?
    
    @IBOutlet weak var categoryInput: UITextField!
    @IBOutlet weak var radiusInput: UITextField!
    
    @IBOutlet weak var hospitalSwitch: UISwitch!
    @IBOutlet weak var pharmacySwitch: UISwitch!
    @IBOutlet weak var physiotherapistSwitch: UISwitch!
    @IBOutlet weak var doctorSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     
        Passes variables (Lat, Long)to FinalViewController. Does REST call with 
        the Google Places API. Gets the radius and category that the user is looking 
        for.
    
     */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "goToFinal") {
            
            var util                    : Utility?
            var yourNextViewController  : FinalViewController?
            
            util                    = Utility()
            yourNextViewController  = (segue.destinationViewController as! FinalViewController)
            
            util!.doHttpRequest(self.lat!, long: self.long!,
                               radius: radiusInput.text!, type: categoryInput.text!) {
                choiceList in

                yourNextViewController!.locationList = choiceList
                yourNextViewController!.tableViewReloaded()
            }
            
            if(hospitalSwitch.on){
                print("hospitalSwitch is on")
            }
            
            if(pharmacySwitch.on){
                print("pharmacySwitch is on")
            }
            
            if(physiotherapistSwitch.on){
                print("physiotherapistSwitch is on")
            }
            
            if(doctorSwitch.on){
                print("doctorSwitch")
            }
            
            yourNextViewController!.lat  = lat!
            yourNextViewController!.long = long!
        }
        
    }
    
}

