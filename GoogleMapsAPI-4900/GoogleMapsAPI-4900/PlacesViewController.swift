//
//  ViewController.swift
//  GoogleMapsAPI-4900
//
//  Created by Jan Ycasas on 2016-04-29.
//  Copyright © 2016 Jan Ycasas. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class PlacesViewController: UIViewController, CLLocationManagerDelegate {
    
    // Instantiate a pair of UILabels in Interface Builder
    /*
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
     */
    
    var locaionManager : CLLocationManager!
    var userLocation   : CLLocation = CLLocation()
    
    override func viewDidAppear(animated: Bool) {
        
    
 
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locaionManager = CLLocationManager()
        locaionManager.delegate = self
        locaionManager.desiredAccuracy = kCLLocationAccuracyBest
        checkCoreLocationPermission()
        
    }
    
    func checkCoreLocationPermission(){
        if(CLLocationManager.authorizationStatus() ==  .AuthorizedWhenInUse){
            print("GOOD")
            locaionManager.startUpdatingLocation()
        } else if(CLLocationManager.authorizationStatus() ==  .NotDetermined){
            print("NOT ON")
            locaionManager.requestWhenInUseAuthorization()
        } else if(CLLocationManager.authorizationStatus() ==  .Restricted) {
            // put an alert and explain what is going on
            print("RESTRICTED")
            
        }
    }
    
    // MARK: --CLLocationManagerDelagate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("in function")
        
        userLocation = (locations).last!
        
        locaionManager.stopUpdatingLocation()
        
        print(userLocation.coordinate)
        
        setMap(Double(userLocation.coordinate.latitude),long: Double(userLocation.coordinate.longitude))
        
        print("out function")
        
        
    }
    
     func setMap(lat : Double, long : Double){
        
        let center = CLLocationCoordinate2DMake(lat, long)
        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.004, center.longitude + 0.004)
        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.004, center.longitude - 0.004)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePicker(config: config)
        
        placePicker.pickPlaceWithCallback({ (place: GMSPlace?, error: NSError?) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let place = place {
                print("Place name \(place.name)")
                print("Place address \(place.formattedAddress)")
                print("Place attributions \(place.attributions)")
            } else {
                print("No place selected")
            }
        })
        
    }
    

    
}

