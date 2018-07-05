//
//  AppDelegate.swift
//  LocationFinder
//
//  Created by karthick on 6/28/18.
//  Copyright © 2018 karthick. All rights reserved.
//

import UIKit
import Moya
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let sceneCoordinator = SceneCoordinator(window: window!)
        let provider = MoyaProvider<GoogleApiService>()
        let locationsListViewModel = LocationsListViewModel(sceneCoordinator, provider)
        let firstScene = Scene.locationsList(locationsListViewModel)
        sceneCoordinator.transition(to: firstScene, type: .root)
        CoreDataStack.sharedInstance.applicationDocumentsDirectory()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataStack.sharedInstance.saveContext()
    }
}

