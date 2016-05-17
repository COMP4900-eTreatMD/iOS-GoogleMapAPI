//
//  Location.swift
//  GoogleMapsAPI-4900
//
//  Created by Jan Ycasas on 2016-05-02.
//  Copyright © 2016 Jan Ycasas. All rights reserved.
//

import Foundation

class Location{
    
    var placeId         : String!
    var name            : String!
    var lat             : Double!
    var long            : Double!
    var vicinity        : String!
    var type            : String!
    var recommended     : Bool!
    var priority        : Int!

    init(placeId : String, name : String, lat : Double, long : Double, vicinity : String, type: String, recommended : Bool, priority : Int){
        
        self.placeId            = placeId
        self.name               = name
        self.lat                = lat
        self.long               = long
        self.vicinity           = vicinity
        self.type               = type
        self.recommended        = recommended
        self.priority           = priority

    }
    
}