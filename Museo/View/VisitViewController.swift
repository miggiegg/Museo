//
//  VisitViewController.swift
//  Museo
//
//  Created by Miguel Garcia on 12/10/18.
//  Copyright © 2018 Miguel Garcia Gonzalez. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON
import Alamofire

class VisitViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var listButton: UIBarButtonItem!
    
    let JSON_URL = "https://raw.githubusercontent.com/miggiegg/JSON/gh-pages/MuseumJSON.json"
    
    var museums = [Museum]()
    var webID = ""
    
    func fetchData() {
        let filePath = URL(string: "\(JSON_URL)")
        var data: Data?
        do {
            data = try Data(contentsOf: filePath!, options: Data.ReadingOptions(rawValue: 0))
        } catch let error {
            data = nil
            print("Report Error: \(error.localizedDescription)")
        }
        
        if let jsonData = data {
            let json = try? JSON(data: jsonData)
            if let museumJSONs = json!["response"]["museums"].array {
                for museumJSON in museumJSONs {
                    if let museum = Museum.from(json: museumJSON) {
                        self.museums.append(museum)
                    }
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialLocation()
        checkLocationAuthorizationStatus()
        fetchData()
        mapView.addAnnotations(museums)
        mapView.delegate = self
    }
    
    // Centers Map on Seattle
    func initialLocation () {
        let initialLocation = CLLocation(latitude: 47.620143, longitude: -122.328568)
        let regionRadius: CLLocationDistance = 5000
        
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                      latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        
        centerMapOnLocation(location: initialLocation)
    }
    
    // Shows User Location
    let locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsBuildings = false
            mapView.showsPointsOfInterest = false
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    //MARK: - Segues
    
    // Passing webID to MuseumViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "MuseumDetails") {
            let destinationVC : MuseumViewController = segue.destination as! MuseumViewController
            destinationVC.museumID = self.webID
        }
        
    }
    
    // Shows ListViewController
    @IBAction func listButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "ListView", sender: self)
    }
    
}

//MARK: - Extension MKMapViewDelegate
extension VisitViewController: MKMapViewDelegate {
    
    // Data for Each Annotation (Marker/Pin)
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Museum else { return nil }
        
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    // Accessory Button Pushing MuseumViewController
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let annotation = view.annotation as! Museum
            let websiteID = annotation.webID!
            self.webID = websiteID
            // Shows MuseumViewController
            performSegue(withIdentifier: "MuseumDetails", sender: self)
        }
        
    }
    
    
}
