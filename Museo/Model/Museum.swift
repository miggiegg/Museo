//
//  Museum.swift
//  Museo
//
//  Created by Miguel Garcia on 12/10/18.
//  Copyright © 2018 Miguel Garcia Gonzalez. All rights reserved.
//

import MapKit
import Contacts
import SwiftyJSON

class Museum: NSObject, MKAnnotation {
    
    let title: String?
    let locationName: String?
    let coordinate: CLLocationCoordinate2D
    let webID: String?
    
    init(title: String, locationName: String?, coordinate: CLLocationCoordinate2D, webID: String?)
        
    {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        self.webID = webID
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    // JSON Attributes
    class func from(json: JSON) -> Museum? {
        var title: String
        if let unwrappedTitle = json["name"].string {
            title = unwrappedTitle
        } else {
            title = "No Title"
        }
        let locationName = json["location"]["address"].string
        let lat = json["location"]["lat"].doubleValue
        let lng = json["location"]["lng"].doubleValue
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let webID = json["webID"].string
        
        return Museum(title: title, locationName: locationName, coordinate: coordinate, webID: webID)
    }
    
}
