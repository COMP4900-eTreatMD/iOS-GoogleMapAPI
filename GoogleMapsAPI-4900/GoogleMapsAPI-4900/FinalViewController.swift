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
import GoogleMaps
import MBProgressHUD

class FinalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
   
    @IBOutlet weak var tableView: UITableView!
    
    
    var names = ["Vancouver Genral Hospital","Burnaby General Hospital","Jan's Clinic","penis"]
    var address = ["588 Broadway, Vancouver, B.C., Canada","4994 Kingsway, B.C., Burnaby, Canada","3990 Dream Way, Burnaby, B.C., Canada","penis"]
    
    let util            : Utility            = Utility()
    var locationList    : Array<Location>    = Array<Location>()
    
    var long            : Double = -123.00098139716535
    var lat             : Double = 49.249433253388375
    
    var mapView : GMSMapView!
    
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
        
        //var hud: MBProgressHUD = MBProgressHUD()

        
        //let progressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            // Do something...
            let util = Utility()
            print("utility")
            util.doHttpRequest(self.lat,long: self.long) {
                choiceList in
                print(choiceList.count)
                self.locationList = choiceList
                /*
                for element in choiceList {
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
            dispatch_async(dispatch_get_main_queue(), {
                print("async tableview")
                //progressHUD.hide(true)
                //self.setMap(self.lat, long: self.long)
            });
            /*
            dispatch_async(dispatch_get_main_queue(), {
                print("async map")
                progressHUD.hide(true)
                self.setMap(self.lat, long: self.long)
            });
             */
        });
    
        self.setMap(self.lat, long: self.long)
        
    }
    
    override func viewDidAppear(animated: Bool) {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK: --Location (CLLocationManagerDelagate) + Location functions
    
    /*
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
    */
    
    func setMap(lat : Double, long : Double){
        
        let camera = GMSCameraPosition.cameraWithLatitude(lat,
                                                          longitude: long, zoom: 10)
        mapView = GMSMapView.mapWithFrame(CGRectMake(0,64,400,400), camera: camera)
        mapView.myLocationEnabled = true
        
        //self.view.addSubview(mapView)
        /*
         let marker = GMSMarker()
         marker.position = CLLocationCoordinate2DMake(lat, long)
         marker.title = "Sydney"
         marker.snippet = "Australia"
         marker.map = mapView
         */
        print("set map")
        /*
        for element in locationList {
            print("element")
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(element.lat, element.long)
            marker.title = element.name
            marker.snippet = element.vicinity
            marker.map = mapView
        }
         */
    
        
        self.view.addSubview(mapView)
    }
    
    
    // MARK: -- TableView

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return locationList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        print("table view")
        print(locationList.count)
        
        
        setMarker(indexPath)
        
        var cell = self.tableView.dequeueReusableCellWithIdentifier("cell",forIndexPath: indexPath) as! CustomeCell
        
        
        cell.address.text = locationList[indexPath.row].vicinity
        cell.name.text = locationList[indexPath.row].name
        cell.availiability.text = locationList[indexPath.row].currentlyOpen
        
        return cell
    }
    
    func setMarker(index : NSIndexPath){
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(locationList[index.row].lat, locationList[index.row].long)
        marker.title = locationList[index.row].name
        marker.snippet = locationList[index.row].vicinity
        marker.map = mapView
    }
    
}

