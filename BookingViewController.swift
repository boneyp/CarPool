//
//  BookingViewController.swift
//  CarPool
//
//  Created by boney_p on 16/06/15.
//  Copyright (c) 2015 boney_p. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AddressBook

class BookingViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up our location manager properties
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.startUpdatingLocation()
        locationManager?.delegate = self
        
        // set up our mapView Properties
        mapView.delegate = self

        //direction request 
        
        
    }
    
    func provideDirections(){
        let destination = "Godsgatan, Norrköping, Sweden"
        CLGeocoder().geocodeAddressString(destination,
            completionHandler: {(placemarks: [AnyObject]!, error: NSError!) in
                
                if error != nil{
                    /* Handle the error here perhaps by displaying an alert */
                } else {
                    let request = MKDirectionsRequest()
                    request.setSource(MKMapItem.mapItemForCurrentLocation())
                    
                    /* Convert the CoreLocation destination
                    placemark to a MapKit placemark */
                    let placemark = placemarks[0] as CLPlacemark
                    let destinationCoordinates =
                    placemark.location.coordinate
                    /* Get the placemark of the destination address */
                    let destination = MKPlacemark(coordinate:
                        destinationCoordinates,
                        addressDictionary: nil)
                    
                    request.setDestination(MKMapItem(placemark: destination))
                    
                    /* Set the transportation method to automobile */
                    request.transportType = .Automobile
                    
                    /* Get the directions */
                    let directions = MKDirections(request: request)
                    directions.calculateDirectionsWithCompletionHandler{
                        (response: MKDirectionsResponse!, error: NSError!) in
                        
                        /* You can manually parse the response, but in
                        here we will take a shortcut and use the Maps app
                        to display our source and
                        destination. We didn't have to make this API call at all,
                        as we already had the map items before, but this is to
                        demonstrate that the directions response contains more
                        information than just the source and the destination. */
                        
                        /* Display the directions on the Maps app */
                        let launchOptions = [
                            MKLaunchOptionsDirectionsModeKey:
                        MKLaunchOptionsDirectionsModeDriving]
                        
                        MKMapItem.openMapsWithItems(
                            [response.source, response.destination],
                            launchOptions: launchOptions)
                    }
                    
                }
                
        })
    }
    
    
    
    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus){
            
            print("The authorization status of location " +
                "services is changed to: ")
            
            switch CLLocationManager.authorizationStatus(){
            case .Denied:
                println("Denied")
            case .NotDetermined:
                println("Not determined")
            case .Restricted:
                println("Restricted")
            default:
                println("Authorized")
                provideDirections()
            }
            
    }
    
    func displayAlertWithTitle(title: String, message: String){
        let controller = UIAlertController(title: title,
            message: message,
            preferredStyle: .Alert)
        
        controller.addAction(UIAlertAction(title: "OK",
            style: .Default,
            handler: nil))
        
        presentViewController(controller, animated: true, completion: nil)
        
    }
    
    /* Add the pin to the map and center the map around the pin */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /* Are location services available on this device? */
        if CLLocationManager.locationServicesEnabled(){
            
            /* Do we have authorization to access location services? */
            switch CLLocationManager.authorizationStatus(){
            case .Denied:
                /* No */
                displayAlertWithTitle("Not Determined",
                    message: "Location services are not allowed for this app")
            case .NotDetermined:
                /* We don't know yet, we have to ask */
                locationManager = CLLocationManager()
                if let manager = self.locationManager{
                    manager.delegate = self
                    manager.requestWhenInUseAuthorization()
                }
            case .Restricted:
                /* Restrictions have been applied, we have no access
                to location services */
                displayAlertWithTitle("Restricted",
                    message: "Location services are not allowed for this app")
            default:
                provideDirections()
            }
            
            
        } else {
            /* Location services are not enabled.
            Take appropriate action: for instance, prompt the
            user to enable the location services */
            println("Location services are not enabled")
        }
    }
    
//    func showRoute(response: MKDirectionsResponse) {
//        
//        for route in response.routes as [MKRoute] {
//            
//            mapView.addOverlay(route.polyline,
//                level: MKOverlayLevel.AboveRoads)
//            
//            for step in route.steps {
//                println(step.instructions)
//            }
//        }
//        let userLocation = mapView.userLocation
//        let region = MKCoordinateRegionMakeWithDistance(
//            userLocation.location.coordinate, 2000, 2000)
//        
//        mapView.setRegion(region, animated: true)
//    }
//    
//    func mapView(mapView: MKMapView!, rendererForOverlay
//        overlay: MKOverlay!) -> MKOverlayRenderer! {
//            let renderer = MKPolylineRenderer(overlay: overlay)
//            
//            renderer.strokeColor = UIColor.blueColor()
//            renderer.lineWidth = 5.0
//            return renderer
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // Location manager delegate
//    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//        let location = locations.last as CLLocation
//        
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
//        
//        
//        self.mapView.setRegion(region, animated: true)
//        
//        
//        // Add an annotation on Map View
//        var point: MKPointAnnotation! = MKPointAnnotation()
//        
//        point.coordinate = location.coordinate
//        point.title = "Current Location"
//        
//        self.mapView.addAnnotation(point)
//        
//        //stop updating location to save battery life
//        //locationManager.stopUpdatingLocation()
//    }
    
//    //Location manager delegate
//    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
//        mapView.centerCoordinate = userLocation.location.coordinate
//    }
//    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
