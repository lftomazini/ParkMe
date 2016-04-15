//
//  UserMotion.swift
//  ParkMe
//
//  Created by AC on 4/13/16.
//  Copyright © 2016 AC. All rights reserved.
//

import Foundation
import CoreMotion

let motion = CMMotionActivity()

func isDriving() -> Bool {
    return motion.automotive
}
