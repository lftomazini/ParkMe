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

class ViewController: UIViewController, CLLocationManagerDelegate {
    

    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    /* Central coordinate of Bucknell */
    let BU_Latitude = 40.954582
    let BU_Longitude = -76.883322
    
    /* Initializing Parking Lots instances */
    var BRKILot = Lots(filename: "BRKI", name: "BRKI", density: "HIGH")
    var ACWSLot = Lots(filename: "ACWS", name:"ACWS", density: "MILD")
    var SMLot = Lots(filename: "Smith", name:"Smith", density: "LOW")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.showsUserLocation = false;
        self.mapView.delegate = self;
        
        addAnnotations();
        
        // user activated automatic authorization info mode
//        let status = CLLocationManager.authorizationStatus()
//        if status == .NotDetermined || status == .Denied || status == .AuthorizedWhenInUse {
//            // present an alert indicating location authorization required
//            // and offer to take the user to Settings for the app via
//            // UIApplication -openUrl: and UIApplicationOpenSettingsURLString
//            locationManager.requestAlwaysAuthorization()
//            locationManager.requestWhenInUseAuthorization()
//        }
        
        let initialLocation = CLLocation(latitude: BU_Latitude, longitude: BU_Longitude);
        centerMapOnLocation(initialLocation);

        addBoundary(BRKILot);
        addBoundary(ACWSLot);
        addBoundary(SMLot);
        
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
    
    func addAnnotations() {
        
        /* Add pins for parking lots
         */
        
        mapView.addAnnotation(Annotation(coordinate: CLLocationCoordinate2D(latitude: BRKILot.midCoordinate.latitude, longitude: BRKILot.midCoordinate.longitude), title: BRKILot.name, subtitle: "Density: \(BRKILot.density)")); // BRKI
        mapView.addAnnotation(Annotation(coordinate: CLLocationCoordinate2D(latitude: ACWSLot.midCoordinate.latitude, longitude: ACWSLot.midCoordinate.longitude), title: ACWSLot.name, subtitle: "Density: \(ACWSLot.density)")); // ACWS
        mapView.addAnnotation(Annotation(coordinate: CLLocationCoordinate2D(latitude: SMLot.midCoordinate.latitude, longitude: SMLot.midCoordinate.longitude), title: SMLot.name, subtitle: "Density: \(SMLot.density)")); // Smith
    }
    
    /* Circle parking lots and make polygons*/
    func addBoundary(lot: Lots) {
        let polygon = MKPolygon(coordinates: &lot.boundary, count: lot.boundaryPointsCount)
        polygon.title = lot.density
        mapView.addOverlay(polygon)
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
        return true;
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
    
}
