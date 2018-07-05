//
//  MultipleSectionModel.swift
//  LocationFinder
//
//  Created by karthick on 6/30/18.
//  Copyright © 2018 karthick. All rights reserved.
//

import Foundation
import RxDataSources

// Used to display multiple sections.
enum MultipleSectionModel {
    case NavigateToMapsSection(title: String, items: [SectionItem])
    case LocationsSection(title: String, items: [SectionItem])
}

enum SectionItem {
    case NavigateToMapsSectionItem(rowName: String)
    case LocationsSectionItem(address: Location)
}

extension MultipleSectionModel: SectionModelType {
    typealias Item = SectionItem
    
    var items: [SectionItem] {
        switch self {
        case .NavigateToMapsSection(title: _ , items: let items):
            return items.map {$0}
        case .LocationsSection(title: _, items: let items):
            return items.map {$0}
        }
    }
    
    init(original: MultipleSectionModel, items: [Item]) {
        switch original {
        case let .LocationsSection(title: title, items: _):
            self = .LocationsSection(title: title, items: items)
        case let .NavigateToMapsSection(title: title, items: _):
            self = .NavigateToMapsSection(title: title, items: items)
        }
    }
}

extension MultipleSectionModel {
    var title: String {
        switch self {
        case .LocationsSection(title: let title, items: _):
            return title
        case .NavigateToMapsSection(title: let title, items: _):
            return title
        }
    }
}
