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
    
    //var long            : Double = -123.15777489999999
    //var lat             : Double = 49.1353796
    
    var long            : Double!
    var lat             : Double!
    
    var count = 0
    
    var mapView : GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    
        self.setMap(self.lat, long: self.long)
        
        print("final view loaded")
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK: -- MapView
    
    func setMap(lat : Double, long : Double){
        
        let camera = GMSCameraPosition.cameraWithLatitude(lat,
                                                          longitude: long, zoom: 10)
        mapView = GMSMapView.mapWithFrame(CGRectMake(0,64,400,400), camera: camera)
        mapView.myLocationEnabled = true
        
        print("set map")
        
        self.view.addSubview(mapView)
    }
    
    func setMarker(index : NSIndexPath){
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(locationList[index.row].lat, locationList[index.row].long)
        marker.title = locationList[index.row].name
        marker.snippet = locationList[index.row].vicinity
        marker.map = mapView
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "goToFilter") {
            
            let yourNextViewController = (segue.destinationViewController as! FilterViewController)
            
            
            yourNextViewController.lat  = lat
            yourNextViewController.long = long
            
        }
    }
    
    func initialSetUp(){
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), {
            // Do something...
            let util = Utility()
            print("utility")
            util.doHttpRequest(self.lat,long: self.long,radius: "1000", type: "doctor") {
                choiceList in
                print("done")
                self.locationList += choiceList
                self.tableView.reloadData()
            }
            
            util.doHttpRequest(self.lat,long: self.long,radius: "0", type: "hospital") {
                choiceList in
                print("done")
                self.locationList += choiceList
                self.tableView.reloadData()
            }
            
            util.doHttpRequest(self.lat,long: self.long,radius: "0", type: "pharmacy") {
                choiceList in
                print("done")
                self.locationList += choiceList
                self.tableView.reloadData()
            }
            
        });
    }
    
    func filteredOutput(){
        self.tableView.reloadData()
    }
    
}

