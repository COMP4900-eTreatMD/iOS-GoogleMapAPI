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
    var rating          : Int!
    var currentlyOpen   : String!
    var type            : String!
    var recommended     : Bool!

    init(placeId : String, name : String, lat : Double, long : Double, vicinity : String, rating : Int, currentlyOpen : String, type: String, recommended : Bool){
        
        self.placeId            = placeId
        self.name               = name
        self.lat                = lat
        self.long               = long
        self.vicinity           = vicinity
        self.rating             = rating
        self.currentlyOpen      = currentlyOpen
        self.type               = type
        self.recommended        = recommended

    }
    
}