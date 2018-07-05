//
//  SceneTransitionType.swift
//  LocationFinder
//
//  Created by karthick on 6/28/18.
//  Copyright © 2018 karthick. All rights reserved.
//

import Foundation

// Any custom transitions can be added here
enum SceneTransitionType {
    case root   // make view controller the root view controller
    case push   // push view controller to navigation stack
    case modal  // present view controller modally
}
