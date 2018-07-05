//
//  Location.swift
//  LocationFinder
//
//  Created by karthick on 7/4/18.
//  Copyright © 2018 karthick. All rights reserved.
//

import Foundation
import MapKit
import SwiftyJSON

protocol JSONAbleType {
    static func fromJSON(_: [String: Any]) throws -> Self
}

// Parse Google places api response.
final public class Result: JSONAbleType {
    let locations: [Location]
    
    init(locations: [Location]) {
        self.locations = locations
    }
    
    static func fromJSON(_ json: [String: Any]) throws -> Result {
        let json = JSON(json)
        guard let dict = json.dictionary, let status = dict["status"]?.string, status == "OK" else {
             throw ApiError.requestFailed
        }
        guard let results = json["results"].array else {
            throw ApiError.jsonParsingError
        }
        let locations = try results.map {
            return try Location.fromJSON($0.dictionaryObject!)
        }
        return Result(locations: locations)
    }
}

final public class Location: NSObject {
    let address: String
    let locationCoordinate: CLLocationCoordinate2D
    
    init(address: String, locationCoordinate: CLLocationCoordinate2D) {
        self.address = address
        self.locationCoordinate = locationCoordinate
    }
}

extension Location: JSONAbleType {
    static func fromJSON(_ json: [String: Any]) throws -> Location {
        let json = JSON(json)
        guard let address = json.dictionary?["formatted_address"]?.string,
            let latitude = json.dictionary?["geometry"]?.dictionary?["location"]?.dictionary?["lat"]?.double,
            let longitude = json.dictionary?["geometry"]?.dictionary?["location"]?.dictionary?["lng"]?.double else {
                throw ApiError.jsonParsingError
        }
        return Location(address: address, locationCoordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
    }
}

extension Location: MKAnnotation {
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
    }

    public var title: String? {
        return address
    }
    
    public var subtitle: String? {
        return "\((locationCoordinate.latitude, locationCoordinate.longitude))"
    }
}

