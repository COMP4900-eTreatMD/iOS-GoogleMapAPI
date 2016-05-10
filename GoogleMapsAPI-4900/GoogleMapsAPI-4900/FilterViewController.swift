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
    
    var hospitalOn              : Bool = true
    var pharmacyOn              : Bool = true
    var phsiotherapistOn        : Bool = true
    var doctorOn                : Bool = true
    
    @IBOutlet weak var hospitalSwitch: UISwitch!
    @IBOutlet weak var pharmacySwitch: UISwitch!
    @IBOutlet weak var physiotherapistSwitch: UISwitch!
    @IBOutlet weak var doctorSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        hospitalSwitch.setOn(hospitalOn, animated: true)
        pharmacySwitch.setOn(pharmacyOn, animated: true)
        physiotherapistSwitch.setOn(phsiotherapistOn, animated: true)
        doctorSwitch.setOn(doctorOn, animated: true)
        
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

        var util                    : Utility?
        var yourNextViewController  : FinalViewController?
        var types                   : String                = ""
        
        util                    = Utility()
        yourNextViewController  = (segue.destinationViewController as! FinalViewController)
        types                   = getListOfTypes()
        
        util!.doHttpRequest(self.lat!, long: self.long!, type: types) {
            choiceList in

            yourNextViewController!.locationList = choiceList
            yourNextViewController!.tableViewReloaded()
        }
        
        yourNextViewController?.hospitalOn = hospitalSwitch.on
        yourNextViewController?.pharmacyOn = pharmacySwitch.on
        yourNextViewController?.phsiotherapistOn = physiotherapistSwitch.on
        yourNextViewController?.doctorOn = doctorSwitch.on
        
        yourNextViewController!.lat  = lat!
        yourNextViewController!.long = long!
        
    }
    
    func getListOfTypes() -> String{
        var types : String = ""
        
        if(hospitalSwitch.on){
            types             += "hospital|"
        }
        
        if(pharmacySwitch.on){
            types             += "pharmacy|"
        }
        
        if(physiotherapistSwitch.on){
            types             += "physiotherapist|"
        }
        
        if(doctorSwitch.on){
            types             += "doctor|"
        }
        
        return types
    }
    
}

