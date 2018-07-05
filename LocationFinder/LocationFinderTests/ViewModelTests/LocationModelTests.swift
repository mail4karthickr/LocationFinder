//
//  LocationModelTests.swift
//  LocationFinderTests
//
//  Created by karthick on 7/5/18.
//  Copyright © 2018 karthick. All rights reserved.
//

import UIKit
import SwiftyJSON
import XCTest

@testable import LocationFinder

class LocationModelTests: XCTestCase {
    
    func testFromJSON() {
        let response = stubbedResponse("LocationResponse")
        let location = try! Location.fromJSON(JSON(response!).dictionaryObject!)
        
        XCTAssertEqual(location.address, "233 S Wacker Dr # 3500, Chicago, IL 60606, USA")
        XCTAssertEqual(location.coordinate.latitude, 41.878885)
        XCTAssertEqual(location.coordinate.longitude, -87.63587799999999)
    }
    
    func testFromJSONForInvalidJson() {
        let response = stubbedResponse("InvalidLocationResponse")
        
        XCTAssertThrowsError(try Location.fromJSON(JSON(response!).dictionaryObject!)) { error in
            XCTAssertEqual(error as! ApiError, ApiError.jsonParsingError)
        }
    }
}

