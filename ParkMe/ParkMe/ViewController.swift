//
//  ViewController.swift
//  MapTest
//
//  Created by AC on 2/29/16.
//  Copyright © 2016 AC. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var reportButton: UIButton!
        
    let locationManager =  CLLocationManager()
    /* Central coordinate of Bucknell */
    let BU_Latitude = 40.954582
    let BU_Longitude = -76.883322
    
    /* Initializing Parking Lots instances */
    var BRKILot = Lots(filename: "BRKI", name: "BRKI", density: "HIGH", type: lotsDecalTypes.Student)
    var ACWSLot = Lots(filename: "ACWS", name:"ACWS", density: "MILD", type: lotsDecalTypes.Student)
    var SMLot = Lots(filename: "Smith", name:"Smith", density: "LOW", type: lotsDecalTypes.Student)
    var MCDLot = Lots(filename: "MCD", name:"McDonell", density: "LOW", type: lotsDecalTypes.Student)
    var SCALot = Lots(filename: "SCA", name: "South Campus Apartments", density: "LOW", type: lotsDecalTypes.Student)
    var TraxLot = Lots(filename: "Trax", name: "Trax", density: "HIGH", type: lotsDecalTypes.Student)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.delegate = self
        // user activated automatic authorization info mode
        let status = CLLocationManager.authorizationStatus()
        if status == .NotDetermined || status == .Denied || status == .AuthorizedWhenInUse {
            // present an alert indicating location authorization required
            // and offer to take the user to Settings for the app via
            // UIApplication -openUrl: and UIApplicationOpenSettingsURLString
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.requestWhenInUseAuthorization()
        }

        self.mapView.delegate = self;

        let initialLocation = CLLocation(latitude: BU_Latitude, longitude: BU_Longitude);
        centerMapOnLocation(initialLocation);
        
        // Puts all parking lots pins on the map
        populateAnnotations();
        // Circle all parking lots
        populateBoundaries();
        
        self.locationManager.startUpdatingLocation()
        self.locationManager.startUpdatingHeading()
        
        // Dismiss key board after tapping on the screen to hide the keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    let regionRadius: CLLocationDistance = 650
    /* Center mapview to the center of Bucknell */
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 1.5, regionRadius * 1.5)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    /* Add pins for parking lots
     */
    func populateAnnotations() {
        
        mapView.addAnnotation(Annotation(lot: BRKILot)); // BRKI
        mapView.addAnnotation(Annotation(lot: ACWSLot)); // ACWS
        mapView.addAnnotation(Annotation(lot: SMLot)); // Smith
        mapView.addAnnotation(Annotation(lot: MCDLot)); // McDonell
        mapView.addAnnotation(Annotation(lot: SCALot)) // South Campus Apartments
        mapView.addAnnotation(Annotation(lot: TraxLot)) // Trax
    }
    
    /* Circle parking lots and make polygons*/
    func addBoundary(lot: Lots) {
        let polygon = MKPolygon(coordinates: &lot.boundary, count: lot.boundaryPointsCount)
        polygon.title = lot.density
        mapView.addOverlay(polygon)
    }
    
    func populateBoundaries() {
        addBoundary(BRKILot);
        addBoundary(ACWSLot);
        addBoundary(SMLot);
        addBoundary(MCDLot);
        addBoundary(SCALot);
        addBoundary(TraxLot);
    }
    
    /* Shake to recenter */
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            centerMapOnLocation(CLLocation(latitude: BU_Latitude, longitude: BU_Longitude))
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false;
    }
    
    
}

extension ViewController: MKMapViewDelegate {

    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
            let polygonView = MKPolygonRenderer(overlay: overlay)
            if (overlay.title! == "HIGH") {
                polygonView.fillColor = UIColor.redColor().colorWithAlphaComponent(0.4)
            } else if (overlay.title! == "MILD") {
                polygonView.fillColor = UIColor.orangeColor().colorWithAlphaComponent(0.4)
            } else if (overlay.title! == "LOW"){
                polygonView.fillColor = UIColor.greenColor().colorWithAlphaComponent(0.4)
            } else {
                polygonView.fillColor = UIColor.clearColor()
            }
            polygonView.strokeColor = UIColor.clearColor()
        
            polygonView.lineWidth = 2
        
            return polygonView
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        locationManager.stopUpdatingLocation()
        print(error)
    }
    
    
    /*
    Update database upon location update
    */
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let locationArray = locations as NSArray
        let lastLocation = locationArray.lastObject as! CLLocation
        updateUserLoc(lastLocation)
    }
    
}
