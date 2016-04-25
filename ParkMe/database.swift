//
//  database.swift
//  ParkMe
//
//  Created by AC on 4/12/16.
//  Copyright © 2016 AC. All rights reserved.
//

import Firebase
import CoreLocation

/* Get user's unique ID */

let UUID = UIDevice.currentDevice().identifierForVendor!.UUIDString

/* Database address */

let dbRef = Firebase(url: "https://parkmebucknell.firebaseio.com") // Root path for Firebase

let userID = dbRef.childByAppendingPath(UUID) // User's unique data entry

let userLat = userID.childByAppendingPath("Latitude") // Path for latitude

let userLong = userID.childByAppendingPath("Longitude") // Path for longitude

func updateUserLoc(location: CLLocation) {
    
    userLat.setValue(location.coordinate.latitude) // Updates latitude
    userLong.setValue(location.coordinate.longitude) // Updates longitude
    
}
