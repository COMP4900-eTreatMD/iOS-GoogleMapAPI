//
//  FilterViewController.swift
//  GoogleMapsAPI-4900
//
//  Created by Jan Ycasas on 2016-04-29.
//  Copyright © 2016 Jan Ycasas. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class FilterViewController: UIViewController {
    
    var long            : Double?
    var lat             : Double?
    
    @IBOutlet weak var categoryInput: UITextField!
    @IBOutlet weak var radiusInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func filterResult(sender: AnyObject) {
        print("filtering results")
        
        
    }
    
    @IBOutlet weak var filterResult: UIButton!
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "goToFinal") {
            
            
            print("doing segue")
            let yourNextViewController = (segue.destinationViewController as! FinalViewController)
            
            let util = Utility()
            util.doHttpRequest(self.lat!,long: self.long!,radius: radiusInput.text!, type: categoryInput.text!) {
                choiceList in
                print("done")
                print(choiceList.count)
                yourNextViewController.locationList = choiceList
                yourNextViewController.filteredOutput()
            }
            
            
            yourNextViewController.lat  = lat!
            yourNextViewController.long = long!
        }
    }
    
}

