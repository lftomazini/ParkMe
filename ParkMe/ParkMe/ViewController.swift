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
    let BU_Latitude = 40.954582
    let BU_Longitude = -76.883322
    var BRKILot = Lots(filename: "BRKI")
    var ACWSLot = Lots(filename: "ACWS")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.showsUserLocation = false;
        self.mapView.delegate = self;
        
        
        // Add pins for parking lots
        mapView.addAnnotation(Annotation(coordinate: CLLocationCoordinate2D(latitude: BRKILot.midCoordinate.latitude, longitude: BRKILot.midCoordinate.longitude), title: "BreakIron", subtitle: "Density: Mild"));
        mapView.addAnnotation(Annotation(coordinate: CLLocationCoordinate2D(latitude: ACWSLot.midCoordinate.latitude, longitude: ACWSLot.midCoordinate.longitude), title: "Academic West", subtitle: "Density: High"));
        mapView.addAnnotation(Annotation(coordinate: CLLocationCoordinate2D(latitude: 40.957863, longitude: -76.885560), title: "Smith", subtitle: "Density: High"));
        
        
        // user activated automatic authorization info mode
        let status = CLLocationManager.authorizationStatus()
        if status == .NotDetermined || status == .Denied || status == .AuthorizedWhenInUse {
            // present an alert indicating location authorization required
            // and offer to take the user to Settings for the app via
            // UIApplication -openUrl: and UIApplicationOpenSettingsURLString
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        let initialLocation = CLLocation(latitude: BU_Latitude, longitude: BU_Longitude);
        centerMapOnLocation(initialLocation);

        addBoundary(BRKILot);
        addBoundary(ACWSLot);
        
    }
    
    let regionRadius: CLLocationDistance = 800
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 1.5, regionRadius * 1.5)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func addBoundary(lot: Lots) {
        let polygon = MKPolygon(coordinates: &lot.boundary, count: lot.boundaryPointsCount)
        mapView.addOverlay(polygon)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
            let polygonView = MKPolygonRenderer(overlay: overlay)
            polygonView.strokeColor = UIColor.blueColor()
        
            return polygonView
    }
    
}
