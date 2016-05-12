//
//  UtilityClass.swift
//  GoogleMapsAPI-4900
//
//  Created by Jan Ycasas on 2016-05-02.
//  Copyright © 2016 Jan Ycasas. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public class Utility{
    
    func formatString(type : String) -> String{
        
        var returnType : String!
        
        returnType = String(type.characters.first!).capitalizedString + String(type.characters.dropFirst())
        
        return returnType
    }
    
    func properIcon(location : Location) -> UIImage{
     
        let pharmacy = UIImage(named : "pharmacy")
        let hospital = UIImage(named : "hospital")
        let physio   = UIImage(named : "clinic")
        let doctor   = UIImage(named : "acupuncture")
        
        if(location.type == "hospital"){
            return hospital!
        } else if(location.type == "pharmacy"){
            return pharmacy!
        } else if(location.type == "physiotherapist"){
            return physio!
        } else {
            return doctor!
        }
        
    }
    
    /**
     
        Uses Alamofire to do the REST call. uses the category and radius to find places that
        the user wants. When the REST call is finish returns a list of locations that matches 
        the request of the user.
     
     */

    func doHttpRequest(lat : Double, long : Double, type : String, completion: (locationList: Array<Location>) -> Void) {

        var locationList : Array<Location>?
        var coord        : String?
        
        locationList = Array<Location>()
        coord        = String(lat) + "," + String(long)
        
        Alamofire.request(.GET, "https://maps.googleapis.com/maps/api/place/nearbysearch/json", parameters: [   "location"  :   coord!,
                            //"radius"    :   radius,
                            "types"     :   type,
                            //"name"      :   "harbour",
                            "rankby"    : "distance",
                            "key"       :   "AIzaSyBWQyWLKeu_VGL2RgXeyM-_TgBSTDP9-Fs",
            ]).responseJSON { response in
                switch response.result {
                    case .Success:
                        if let responseJSON = response.result.value {
                            
                            let mainJSON    = JSON(responseJSON)
                            
                            for (_, subJson) in mainJSON["results"] {
                                
                                var placeId         : Int       = 0
                                var name            : String    = ""
                                var lat             : Double    = 0.0
                                var long            : Double    = 0.0
                                var vicinity        : String    = ""
                                var rating          : Int       = 0
                                var currentlyOpen   : String    = "Unknown"
                                var type            : String    = ""
                                
                                
                                if let resultPlaceId = subJson["place_id"].int {
                                    placeId = resultPlaceId
                                }
                                
                                if let resultName = subJson["name"].string {
                                    name = resultName
                                }
                                
                                if let resultLat = subJson["geometry"]["location"]["lat"].double {
                                    lat = resultLat
                                }
                                
                                if let resultLong = subJson["geometry"]["location"]["lng"].double {
                                    long = resultLong
                                }
                                
                                if let resultVicinity = subJson["vicinity"].string {
                                    vicinity = resultVicinity
                                }
                                
                                if let resultRating = subJson["rating"].int {
                                    rating = resultRating
                                }
                                
                                if let resultCurrentlyOpen = subJson["opening_hours"]["open_now"].bool {
                                    if(resultCurrentlyOpen){
                                        currentlyOpen = "Open"
                                    } else {
                                        currentlyOpen = "Closed"
                                    }
                                }
                                
                                let resultTypes = subJson["types"]
                                
                                for (_, subJson) in resultTypes {
                                    let valueType = subJson.string
                                    if(valueType == "hospital"){
                                        type = "hospital"
                                        break
                                    } else if(valueType == "doctor"){
                                        type = "doctor"
                                        break
                                    } else if(valueType == "pharmacy"){
                                        type = "pharmacy"
                                        break
                                    } else if(valueType == "physiotherapist"){
                                        type = "physiotherapist"
                                        break
                                    }
                                }
                                
                                let location = Location(placeId : placeId, name : name, lat : lat, long: long, vicinity: vicinity, rating: rating, currentlyOpen: currentlyOpen, type: type)
                                
                                locationList!.append(location)
                                
                            }
                            completion(locationList: locationList!)
                    }

                    case .Failure(let error):
                        print(error)
                }
        }
    }
    
}