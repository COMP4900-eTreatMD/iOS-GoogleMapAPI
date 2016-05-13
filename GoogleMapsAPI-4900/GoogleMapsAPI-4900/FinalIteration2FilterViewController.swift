//
//  FinalIteration2FilterViewController.swift
//  GoogleMapsAPI-4900
//
//  Created by Jan Ycasas on 2016-04-29.
//  Copyright © 2016 Jan Ycasas. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import GoogleMaps
import MBProgressHUD

class FinalIteration2FilterViewController: UIViewController, UITextFieldDelegate,
                                           UIPickerViewDelegate,UIPickerViewDataSource{
    
    @IBOutlet weak var picker: UIPickerView!
    
    var long                 : Double!
    var lat                  : Double!
    
    var index                : Int      = 0
    
    var locationList         : Array<Location>    = Array<Location>()
    var specilizationString  : String   = ""

    var filterData = ["All","Hospital", "Pharmacy", "Physiotherapist", "Doctor"];
    
    var filter          : String            = "All"
    
    @IBOutlet weak var specilization: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "ReachabilityStatusChanged", name: "ReachStatusChanged", object: nil)
        picker.dataSource = self
        picker.delegate = self
        
        specilization.hidden = true
        specilization.delegate = self

    }
    
    func ReachabilityStatusChanged(){
        if(reachabilityStatus == kNOTREACHABLE ){
            let alertController = UIAlertController(title: "Lost Internet Connection", message:
                "Please connect to internet to use the app", preferredStyle: .ActionSheet)
            self.presentViewController(alertController, animated: true, completion: nil)
        }else if reachabilityStatus == kREACHABLE {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filterData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return filterData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(filterData[row] == "Doctor"){
            specilization.hidden = false
        }
        
        print(filterData[row])
        index = row
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let yourNextViewController = (segue.destinationViewController as! FinalIteration2ViewController)
        
        print("segue")
        if(filterData[index] == "Doctor"){
            specilizationString = specilization.text!
        }
        
        yourNextViewController.lat          = lat!
        yourNextViewController.long         = long!
        yourNextViewController.locationList = locationList
        yourNextViewController.filter       = filterData[index]
        
        yourNextViewController.filterResults(filterData[index],name: specilizationString)
        
    }
                                            
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}

