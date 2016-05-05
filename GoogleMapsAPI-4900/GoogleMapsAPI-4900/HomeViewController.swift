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
    var long            : Double!
    var lat             : Double!
    
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
        /*
        for element in result {
            print("/nLOCATION")
            print(element.name)
            print(element.lat)
            print(element.long)
            print(element.rating)
            print(element.vicinity)
            print(element.currentlyOpen)
        }
         */
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
            print("GOOD")
            locationManager.startUpdatingLocation()
        } else if(CLLocationManager.authorizationStatus() ==  .NotDetermined){
            print("NOT ON")
            locationManager.requestWhenInUseAuthorization()
            checkCoreLocationPermission()
        } else if(CLLocationManager.authorizationStatus() ==  .Restricted) {
            // put an alert and explain what is going on
            print("RESTRICTED")
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        var location : CLLocation!
        
        location = (locations).last!
        
        //print("in function")
        locationManager.stopUpdatingLocation()
        
        print(location.coordinate)
        
        lat = Double(location.coordinate.latitude)
        long = Double(location.coordinate.longitude)
        
        //print("out function")
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "finalViewControllerSegue") {
            
            let yourNextViewController = (segue.destinationViewController as! FinalViewController)
            
            
            //yourNextViewController.lat  = lat
            //yourNextViewController.long = long
            
        }
    }
    
}

