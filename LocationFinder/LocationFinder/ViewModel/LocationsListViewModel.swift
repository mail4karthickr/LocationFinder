//
//  LocationsListViewModel.swift
//  LocationFinder
//
//  Created by karthick on 6/28/18.
//  Copyright © 2018 karthick. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import Moya
import Moya_ModelMapper
import SwiftyJSON

protocol LocationsListViewModelType {
    func getLocations(searchText: String) -> Observable<[MultipleSectionModel]>
    func itemTapped(sectionItem: SectionItem)
}

final class LocationsListViewModel: LocationsListViewModelType {
    let sceneCoordinator: SceneCoordinator
    let provider: MoyaProvider<GoogleApiService>
    private var locationsList: [Location] = []
    
    init(_ sceneCoordinator: SceneCoordinator, _ provider: MoyaProvider<GoogleApiService>) {
        self.sceneCoordinator = sceneCoordinator
        self.provider = provider
    }
    
    // Google places Api call.
    func getLocations(searchText: String) -> Observable<[MultipleSectionModel]> {
        return provider
            .rx
            .request(GoogleApiService.locationsList(searchText: searchText))
            .asObservable()
            .mapJSON() // converts data returned from the api to [String: Any] type
            .mapTo(object: Result.self) // converta returned dictionary to a Result object.
            .map { result in // Get locations from result object and convert to section model objects.
                self.locationsList = result.locations
                var sections: [MultipleSectionModel] = []
                let locationsSectionItem = result.locations.map { SectionItem.LocationsSectionItem(address: $0) }
                if locationsSectionItem.count > 1 { // if location count is more than 1 add a section "Display All On Maps" option
                    sections.append(.NavigateToMapsSection(title: " ", items: [.NavigateToMapsSectionItem(rowName: "Display All On Maps")]))
                }
                if locationsSectionItem.count > 0 {
                    sections.append(.LocationsSection(title: " ", items: locationsSectionItem))
                }
                return sections
            }
            .asObservable()
    }
    
    // will be invoked when user taps any item in the locations list tableview.
    func itemTapped(sectionItem: SectionItem) {
        let viewModel: MapViewModel
        switch sectionItem {
        case .NavigateToMapsSectionItem(_):
            viewModel = MapViewModel(sceneCoordinator: sceneCoordinator, locations: locationsList, locationCoreDataModel: LocationCoreDataModel())
        case .LocationsSectionItem(let location):
            viewModel = MapViewModel(sceneCoordinator: sceneCoordinator, locations: locationsList, locationCoreDataModel: LocationCoreDataModel(), selectedItem: location)
        }
        sceneCoordinator.transition(to: Scene.map(viewModel), type: .push)
    }
}
