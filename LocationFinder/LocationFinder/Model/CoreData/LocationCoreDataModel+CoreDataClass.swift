//
//  LocationCoreDataModel+CoreDataClass.swift
//  LocationFinder
//
//  Created by karthick on 7/4/18.
//  Copyright © 2018 karthick. All rights reserved.
//
//

import Foundation
import CoreData

protocol LocationCoreDataModelType {
    func insert(_ location: Location)
    func exists(_ location: Location) -> Bool
    func delete(_ location: Location)
}

@objc(LocationCoreDataModel)
public class LocationCoreDataModel: NSManagedObject, LocationCoreDataModelType {
    let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
    
    func insert(_ location: Location) {
        if let locationEntity = NSEntityDescription.insertNewObject(forEntityName: "LocationCoreDataModel", into: context) as? LocationCoreDataModel {
            locationEntity.address = location.address
            locationEntity.latitude = location.coordinate.latitude
            locationEntity.longitude = location.coordinate.longitude
            try? CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
        }
    }
    
    func exists(_ location: Location) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: LocationCoreDataModel.self))
        fetchRequest.predicate = NSPredicate(format: "%K == %@", "address", location.address as NSObject)
        let count = try? context.count(for: fetchRequest)
        if let count = count, count > 0 {
            return true
        } else {
            return false
        }
    }
    
    func delete(_ location: Location) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: LocationCoreDataModel.self))
        fetchRequest.predicate = NSPredicate(format: "%K == %@", "address", location.address as NSObject)
        do {
            let res = try context.fetch(fetchRequest) as! [NSManagedObject]
            for val in res {
                context.delete(val)
            }
            try? context.save()
        } catch let error {
            print("Error while deleting location -- \(location) -- error -- \(error)")
        }
    }
}
