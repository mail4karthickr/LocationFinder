//
//  Scene.swift
//  LocationFinder
//
//  Created by karthick on 6/28/18.
//  Copyright © 2018 karthick. All rights reserved.
//

import Foundation

// Lists all the scenes present in the application.
// In MVVM+C patteren, Scene comprises a viewmodel and a viewcontroller.
enum Scene {
    case locationsList(LocationsListViewModel)
    case map(MapViewModel)
}
