//
//  FinalIteration2MapViewController.swift
//  GoogleMapsAPI-4900
//
//  Created by Jan Ycasas on 2016-04-29.
//  Copyright © 2016 Jan Ycasas. All rights reserved.
//

import UIKit
import GoogleMaps

class FinalIteration2MapViewController: UIViewController{

    var long            : Double!
    var lat             : Double!
    var locationList    : Array<Location>    = Array<Location>()
    var filter          : String             = "All"
    
    var mapView         : GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
          NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FinalIteration2MapViewController.ReachabilityStatusChanged), name: "ReachStatusChanged", object: nil)
        setMap(lat, long: long)
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
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
    
    /**
     
     Setting the initial map of the view.
     
     */
    
    func setMap(lat : Double, long : Double){
        
        var camera      : GMSCameraPosition?
        var boundaries  : CGRect?
        
        camera      = GMSCameraPosition.cameraWithLatitude(lat, longitude: long, zoom: 16)
        boundaries  = CGRectMake(0,64,400,606)
        
        mapView                     = GMSMapView.mapWithFrame(boundaries!, camera: camera!)
        mapView.myLocationEnabled   = true
        
        self.view.addSubview(mapView)
        
        setMarker()
    }
    
    /**
     
     Used to set the marker on the map.
     
     */
    
    func setMarker(){
        
        let util = Utility()
        
        for location in locationList{
            var marker : GMSMarker?
            var locationCoordinates : CLLocationCoordinate2D?
            
            marker              = GMSMarker()
            locationCoordinates = CLLocationCoordinate2DMake(location.lat,
                                                             location.long)
            marker!.position    = locationCoordinates!
            marker!.title       = location.name
            marker!.snippet     = location.vicinity
            //marker!.icon        = UIImage(named: "clinic")
            
            marker!.icon = util.properIcon(location)
            
            marker!.map         = mapView
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "goBack") {
        
            let yourNextViewController = (segue.destinationViewController as! FinalIteration2ViewController)
            
            yourNextViewController.lat          = lat!
            yourNextViewController.long         = long!
            yourNextViewController.locationList = locationList
            yourNextViewController.filter       = filter
            yourNextViewController.setUpLocation()
            
        } else if(segue.identifier == "putAddress"){
            let yourNextViewController = (segue.destinationViewController as! FinalIteration2AddressViewController)
            
            yourNextViewController.lat          = lat!
            yourNextViewController.long         = long!
            yourNextViewController.locationList = locationList
        }
        
    }
    
}

