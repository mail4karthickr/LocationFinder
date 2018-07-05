//
//  LocationCoreDataModel+CoreDataProperties.swift
//  LocationFinder
//
//  Created by karthick on 7/4/18.
//  Copyright © 2018 karthick. All rights reserved.
//
//

import Foundation
import CoreData


extension LocationCoreDataModel {
    @NSManaged public var address: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
}
