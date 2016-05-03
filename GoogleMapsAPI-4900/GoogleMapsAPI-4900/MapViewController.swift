//
//  ViewController.swift
//  GoogleMapsAPI-4900
//
//  Created by Jan Ycasas on 2016-04-29.
//  Copyright © 2016 Jan Ycasas. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class MapViewController: UIViewController , CLLocationManagerDelegate{
    
    @IBOutlet weak var container: UIView!
    
    var locaionManager : CLLocationManager!
    var userLocation   : CLLocation = CLLocation()
    
    var location : CLLocation! {
        didSet {
            userLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        locaionManager = CLLocationManager()
        locaionManager.delegate = self
        locaionManager.desiredAccuracy = kCLLocationAccuracyBest
        checkCoreLocationPermission()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        location = (locations).last
        userLocation = (locations).last!
        
        locaionManager.stopUpdatingLocation()
        
        print(userLocation.coordinate)
        
        setMap(Double(userLocation.coordinate.latitude),long: Double(userLocation.coordinate.longitude))
        
        print("out function")
        
        
    }
    
    func setMap(lat : Double, long : Double){
        
        let camera = GMSCameraPosition.cameraWithLatitude(lat,
                                                          longitude: long, zoom: 6)
        let mapView = GMSMapView.mapWithFrame(CGRectMake(0,50,400,400), camera: camera)
        mapView.myLocationEnabled = true
        
        self.view.addSubview(mapView)
        /*
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(lat, long)
            marker.title = "Sydney"
            marker.snippet = "Australia"
            marker.map = mapView
        */
    }

    


}

