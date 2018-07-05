//
//  SceneCoordinator.swift
//  LocationFinder
//
//  Created by karthick on 6/28/18.
//  Copyright © 2018 karthick. All rights reserved.
//

import Foundation
import RxSwift

// This is the coordinator for our app. All the navigation between the scenes(viewcontroller + viewmodel) should happen through this class.
class SceneCoordinator: SceneCoordinatorType {
    var window: UIWindow
    var currentViewController: UIViewController // Always holds refrence to the visible viewcontroller.
    
    required init(window: UIWindow) {
        self.window = window
        currentViewController = window.rootViewController!
    }
    
    // If top viewcontroller is tabbar controller this logic is needed to fetch the viewcontroller inside the tabbarcontroller. We are not using tabbarcontroller in our app but this is just part of the coordinator class.
    func actualViewController(for viewController: UIViewController) -> UIViewController {
        if let tabBarController = viewController as? UITabBarController {
            if let selectedViewController = tabBarController.selectedViewController, let navController =
                selectedViewController as? UINavigationController {
                // if selected vc is of type UINavigationController
                return navController.viewControllers.first!
            } else if let selectedViewController = tabBarController.selectedViewController {
                // if selected vc is of type UIViewController
                return selectedViewController
            } else if let navController = tabBarController.viewControllers?[0] as? UINavigationController {
                // There is no selected viewcontroller
                return navController.viewControllers.first!
            } else {
                return (tabBarController.viewControllers?[0])!
            }
        } else if let navigationController = viewController as? UINavigationController {
            return navigationController.viewControllers.first!
        } else {
            return viewController
        }
    }
    
    // transition between the scenes
    @discardableResult
    func transition(to scene: SceneType, type: SceneTransitionType) -> Completable {
        let subject = PublishSubject<Void>()
        let viewController = scene.viewController()
        switch type {
        case .root:
            currentViewController = actualViewController(for: viewController)
            window.rootViewController = viewController
            subject.onCompleted()
        case .push:
            guard let navigationController = currentViewController.navigationController else {
                fatalError("Can't push a view controller without a current navigation controller")
            }
            navigationController.pushViewController(viewController, animated: true)
            _ = navigationController.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map { _ in }
                .bind(to: subject)
            currentViewController = actualViewController(for: viewController)
        case .modal:
            currentViewController.present(viewController, animated: true) {
                subject.onCompleted()
            }
            currentViewController = actualViewController(for: viewController)
        }
        return subject.asObservable().take(1)
            .ignoreElements()
    }
    
    @discardableResult
    func pop(animated: Bool) -> Completable {
        let subject = PublishSubject<Void>()
        if let presenter = currentViewController.presentingViewController {
            // dismiss a modal controller
            currentViewController.dismiss(animated: animated) {
                self.currentViewController = self.actualViewController(for: presenter)
                subject.onCompleted()
            }
        } else if let navigationController = currentViewController.navigationController {
            // navigate up the stack
            // one-off subscription to be notified when pop complete
            _ = navigationController.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map { _ in }
                .bind(to: subject)
            guard navigationController.popViewController(animated: animated) != nil else {
                fatalError("can't navigate back from \(currentViewController)")
            }
            currentViewController = self.actualViewController(for: navigationController.viewControllers.last!)
        } else {
            fatalError("Not a modal, no navigation controller: can't navigate back from \(currentViewController)")
        }
        return subject.asObservable()
            .take(1)
            .ignoreElements()
    }
}

