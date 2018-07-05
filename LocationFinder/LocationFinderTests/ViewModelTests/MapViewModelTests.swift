//
//  MapViewModelTests.swift
//  LocationFinderTests
//
//  Created by karthick on 7/4/18.
//  Copyright © 2018 karthick. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxBlocking
import RxSwift
import XCTest
import MapKit

@testable import LocationFinder

class MapViewModelTests: XCTestCase {
    var sceneCoordinator: SceneCoordinatorType!
    
    override func setUp() {
        super.setUp()
        let window = UIWindow()
        window.rootViewController = UIViewController()
        sceneCoordinator = SceneCoordinator(window: window)
    }
    
    func testAnnotations() {
        let viewModel = MapViewModel(sceneCoordinator: sceneCoordinator, locations: testLocations, locationCoreDataModel: MockLocationCoreDataModel())
        let annotations = try! viewModel.annotations.toBlocking().first()!
        XCTAssertEqual(annotations.count, testLocations.count)
    }
    
    func testSelectedLocation() {
        let viewModelWithoutSelLoc = MapViewModel(sceneCoordinator: sceneCoordinator, locations: testLocations, locationCoreDataModel: MockLocationCoreDataModel())
        let selLocObsNil = try! viewModelWithoutSelLoc.selectedLocation.toBlocking().first()!
        
        let selLocation = Location(address: "testAdd", locationCoordinate: CLLocationCoordinate2D(latitude: 10.0, longitude: 20.0))
        let viewModelWithSelLoc = MapViewModel(sceneCoordinator: sceneCoordinator, locations: testLocations, locationCoreDataModel: MockLocationCoreDataModel(),selectedItem: selLocation)
        let selLocObs = try! viewModelWithSelLoc.selectedLocation.toBlocking().first()!
        
        XCTAssertNil(selLocObsNil)
        XCTAssertNotNil(selLocObs)
    }
    
    func testShowOrHideBarButton() {
        let viewModelWithoutSelLoc = MapViewModel(sceneCoordinator: sceneCoordinator, locations: testLocations, locationCoreDataModel: MockLocationCoreDataModel())
        let shouldHideTrue = try! viewModelWithoutSelLoc.shouldHideBarButton.toBlocking().first()!
    
        let selLocation = Location(address: "testAdd", locationCoordinate: CLLocationCoordinate2D(latitude: 10.0, longitude: 20.0))
        let viewModelWithSelLoc = MapViewModel(sceneCoordinator: sceneCoordinator, locations: testLocations, locationCoreDataModel: MockLocationCoreDataModel(),selectedItem: selLocation)
        let shouldHideFalse = try! viewModelWithSelLoc.shouldHideBarButton.toBlocking().first()!
    
        XCTAssertTrue(shouldHideTrue)
        XCTAssertFalse(shouldHideFalse)
    }
    
    func testBarButtonTitle() {
        let viewModelWithoutSelLoc = MapViewModel(sceneCoordinator: sceneCoordinator, locations: testLocations, locationCoreDataModel: MockLocationCoreDataModel())
        let barButtonTitleEmpty = try! viewModelWithoutSelLoc.barButtonTitle.toBlocking().first()!
        
        // Testing for bar button title "Save"
        let selLocation = Location(address: "testAdd", locationCoordinate: CLLocationCoordinate2D(latitude: 10.0, longitude: 20.0))
        let viewModelWithSelLoc = MapViewModel(sceneCoordinator: sceneCoordinator, locations: testLocations, locationCoreDataModel: MockLocationCoreDataModel(),selectedItem: selLocation)
        let barButtonTitleSave = try! viewModelWithSelLoc.barButtonTitle.toBlocking().first()!
        
        // Testing for bar button title "Delete"
        class MockLocationCoreDataModelForLocExists: LocationCoreDataModelType {
            func exists(_ location: Location) -> Bool { return true }
        }
        let viewModelForButtonTitleSave = MapViewModel(sceneCoordinator: sceneCoordinator, locations: testLocations, locationCoreDataModel: MockLocationCoreDataModelForLocExists(),selectedItem: selLocation)
        let barButtonTitleDelete = try! viewModelForButtonTitleSave.barButtonTitle.toBlocking().first()!
        
        // When sel location is nil, button title should be empty
        XCTAssertEqual(barButtonTitleEmpty, "")
        XCTAssertEqual(barButtonTitleSave, "Save")
        XCTAssertEqual(barButtonTitleDelete, "Delete")
    }
    
    var testLocations: [Location] {
        var locations: [Location] = []
        locations.append(Location(address: "testAddress1", locationCoordinate: CLLocationCoordinate2D(latitude: 10.0, longitude: 12.0)))
        locations.append(Location(address: "testAddress2", locationCoordinate: CLLocationCoordinate2D(latitude: 30.0, longitude: 42.0)))
        locations.append(Location(address: "testAddress3", locationCoordinate: CLLocationCoordinate2D(latitude: 40.0, longitude: 52.0)))
        return locations
    }
}

extension LocationCoreDataModelType {
    func delete(_ location: Location) {}
    func insert(_ location: Location) {}
    func exists(_ location: Location) -> Bool { return false }
}

class MockLocationCoreDataModel: LocationCoreDataModelType { }

