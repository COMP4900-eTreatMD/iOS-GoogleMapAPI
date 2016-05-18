//
//  AppDelegate.swift
//  GoogleMapsAPI-4900
//
//  Created by Jan Ycasas on 2016-04-29.
//  Copyright © 2016 Jan Ycasas. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

var reachability: Reachability?
let kREACHABLE = "Reachable"
let kNOTREACHABLE = "NotReachable"
var reachabilityStatus: String?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var internetReach: Reachability?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.reachabilityChanged(_:)), name: kReachabilityChangedNotification, object: nil)
      
        GMSServices.provideAPIKey("AIzaSyBPqY-Cb5udIHNCIwwWQi3qmdtXMQbCCGw")
       
        internetReach = Reachability.reachabilityForInternetConnection()
        internetReach?.startNotifier()
        if internetReach != nil{
            self.statusChangeWithReachability(internetReach!)
        }
        
        //GMSServices.provideAPIKey("AIzaSyDUVbyFfzQdOPLjfxnFhLmMQDev4I_upII")
        
        //AIzaSyBWQyWLKeu_VGL2RgXeyM-_TgBSTDP9-Fs
        
        return true
    }
    
    func reachabilityChanged(notification: NSNotification){
        reachability = notification.object as? Reachability
        self.statusChangeWithReachability(reachability!)
    }
    
    func statusChangeWithReachability(currentStatus: Reachability){
        let networkStatus: NetworkStatus = currentStatus.currentReachabilityStatus()
        if(networkStatus.rawValue == NotReachable.rawValue){
            reachabilityStatus = kNOTREACHABLE
        }else if(networkStatus.rawValue == ReachableViaWiFi.rawValue || networkStatus.rawValue == ReachableViaWWAN.rawValue){
            reachabilityStatus = kREACHABLE
        }
        NSNotificationCenter.defaultCenter().postNotificationName("ReachStatusChanged", object: nil)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kReachabilityChangedNotification, object: nil)
    }


}

