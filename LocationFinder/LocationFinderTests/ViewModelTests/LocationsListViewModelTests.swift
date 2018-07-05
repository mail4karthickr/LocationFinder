//
//  LocationsListViewModelTests.swift
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
import Moya

@testable import LocationFinder

class LocationListViewModelTests: XCTestCase {
    var sceneCoordinator: SceneCoordinatorType!
    
    override func setUp() {
        super.setUp()
        let window = UIWindow()
        window.rootViewController = UIViewController()
        sceneCoordinator = SceneCoordinator(window: window)
    }
    
    func testGetLocationsForMultipleLocationsResponse() {
        let provider = MoyaProvider<GoogleApiService>(endpointClosure: endPointClosureForMultipleLocations, stubClosure: MoyaProvider.immediatelyStub)
        let viewModel = LocationsListViewModel(sceneCoordinator, provider)
        let locationsObservable = viewModel.getLocations(searchText: "test")
        let result = try! locationsObservable.toBlocking().first()!
        let sectionItem = result.first?.items.first!
        switch sectionItem! {
        case .NavigateToMapsSectionItem(let rowName):
            XCTAssertEqual(rowName, "Display All On Maps")
        default:
            break
        }
    }
    
    func testGetLocationsForSingleLocationResponse() {
        let provider = MoyaProvider<GoogleApiService>(endpointClosure: endPointClosureForSingleLocationResponse, stubClosure: MoyaProvider.immediatelyStub)
        let viewModel = LocationsListViewModel(sceneCoordinator, provider)
        let locationsObservable = viewModel.getLocations(searchText: "test")
        let multipleSecModel = try! locationsObservable.toBlocking().first()!
        let locations = multipleSecModel.first?.items
        let sectionItem = locations?.first!
        
        // Check no of sections that will be displayed in the list
        XCTAssertEqual(multipleSecModel.count, 1)
        
        // Check no of locations
        XCTAssertEqual(locations?.count, 1)
       
        switch sectionItem! {
        case .LocationsSectionItem(let location):
            // Check the location values
            XCTAssertEqual(location.address, "233 S Wacker Dr # 3500, Chicago, IL 60606, USA")
            XCTAssertEqual(location.coordinate.latitude, 41.878885)
            XCTAssertEqual(location.coordinate.longitude, -87.63587799999999)
        default:
            break
        }
    }
    
    
    func testGetLocationsForMultipleLocationsCount() {
        let provider = MoyaProvider<GoogleApiService>(endpointClosure: endPointClosureForMultipleLocations, stubClosure: MoyaProvider.immediatelyStub)
        let viewModel = LocationsListViewModel(sceneCoordinator, provider)
        let locationsObservable = viewModel.getLocations(searchText: "test")
        let result = try! locationsObservable.toBlocking().first()!
        XCTAssertEqual(result[1].items.count, 3)
    }
    
    func testLocationsOrder() {
        let addressInResponse = ["Springfield, MO, USA", "Springfield, MA, USA", "Springfield, IL, USA"]
        let provider = MoyaProvider<GoogleApiService>(endpointClosure: endPointClosureForMultipleLocations, stubClosure: MoyaProvider.immediatelyStub)
        let viewModel = LocationsListViewModel(sceneCoordinator, provider)
        let locationsObservable = viewModel.getLocations(searchText: "test")
        let multipleSecModel = try! locationsObservable.toBlocking().first()!
        let locationSectionItems = multipleSecModel.first?.items
        
        for (index, locSecItem) in locationSectionItems!.enumerated() {
            switch locSecItem {
            case .LocationsSectionItem(let location):
                // Check location order with locations received in the response.
                XCTAssertEqual(location.address, addressInResponse[index])
            default:
                break
            }
        }
        
    }
    
    func testEmptyResponse() {
        let provider = MoyaProvider<GoogleApiService>(endpointClosure: endPointClosureForEmptyResponse, stubClosure: MoyaProvider.immediatelyStub)
        let viewModel = LocationsListViewModel(sceneCoordinator, provider)
        let locationsObservable = viewModel.getLocations(searchText: "test")
        let result = try! locationsObservable.toBlocking().first()!
        XCTAssertEqual(result.count, 0)

    }
    
    let endPointClosureForMultipleLocations = { (target: GoogleApiService) -> Endpoint in
        return Endpoint(url: "test", sampleResponseClosure: {.networkResponse(200, stubbedResponse("MultipleLocationResponse"))}, method: target.method, task: target.task, httpHeaderFields: target.headers)
        
    }
    
    let endPointClosureForSingleLocationResponse = { (target: GoogleApiService) -> Endpoint in
        return Endpoint(url: "test", sampleResponseClosure: {.networkResponse(200, stubbedResponse("SingleLocationResponse"))}, method: target.method, task: target.task, httpHeaderFields: target.headers)
        
    }
    
    let endPointClosureForEmptyResponse = { (target: GoogleApiService) -> Endpoint in
        return Endpoint(url: "test", sampleResponseClosure: {.networkResponse(200, stubbedResponse("EmptyResponse"))}, method: target.method, task: target.task, httpHeaderFields: target.headers)
        
    }
}
