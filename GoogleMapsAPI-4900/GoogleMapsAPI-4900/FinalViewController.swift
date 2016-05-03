//
//  FinalViewController.swift
//  GoogleMapsAPI-4900
//
//  Created by Jan Ycasas on 2016-04-29.
//  Copyright © 2016 Jan Ycasas. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class FinalViewController: UIViewController, CLLocationManagerDelegate{
    
    var locationManager : CLLocationManager!
    let util            : Utility            = Utility()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /*
            let util = Utility()
            print("utility")
            util.doHttpRequest(49.246292,long: -123.116226) {choiceList in
                print("choiceList")
                print(choiceList.count)
                for element in choiceList {
                    print("/nLOCATION")
                    print(element.name)
                    print(element.lat)
                    print(element.long)
                    print(element.rating)
                    print(element.vicinity)
                    print(element.currentlyOpen)
                }
            }
         
         */
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkCoreLocationPermission()
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK: --Location (CLLocationManagerDelagate) + Location functions
    
    func checkCoreLocationPermission(){
        if(CLLocationManager.authorizationStatus() ==  .AuthorizedWhenInUse){
            print("GOOD")
            locationManager.startUpdatingLocation()
            
        } else if(CLLocationManager.authorizationStatus() ==  .NotDetermined){
            print("NOT ON")
            locationManager.requestWhenInUseAuthorization()
        } else if(CLLocationManager.authorizationStatus() ==  .Restricted) {
            // put an alert and explain what is going on
            print("RESTRICTED")
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        var location : CLLocation!
        
        location = (locations).last!
        
        print("in function")
        locationManager.stopUpdatingLocation()
        
        print(location.coordinate)
        
        let util = Utility()
        print("utility")
        util.doHttpRequest(location.coordinate.latitude,long: location.coordinate.longitude) {
            choiceList in
            for element in choiceList {
                print("/nLOCATION")
                print(element.name)
                print(element.lat)
                print(element.long)
                print(element.rating)
                print(element.vicinity)
                print(element.currentlyOpen)
            }
        }
        
        print("out function")
        
    }
    
}

