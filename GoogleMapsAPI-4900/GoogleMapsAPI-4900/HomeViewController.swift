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

class HomeViewController: UIViewController {
    
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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

