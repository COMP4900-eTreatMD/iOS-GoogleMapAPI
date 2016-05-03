//
//  CustomLocationManager.swift
//  GoogleMapsAPI-4900
//
//  Created by Jan Ycasas on 2016-05-02.
//  Copyright © 2016 Jan Ycasas. All rights reserved.
//

import Foundation
import CoreLocation


class CustomLocationManager : CLLocationManager{
    

    func customUpdateLocation(completion: (lat: Double, long : Double) -> Void) {
        super.startUpdatingLocation()
        print("overrided")
        
        
        
    }
    
    
    
    
    
}

