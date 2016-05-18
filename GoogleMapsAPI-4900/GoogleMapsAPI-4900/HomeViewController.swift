//
//  HomeViewController.swift
//  GoogleMapsAPI-4900
//
//  Created by Jan Ycasas on 2016-04-29.
//  Copyright © 2016 Jan Ycasas. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager : CLLocationManager!
    var long            : Double?
    var lat             : Double? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkCoreLocationPermission()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkCoreLocationPermission(){
        if(CLLocationManager.authorizationStatus() ==  .AuthorizedWhenInUse){
            locationManager.startUpdatingLocation()
        } else if(CLLocationManager.authorizationStatus() ==  .NotDetermined){

            locationManager.requestWhenInUseAuthorization()
            checkCoreLocationPermission()
        } else if(CLLocationManager.authorizationStatus() ==  .Restricted) {
            // put an alert and explain what is going on
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        var location : CLLocation!
        
        location = (locations).last!
        
        //print("in function")
        locationManager.stopUpdatingLocation()
        
        lat = Double(location.coordinate.latitude)
        long = Double(location.coordinate.longitude)
        
        //print("out function")
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "finalViewControllerSegue") {
            
            let yourNextViewController = (segue.destinationViewController as! FinalViewController)
            
            
            yourNextViewController.lat  = lat!
            yourNextViewController.long = long!
            
            yourNextViewController.initialSetUp()
            
        }
        
        if(segue.identifier == "finalIteration2ControllerSegue") {
            
            let yourNextViewController = (segue.destinationViewController as! FinalIteration2ViewController)
            
            yourNextViewController.lat  = lat!
            yourNextViewController.long = long!
            
            yourNextViewController.setUpLocation()
            yourNextViewController.initialSetUp()
            
        }
    }
    
}

