//
//  SceneCoordinatorType.swift
//  LocationFinder
//
//  Created by karthick on 6/28/18.
//  Copyright © 2018 karthick. All rights reserved.
//

import Foundation
import RxSwift

protocol SceneCoordinatorType {
    //transition to another scene
    @discardableResult
    func transition(to scene: SceneType, type: SceneTransitionType) -> Completable
    
    /// pop scene from navigation stack or dismiss current modal
    @discardableResult
    func pop(animated: Bool) -> Completable
}

extension SceneCoordinatorType {
    @discardableResult
    func pop() -> Completable {
        return pop(animated: true)
    }
}
