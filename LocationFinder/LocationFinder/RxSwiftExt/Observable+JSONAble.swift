//
//  Observable+JSONAble.swift
//  LocationFinder
//
//  Created by karthick on 7/4/18.
//  Copyright © 2018 karthick. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import SwiftyJSON

enum ParsingError: String {
    case couldNotParseJSON
    case notLoggedIn
    case missingData
}

extension ParsingError: Swift.Error { }

extension Observable {
    
    typealias Dictionary = [String: AnyObject]
    
    // Use this when json is dictionary type.
    func mapTo<B: JSONAbleType>(object classType: B.Type) -> Observable<B> {
        return self.map { json in
            guard let dict = json as? Dictionary else {
                throw ParsingError.couldNotParseJSON
            }
            
            return try B.fromJSON(dict)
        }
    }
    
    // Use this when json is array type.
    func mapTo<B: JSONAbleType>(arrayOf classType: B.Type) -> Observable<[B]> {
        return self.map { json in
            guard let array = json as? [AnyObject] else {
                throw ParsingError.couldNotParseJSON
            }

            guard let dicts = array as? [Dictionary] else {
                throw ParsingError.couldNotParseJSON
            }

            return try dicts.map { try B.fromJSON($0) }
        }
    }
}

