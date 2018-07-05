//
//  LocationModelTests.swift
//  LocationFinderTests
//
//  Created by karthick on 7/4/18.
//  Copyright © 2018 karthick. All rights reserved.
//

import UIKit
import SwiftyJSON
import XCTest

@testable import LocationFinder

class ResultModelTests: XCTestCase {
    
    func testFromJSON() {
        let response = stubbedResponse("MultipleLocationResponse")
        let results = try! Result.fromJSON(JSON(response!).dictionaryObject!)
        
        XCTAssertEqual(results.locations.count, 3)
    }
    
    func testFromJSONForInvalidResponse() {
        let response = stubbedResponse("InvalidResponse")
        
        XCTAssertThrowsError(try Result.fromJSON(JSON(response!).dictionaryObject!)) { error in
            XCTAssertEqual(error as! ApiError, ApiError.jsonParsingError)
        }
    }
    
    func testFromJSONForInvalidStatus() {
        let response = stubbedResponse("InvalidStatusResponse")
        
        XCTAssertThrowsError(try Result.fromJSON(JSON(response!).dictionaryObject!)) { error in
            XCTAssertEqual(error as! ApiError, ApiError.jsonParsingError)
        }
    }

}
