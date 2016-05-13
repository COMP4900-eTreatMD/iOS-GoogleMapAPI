//
//  FinalIteration2DetailViewController.swift
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

class FinalIteration2DetailViewController: UIViewController{
    
    var long            : Double!
    var lat             : Double!
    
    var mapView         : GMSMapView!
    
    var locationList    : Array<Location>    = Array<Location>()
    var location        : Location!
    
    var util            : Utility = Utility()
    
    var filter          : String            = "All"
    
    @IBOutlet weak var locationTitle        : UINavigationItem!
    /*
    @IBOutlet weak var locationImage        : UIImageView!
    @IBOutlet weak var locationName         : UILabel!
    @IBOutlet weak var locationAddress      : UILabel!
    @IBOutlet weak var locationPhoneNumber: UIButton!
    @IBOutlet weak var locationCategory     : UILabel!
     */
    @IBOutlet weak var locationImage        : UIImageView!
    @IBOutlet weak var locationName         : UILabel!
    @IBOutlet weak var locationAddress      : UILabel!
    @IBOutlet weak var locationPhoneNumber  : UIButton!
    @IBOutlet weak var locationCategory     : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "ReachabilityStatusChanged", name: "ReachStatusChanged", object: nil)
        locationTitle.title     = location.name
        
        locationName.text       = location.name
        locationAddress.text    = location.vicinity
        locationCategory.text   = util.formatString(location.type)
        locationImage.image = util.properIcon(location)
        
        
        setMap(lat,long: long)
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
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func setMap(lat : Double, long : Double){
    
        var camera      : GMSCameraPosition?
        var boundaries  : CGRect?
        
        camera      = GMSCameraPosition.cameraWithLatitude(location.lat, longitude: location.long,
                                                           zoom: 16)
        boundaries  = CGRectMake(0,200,400,466)
        
        mapView                     = GMSMapView.mapWithFrame(boundaries!, camera: camera!)
        mapView.myLocationEnabled   = true
        
        self.view.addSubview(mapView)
        
        setMarker(location)
    }
    
    func setMarker(location : Location){
        
        let pharmacy = UIImage(named : "pharmacy")
        let hospital = UIImage(named : "hospital")
        let physio   = UIImage(named : "clinic")
        let doctor   = UIImage(named : "acupuncture")
        
       
        var marker : GMSMarker?
        var locationCoordinates : CLLocationCoordinate2D?
        
        marker              = GMSMarker()
        locationCoordinates = CLLocationCoordinate2DMake(location.lat,
                                                         location.long)
        marker!.position    = locationCoordinates!
        marker!.title       = location.name
        marker!.snippet     = location.vicinity
        
        if(location.type == "hospital"){
            marker!.icon = hospital
        } else if(location.type == "pharmacy"){
            marker!.icon = pharmacy
        } else if(location.type == "physiotherapist"){
            marker!.icon = physio
        } else if(location.type == "doctor"){
            marker!.icon = doctor
        }
        
        marker!.map = mapView
        
    }
    
    func initialSetUp(){
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), {
            // Do something...
            self.util.getLocationDetails(self.location) { phoneNumber in
                if(phoneNumber == ""){
                    self.locationPhoneNumber.setTitle("Phone Number Invalid", forState: .Normal)
                    self.locationPhoneNumber.enabled = false
                } else {
                    self.locationPhoneNumber.setTitle(phoneNumber, forState: .Normal)
                }
            }
        });
    }


    @IBAction func callPhone(sender: AnyObject) {
        let firstPart   = locationPhoneNumber.titleLabel!.text!.characters.prefix(5)
        let secondPart  = locationPhoneNumber.titleLabel!.text!.characters.suffix(8)
        
        let phoneNumber = "tel://" + String(firstPart) + "-" + String(secondPart)
        
        if let url = NSURL(string: phoneNumber) {
            UIApplication.sharedApplication().openURL(url)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let yourNextViewController = (segue.destinationViewController as! FinalIteration2ViewController)
        
        yourNextViewController.lat          = lat!
        yourNextViewController.long         = long!
        yourNextViewController.locationList = locationList
        yourNextViewController.filter       = filter
        
    }
    
}

