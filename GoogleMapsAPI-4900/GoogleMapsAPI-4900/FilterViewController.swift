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

class FilterViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate {
    
    var long            : Double?
    var lat             : Double?
    
    var types           : String  = ""

    
    @IBOutlet weak var filter: UIPickerView!
    var filterData     = ["Hospital", "Pharmacy", "Physiotherapist", "Docotor"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.filter.dataSource = self;
        self.filter.delegate = self;
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filterData.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return filterData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if(row == 0) {
            types             = "hospital"
        } else if(row == 1) {
            types             = "pharmacy"
        } else if(row == 2) {
            types             = "physiotherapist"
        } else {
            types             = "doctor"
        }
    }
    
    /**
     
        Passes variables (Lat, Long)to FinalViewController. Does REST call with 
        the Google Places API. Gets the radius and category that the user is looking 
        for.
    
     */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        var util                    : Utility?
        var yourNextViewController  : FinalViewController?
        
        util                    = Utility()
        yourNextViewController  = (segue.destinationViewController as! FinalViewController)
        
        print(types)
        
        util!.doHttpRequest(self.lat!, long: self.long!, type: types) {
            choiceList in

            yourNextViewController!.locationList = choiceList
            yourNextViewController!.tableViewReloaded()
        }
        
        
        yourNextViewController!.lat  = lat!
        yourNextViewController!.long = long!
        
    }
    
}

