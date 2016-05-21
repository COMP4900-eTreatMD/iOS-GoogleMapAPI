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

public class Utility {
    
    /**
     
        Returns a string that capatilizes the first character in the string.
     
     */
    
    func formatString(type : String) -> String{
        
        var returnType : String!
        
        returnType = String(type.characters.first!).capitalizedString + String(type.characters.dropFirst())
        
        return returnType
    }
    
    /**
        
        Returns a proper image that matches the location.
     
     */
    
    func properIcon(location : Location) -> UIImage{
     
        let pharmacy = UIImage(named : "pharmacy")
        let hospital = UIImage(named : "hospital")
        let physio   = UIImage(named : "physiotherapist")
        let doctor   = UIImage(named : "doctor")
        
        let pharmacySpons = UIImage(named : "pharmacySponsored")
        let hospitalSpons = UIImage(named : "hospitalSponsored")
        let physioSpons   = UIImage(named : "physiotherapistSponsored")
        let doctorSpons   = UIImage(named : "doctorSponsored")
        
        let typeLowerCase = location.type.lowercaseString
        
        if((location.recommended) == true){
            if(typeLowerCase == "hospital"){
                return hospitalSpons!
            } else if(typeLowerCase == "pharmacy"){
                return pharmacySpons!
            } else if(typeLowerCase == "physiotherapist"){
                return physioSpons!
            } else {
                return doctorSpons!
            }
        } else {
            if(typeLowerCase == "hospital"){
                return hospital!
            } else if(typeLowerCase == "pharmacy"){
                return pharmacy!
            } else if(typeLowerCase == "physiotherapist"){
                return physio!
            } else {
                return doctor!
            }
        }
        
    }
    
    /**
     
     Does an HTTP request to the API that we created. Uses the data that we got from the API and uses a closure
     to return an array that contains a list of locations that fits the type that was given.
     
     */
    
    func getRecommended(type : String,completion:(locationList:Array<Location>)->Void){
        
        var locationList    : Array<Location>    = Array<Location>()
        var finalType                            = type.lowercaseString
        
        // MADE A TYPO ON THE API
        if(finalType == "physiotherapist"){
            finalType = "physiotherapish"
        }
        
        Alamofire.request(.GET, "http://etreatmdapi.rickychen.me/api/"+type+"Lists")
            .responseJSON { response in
                
                switch response.result {
                case .Success:
                    if let responseJSON = response.result.value {
                        let mainJSON    = JSON(responseJSON)
                        
                        for (_, subJson) in mainJSON {
                            var placeId         : String    = ""
                            var name            : String    = ""
                            var lat             : Double    = 0.0
                            var long            : Double    = 0.0
                            var vicinity        : String    = ""
                            var type            : String    = ""
                            var phoneNumber     : String    = ""
                            var priority        : Int       = 0
                            
                            name        = subJson["name"].string!
                            lat         = subJson["lat"].double!
                            long        = subJson["longtitude"].double!
                            type        = subJson["category"].string!
                            vicinity    = subJson["address"].string!
                            placeId     = String(subJson[finalType + "PlaceId"].int!)
                            phoneNumber = subJson["phoneNumber"].string!
                            priority    = subJson["priority"].int!
                            
                            let location = Location(placeId : placeId, name : name, lat : lat, long: long, vicinity: vicinity, type: type, recommended: true, priority: priority,
                                phoneNumber: phoneNumber)
                            
                            locationList.append(location)
                        }
                        completion(locationList: locationList)
                    }
                    
                case .Failure(let error):
                    print(error)
                }
        }
    }
    
    /**
     
        Uses Alamofire to do the REST call. uses the category and radius to find places that
        the user wants. When the REST call is finish returns a list of locations that matches 
        the request of the user.
     
     */

    func getAllLocations(lat : Double, long : Double, name : String , type : String,
                         completion: (locationList: Array<Location>) -> Void) {

        var locationList : Array<Location>?
        var coord        : String?
        
        locationList = Array<Location>()
        coord        = String(lat) + "," + String(long)
        
        Alamofire.request(.GET, "https://maps.googleapis.com/maps/api/place/nearbysearch/json", parameters: [   "location"  :   coord!,
                            "types"     :   type,
                            "name"      :   name,
                            "rankby"    : "distance",
                            "key"       :   "AIzaSyBPqY-Cb5udIHNCIwwWQi3qmdtXMQbCCGw",
            ]).responseJSON { response in
                
                
                //print(response.request)
                
                //AIzaSyBWQyWLKeu_VGL2RgXeyM-_TgBSTDP9-Fs
                //AIzaSyBPqY-Cb5udIHNCIwwWQi3qmdtXMQbCCGw
                
                
                switch response.result {
                    case .Success:
                        if let responseJSON = response.result.value {
                            
                            let mainJSON    = JSON(responseJSON)
                            
                            for (_, subJson) in mainJSON["results"] {
                                
                                var placeId         : String    = ""
                                var name            : String    = ""
                                var lat             : Double    = 0.0
                                var long            : Double    = 0.0
                                var vicinity        : String    = ""
                                var type            : String    = ""
                                
                                
                                if let resultPlaceId = subJson["place_id"].string {
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
                                
                                let location = Location(placeId : placeId, name : name, lat : lat, long: long, vicinity: vicinity, type: type, recommended: false, priority: 0, phoneNumber: "")
                                
                                locationList!.append(location)
                                
                            }
                            completion(locationList: locationList!)
                    }

                    case .Failure(let error):
                        print(error)
                }
        }
    }
    
    /**
     
     Does an HTTP request to Google Maps API to get a list of details of the location. Returns 
     the phone number of the location.
     
     */
    
    func getLocationDetails(location : Location, completion: (phoneNumber: String) -> Void) {
        
        Alamofire.request(.GET, "https://maps.googleapis.com/maps/api/place/details/json"
            , parameters: [ "placeid"  :   location.placeId,
                            "key"      :   "AIzaSyBPqY-Cb5udIHNCIwwWQi3qmdtXMQbCCGw",
            ]).responseJSON { response in
                
                switch response.result {
                case .Success:
                    if let responseJSON = response.result.value {
                        let mainJSON    = JSON(responseJSON)
                        
                        var phoneNumber : String = ""
                        
                        if let resultPhoneNumber = mainJSON["result"]["formatted_phone_number"].string {
                            phoneNumber = resultPhoneNumber
                        }
                        
                        completion(phoneNumber: phoneNumber)
                    }
                    
                case .Failure(let error):
                    print(error)
                }
        }
    }
    
    /**
     
     Does GeoCoding. It takes an address and returns latitude and longitude of the location.
     
     */
    
    func doGeoCoding(address : String, completion: (lat: Double, long : Double) -> Void) {
        
        Alamofire.request(.GET, "https://maps.googleapis.com/maps/api/geocode/json"
            , parameters: [ "address"   :   address,
                            "key"       :   "AIzaSyBPqY-Cb5udIHNCIwwWQi3qmdtXMQbCCGw",
            ]).responseJSON { response in
                
                print(response.request)
                
                switch response.result {
                case .Success:
                    if let responseJSON = response.result.value {
                        let mainJSON    = JSON(responseJSON)
                        var lat  : Double = 0.0
                        var long : Double = 0.0
                        
                        for (_, subJson) in mainJSON["results"] {
                            let geometryJSON    = subJson["geometry"]
                            let locationJSON    = geometryJSON["location"]
                            lat = locationJSON["lat"].double!
                            long = locationJSON["lng"].double!
                            
                        }
                        completion(lat: lat, long : long)
                    }
                    
                case .Failure(let error):
                    print(error)
                }
        }
    }
    
    /**
     
     Sorts the location list by priority.
     
     */
    
    func sort(locationList : Array<Location>) -> Array<Location> {
        var resultLocationList = locationList
        
        resultLocationList.sortInPlace(sortPriority)
        
        return resultLocationList
    }
    
    /**
     
     Comparison algoirthm for the sorting function.
     
     */
    
    func sortPriority(left : Location, right : Location) -> Bool {
        return left.priority < right.priority
    }
    
}