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
    
    let util            : Utility            = Utility()
    var locationList    : Array<Location>    = Array<Location>()
    
    var long            : Double = -123.2324
    var lat             : Double = 42.235
    
    var mapView : GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self;
        tableView.dataSource = self;

        setMap(lat, long: long)
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK: -- MapView
    
    
    /** 
     
        Setting the initial map of the view.
     
     */
    
    func setMap(lat : Double, long : Double){
        
        var camera      : GMSCameraPosition?
        var boundaries  : CGRect?
        
        camera      = GMSCameraPosition.cameraWithLatitude(lat, longitude: long, zoom: 13)
        boundaries  = CGRectMake(0,64,400,400)
        

        mapView                     = GMSMapView.mapWithFrame(boundaries!, camera: camera!)
        mapView.myLocationEnabled   = true
        
        self.view.addSubview(mapView)
    }
    
    /**
     
        Used to set the marker on the map.
     
     */
    
    func setMarker(){
        
        for location in locationList{
            var marker : GMSMarker?
            var locationCoordinates : CLLocationCoordinate2D?
            
            marker              = GMSMarker()
            locationCoordinates = CLLocationCoordinate2DMake(location.lat,
                                                             location.long)
            marker!.position    = locationCoordinates!
            marker!.title       = location.name
            marker!.snippet     = location.vicinity
            marker!.icon        = UIImage(named: "clinic")
            marker!.map         = mapView
        }
    }
    
    // MARK: -- TableView

    /**
        
        Used to figure out how much elements there are in the locationlist.
     
     */
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationList.count
    }
    
    /**
        
        Called when trying to diplay the cell.
     
     */
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : CustomeCell?
        
        cell = self.tableView.dequeueReusableCellWithIdentifier("cell",forIndexPath: indexPath)
            as? CustomeCell
        
        cell!.address.text          = locationList[indexPath.row].vicinity
        cell!.name.text             = locationList[indexPath.row].name
        cell!.availiability.text    = locationList[indexPath.row].currentlyOpen
 
        return cell!
    }
    
    /** 
     
        Called when the table view is trying to display the cell. 
        It alternates between grey and white.
     
     */
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row % 2 == 0 {
            
            cell.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0) // very light gray
            
        } else {
            
            cell.backgroundColor = UIColor.whiteColor()
            
        }
    }

    /** 
     
        Passes variables (Lat, Long)to FilterViewController.
     
     */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "goToFilter") {
            
            var yourNextViewController : FilterViewController?
            
            yourNextViewController = (segue.destinationViewController as! FilterViewController)
            
            yourNextViewController!.lat  = lat
            yourNextViewController!.long = long
            
       }
    }
    
    
    /**
     
        Does a REST call with Google Places API to search for Doctors, Hospitals, Pharmacy.
     
     */
    func initialSetUp(){
        
        let util : Utility?
        
        util = Utility()
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), {
            // Do something...
            self.util.doHttpRequest(self.lat,long: self.long,
                                    type: "doctor|hospital|pharmacy|physiotherapist") {
                                        choiceList in
                
                self.locationList += choiceList
                self.tableView.reloadData()
                self.setMarker()
            }
            /*
            self.util.doHttpRequest(self.lat,long: self.long,radius: "10000", type: "hospital") {
                choiceList in

                self.locationList += choiceList
                self.tableView.reloadData()
            }
            
            self.util.doHttpRequest(self.lat,long: self.long,radius: "10000", type: "pharmacy") {
                choiceList in
                
                self.locationList += choiceList
                self.tableView.reloadData()
            }
             */
        });
    }
    
    /**
     
        Used to reload the table view.
     
     */
    func tableViewReloaded(){
        self.tableView.reloadData()
    }
    
}

