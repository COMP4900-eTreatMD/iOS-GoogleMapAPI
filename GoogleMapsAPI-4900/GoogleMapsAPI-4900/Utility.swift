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
    
    func getRecommended(type : String,completion:(locationList:Array<Location>)->Void){
        var locationList    : Array<Location>    = Array<Location>()
        
        if(type == "hospital"){
            let path = NSBundle.mainBundle().pathForResource("temp", ofType: "json")
            do {
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path!), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let jsonObj = JSON(data : data)
                
                print(jsonObj)
                
                for (_, subJson) in jsonObj["results"] {
                    
                    print(subJson)
                    
                    var placeId         : String    = ""
                    var name            : String    = ""
                    var lat             : Double    = 0.0
                    var long            : Double    = 0.0
                    var vicinity        : String    = ""
                    var type            : String    = ""
                    var phoneNumber     : String    = ""
                    
                    name        = subJson["name"].string!
                    lat         = Double(subJson["Lat"].string!)!
                    long        = Double(subJson["Long"].string!)!
                    type        = subJson["Category"].string!
                    vicinity    = subJson["Address"].string!
                    placeId     = subJson["placeId"].string!
                    phoneNumber = subJson["PhoneNumber"].string!
                    
                    let location = Location(placeId : placeId, name : name, lat : lat, long: long,    vicinity: vicinity, type: type, recommended: true, priority: 0,
                                            phoneNumber: phoneNumber)
                    
                    locationList.append(location)
                }
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        completion(locationList: locationList)

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
                            "key"       :   "AIzaSyBWQyWLKeu_VGL2RgXeyM-_TgBSTDP9-Fs",
            ]).responseJSON { response in
                
                
                //print(response.request)
                
                
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
    
    func getLocationDetails(location : Location, completion: (phoneNumber: String) -> Void) {
        
        Alamofire.request(.GET, "https://maps.googleapis.com/maps/api/place/details/json"
            , parameters: [ "placeid"  :   location.placeId,
                            "key"       :   "AIzaSyBWQyWLKeu_VGL2RgXeyM-_TgBSTDP9-Fs",
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
    

    
}