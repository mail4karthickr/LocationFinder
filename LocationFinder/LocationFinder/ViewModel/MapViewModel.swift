//
//  MapViewModel.swift
//  LocationFinder
//
//  Created by karthick on 7/1/18.
//  Copyright © 2018 karthick. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import MapKit

final class MapViewModel {
    private let sceneCoordinator: SceneCoordinatorType // coordinator used to tarnsition between the view controllers.
    private let locations: [Location]
    private let locationCoreDataModel: LocationCoreDataModelType
    private let selectedItem: Location?
    private var buttonTitleVariable = Variable<String>("") // Variable used to change the save or delete button title based on the user's action.

    init(sceneCoordinator: SceneCoordinatorType, locations: [Location], locationCoreDataModel: LocationCoreDataModelType, selectedItem: Location? = nil) {
        self.sceneCoordinator = sceneCoordinator
        self.locations = locations
        self.selectedItem = selectedItem
        self.locationCoreDataModel = locationCoreDataModel
    }
    
    var annotations: Observable<[MKAnnotation]> {
        return .just(locations)
    }
    
    var selectedLocation: Observable<Location?> {
        return .just(selectedItem)
    }

    func saveSelectedLocation() {
        if let selectedItem = selectedItem {
            locationCoreDataModel.insert(selectedItem) // don't force unwrap find a better way
            buttonTitleVariable.value = "Delete"
        }
    }
    
    func deleteSelectedLocation() {
        if let selectedItem = selectedItem {
            locationCoreDataModel.delete(selectedItem)
            buttonTitleVariable.value = "Save"
        }
    }
    
    var barButtonTitle: Observable<String> {
        // TODO: Find a better way instead of using two if statements
        if let selectedItem = selectedItem {
            if locationCoreDataModel.exists(selectedItem) {
                buttonTitleVariable.value = "Delete"
            } else {
                buttonTitleVariable.value = "Save"
            }
        }
        return buttonTitleVariable.asObservable()
    }
    
    var shouldHideBarButton: Observable<Bool> {
        return selectedItem == nil ? .just(true) : .just(false)
    }
    
    lazy var backButtonAction = { this in
        return CocoaAction {
            return this.sceneCoordinator.pop()
                .asObservable().map { _ in }
        }
    }(self)
}
