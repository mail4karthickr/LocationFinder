//
//  LocationsListModel.swift
//  LocationFinder
//
//  Created by karthick on 6/29/18.
//  Copyright © 2018 karthick. All rights reserved.
//

// Responsible for Api calls.
import Foundation
import Moya

enum ApiError: String {
    case jsonParsingError, requestFailed
}

extension ApiError: Error {}

enum GoogleApiService {
    case locationsList(searchText: String)
}

extension GoogleApiService: TargetType {
    var sampleData: Data {
        switch self {
        case .locationsList(_):
            return stubbedResponse("Locations")
        }
    }
    
    var baseURL: URL {
        switch self {
        case .locationsList(_):
            return URL(string: "https://maps.googleapis.com/")!
        }
    }
    
    var path: String {
        switch self {
        case .locationsList(_):
            return "/maps/api/geocode/json"
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .locationsList(let searchText):
            return .requestParameters(parameters: ["address":searchText,"Springfield":"false"], encoding: URLEncoding.queryString)
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
}

func stubbedResponse(_ filename: String) -> Data! {
    @objc class TestClass: NSObject { }
    
    let bundle = Bundle(for: TestClass.self)
    let path = bundle.path(forResource: filename, ofType: "json")
    return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
}
