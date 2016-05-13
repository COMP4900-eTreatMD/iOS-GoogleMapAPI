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
    @IBOutlet weak var specialization: UIPickerView!
    @IBOutlet weak var specializationLabel: UILabel!
    
    var long                 : Double!
    var lat                  : Double!
    
    var filterIndex                : Int      = 0
    var specIndex                  : Int      = 0
    
    var locationList         : Array<Location>    = Array<Location>()
    var specilizationString  : String   = ""

    var filterData = ["All","Hospital", "Pharmacy", "Physiotherapist", "Doctor"];
    var specilizationArray = ["Audiologist","Allergist","Andrologists","Anesthesiologist","Cardiologist","Dentist","Dermatologist","Endocrinologist","Epidemiologists","Gastroenterologist","Gynecologist","Hematologist","Hepatologists","Immunologist","Internists","Neonatologist","Nephrologists","Neurologist","Neurosurgeons","Obstetrician","Oncologist","Ophthalmologist","Orthopedist","Primatologist","Parasitologist","Pathologists","Pediatrician","Physiatrist","Plastic Surgeon","Podiatrists","Psychiatrists","Pulmonologist","Radiologists","Reproductive Endocrinologist","Rheumatologist","Surgeon","Thoracic Oncologist","Urologist"]
    
    var filter          : String            = "All"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "ReachabilityStatusChanged", name: "ReachStatusChanged", object: nil)
        picker.dataSource = self
        picker.delegate = self
        
        specializationLabel.hidden = true
        specialization.hidden = true
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
    
    // MARK: -- UI PICKER
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        /*
        if(pickerView == picker){
            print("PICKER")
        } else {
            print("SPEC")
        }'
         */
        if(pickerView == picker){
            return filterData.count
        } else {
            return specilizationArray.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == picker){
            return filterData[row]
        } else {
            return specilizationArray[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == picker){
            print("PICKER")
            filterIndex = row
            if(filterData[filterIndex] == "Doctor"){
                specialization.hidden = false
                specializationLabel.hidden = false
            } else {
                specialization.hidden = true
                specializationLabel.hidden = true
            }
        } else {
            specIndex = row
        }
        
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
        if(filterData[filterIndex] == "Doctor"){
            specilizationString = specilizationArray[specIndex]
        }
        
        yourNextViewController.lat          = lat!
        yourNextViewController.long         = long!
        yourNextViewController.locationList = locationList
        yourNextViewController.filter       = filterData[filterIndex]
        
        yourNextViewController.filterResults(filterData[filterIndex],name: specilizationString)
        
    }
                                            
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}


