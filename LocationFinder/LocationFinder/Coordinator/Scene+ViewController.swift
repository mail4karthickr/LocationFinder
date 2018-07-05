//
//  Scene+ViewController.swift
//  LocationFinder
//
//  Created by karthick on 6/28/18.
//  Copyright © 2018 karthick. All rights reserved.
//

import UIKit

// Responsible for returning the viewcontroller associated with a scene.
protocol SceneType {
    func viewController() -> UIViewController
}

extension Scene: SceneType {
    func viewController() -> UIViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        switch self {
        case .locationsList(let viewModel):
            let nc = storyBoard.instantiateViewController(withIdentifier: "rootNavigationController") as! UINavigationController
            var vc = nc.viewControllers.first as! LocationsListViewController
            vc.bindViewModel(to: viewModel)
            return nc
        case .map(let viewModel):
            var vc = storyBoard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
            vc.bindViewModel(to: viewModel)
            return vc
        }
    }
}

