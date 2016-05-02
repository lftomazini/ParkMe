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

class ViewController: UIViewController, CLLocationManagerDelegate, UIPageViewControllerDataSource{
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var reportButton: UIButton!
    
    let locationManager =  CLLocationManager()
    /* Central coordinate of Bucknell */
    let BU_Latitude = 40.954582
    let BU_Longitude = -76.883322
    var pageViewController: UIPageViewController
    var pageImages: NSArray!
    
    
    /* Initializing Parking Lots instances */
    var BRKILot = Lots(filename: "BRKI", name: "BRKI", density: "HIGH", type: lotsDecalTypes.Student, imageName: "Breakiron.png")
    var ACWSLot = Lots(filename: "ACWS", name:"ACWS", density: "MILD", type: lotsDecalTypes.Student, imageName: "AcademicWest.png")
    var SMLot = Lots(filename: "Smith", name:"Smith", density: "LOW", type: lotsDecalTypes.Student, imageName: "Smith.png")
    var MCDLot = Lots(filename: "MCD", name:"McDonell", density: "LOW", type: lotsDecalTypes.Student, imageName: "McDonnell.png")
    var SCALot = Lots(filename: "SCA", name: "South Campus Apartments", density: "LOW", type: lotsDecalTypes.Student, imageName: "South Campus Apartment.png")
    var TraxLot = Lots(filename: "Trax", name: "Trax", density: "HIGH", type: lotsDecalTypes.Student, imageName: "Trax.png")
    var CornerHouseLot = Lots(filename: "CornerHouse", name: "Corner House", density: "HIGH", type: lotsDecalTypes.Student, imageName: "cornerhouse.png")
    
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
        
        self.pageImages = NSArray(object: "info1","info2")
        
        
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
        mapView.addAnnotation(Annotation(lot: CornerHouseLot)) // Corner House
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
        addBoundary(CornerHouseLot)
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
    
    func viewControllerAtIndex(index: Int) -> ContentViewController{
        
        if ((self.pageImages.count == 0) || (index > self.pageImages.count)){
            return ContentViewController()
        }
        
        let vc: ContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("") as! ContentViewController
        
        vc.imageFile = self.pageImages[index] as! String
        vc.pageIndex = index
        return vc
    }
    
    // MARK: - PageViewController Data Source 
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        
        if(index == 0 || index == NSNotFound){
            return nil
        }
        index -= 1
        let toReturn = self.viewControllerAtIndex(index)
        return toReturn
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        
        if(index == NSNotFound){
            return nil
        }
        index += 1
        if (index == self.pageImages.count) {
            return nil
        }
        return self.viewControllerAtIndex(index)
        
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageImages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
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
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "parkingLots"
        
        if let annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) {
            annotationView.annotation = annotation
            return annotationView
        } else {
            let annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:reuseId)
            annotationView.enabled = true
            annotationView.canShowCallout = true
            
            let reportBtnImg = UIImage(named: "Error-48") as UIImage?
            let reportBtn = UIButton(type: UIButtonType.Custom) as UIButton
            reportBtn.frame = CGRectMake(0, 0, 32, 32)
            reportBtn.setImage(reportBtnImg, forState: .Normal)
            annotationView.rightCalloutAccessoryView = reportBtn
            return annotationView
        }
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            performSegueWithIdentifier("reportView", sender: view)
        }
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "reportView") {
            let destViewController = segue.destinationViewController as! reportViewController
            destViewController.annotation = ((sender as! MKAnnotationView).annotation) as? Annotation
        }
    }
    
}
