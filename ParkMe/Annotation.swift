//
//  Annotation.swift
//  ParkMe
//
//  Created by AC on 4/10/16.
//  Copyright © 2016 AC. All rights reserved.
//

import Foundation
import MapKit

class Annotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(lot: Lots) {
        self.coordinate = lot.midCoordinate
        self.title = lot.name
        self.subtitle = "Density: \(lot.density)"
    }
    
}