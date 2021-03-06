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
import BWWalkthrough

class ViewController: UIViewController, CLLocationManagerDelegate, BWWalkthroughViewControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var reportButton: UIButton!
    
    var needWalkthrough:Bool = true
    
    var walkthrough:BWWalkthroughViewController!
    
    let interactor = Interactor()
    
    let locationManager =  CLLocationManager()
    /* Central coordinate of Bucknell */
    let BU_Latitude = 40.954582
    let BU_Longitude = -76.883322
    
    /* Initializing Parking Lots instances */
    var BRKILot = Lots(filename: "BRKI", name: "BRKI", density: "HIGH", type: lotsDecalTypes.Student, imageName: "Breakiron.png")
    var ACWSLot = Lots(filename: "ACWS", name:"ACWS", density: "MILD", type: lotsDecalTypes.Student, imageName: "AcademicWest.png")
    var SMLot = Lots(filename: "Smith", name:"Smith", density: "LOW", type: lotsDecalTypes.Student, imageName: "Smith.png")
    var MCDLot = Lots(filename: "MCD", name:"McDonnell", density: "LOW", type: lotsDecalTypes.Student, imageName: "McDonnell.png")
    var SCALot = Lots(filename: "SCA", name: "South Campus Apartments", density: "LOW", type: lotsDecalTypes.Student, imageName: "South Campus Apartment.png")
    var TraxLot = Lots(filename: "Trax", name: "Trax", density: "HIGH", type: lotsDecalTypes.Student, imageName: "Trax.png")
    var CornerHouseLot = Lots(filename: "CornerHouse", name: "Corner House", density: "HIGH", type: lotsDecalTypes.Student, imageName: "cornerhouse.png")
    var gatewaysLot = Lots(filename: "Gateway", name: "Gateways", density: "LOW", type: lotsDecalTypes.Student, imageName: "Gateways")
    
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
        
        // creates 3d-touch shortcut for go to lot
        let smith = UIApplicationShortcutItem(type: "goToLotSmith", localizedTitle: "Smith", localizedSubtitle: "", icon: UIApplicationShortcutIcon(type: .Search), userInfo: nil)
        
        // adds shortcuts to homescreen
        UIApplication.sharedApplication().shortcutItems = [smith]

        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if needWalkthrough {
            self.presentWalkthrough()
        }
        UIApplication.sharedApplication().statusBarStyle = .LightContent
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
        
        mapView.addAnnotation(Annotation(lot: BRKILot)) // BRKI
        mapView.addAnnotation(Annotation(lot: ACWSLot)) // ACWS
        mapView.addAnnotation(Annotation(lot: SMLot)) // Smith
        mapView.addAnnotation(Annotation(lot: MCDLot)) // McDonell
        mapView.addAnnotation(Annotation(lot: SCALot)) // South Campus Apartments
        mapView.addAnnotation(Annotation(lot: TraxLot)) // Trax
        mapView.addAnnotation(Annotation(lot: CornerHouseLot)) // Corner House
        mapView.addAnnotation(Annotation(lot: gatewaysLot)) // Gateways
        
    }
    
    /* Circle parking lots and make polygons*/
    func addBoundary(lot: Lots) {
        let polygon = MKPolygon(coordinates: &lot.boundary, count: lot.boundaryPointsCount)
        polygon.title = lot.density
        mapView.addOverlay(polygon)
    }
    
    func populateBoundaries() {
        addBoundary(BRKILot)
        addBoundary(ACWSLot)
        addBoundary(SMLot)
        addBoundary(MCDLot)
        addBoundary(SCALot)
        addBoundary(TraxLot)
        addBoundary(CornerHouseLot)
        addBoundary(gatewaysLot)
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
        return false
    }
    
    
    func presentWalkthrough() {
        
        UIApplication.sharedApplication().statusBarHidden = true
        UIApplication.sharedApplication().statusBarStyle = .Default
        
        let stb = UIStoryboard(name: "Main", bundle: nil)

        walkthrough = stb.instantiateViewControllerWithIdentifier("walkthrough") as! BWWalkthroughViewController
        let page_one = stb.instantiateViewControllerWithIdentifier("page_1")
        let page_two = stb.instantiateViewControllerWithIdentifier("page_2")
        
        // Attach the pages to the master
        walkthrough.delegate = self
        walkthrough.addViewController(page_one)
        walkthrough.addViewController(page_two)
        
        self.presentViewController(walkthrough, animated: true) {
            ()->() in
            self.needWalkthrough = false
            UIApplication.sharedApplication().statusBarHidden = false

        }
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
            annotationView.pinTintColor = UIColorFromRGB(0x3AAAFE)
            
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
        } else if (segue.identifier == "tutorial") {
            let tutorialView = segue.destinationViewController as! tutorialScreenViewController
            tutorialView.transitioningDelegate = self
            tutorialView.interactor = interactor
        }
    }
    
    
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}

extension ViewController: UIViewControllerTransitioningDelegate {
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissAnimator()
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
}

extension ViewController {
    
    func walkthroughCloseButtonPressed() {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func walkthroughPageDidChange(pageNumber: Int) {
        if (self.walkthrough.numberOfPages - 1) == pageNumber{
            self.walkthrough.closeButton?.hidden = false
        }else{
            self.walkthrough.closeButton?.hidden = true
        }

    }
}
