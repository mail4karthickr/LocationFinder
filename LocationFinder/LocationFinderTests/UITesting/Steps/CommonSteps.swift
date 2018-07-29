//
//  CommonSteps.swift
//  LocationFinderTests
//
//  Created by karthick on 7/22/18.
//  Copyright © 2018 karthick. All rights reserved.
//

import Nimble
@testable import LocationFinder

extension BaseUITests {
    func backToRoot() {
        if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            navigationController.popToRootViewController(animated: false)
        }
    }
    
    func expectToSeeTableViewWith(numberOfSections: Int) {
        let locationsListView = tester().waitForView(withAccessibilityLabel: AccessibilityConstants.LocationsList.locationsTableView.rawValue) as! UITableView
        expect(locationsListView.numberOfSections) == numberOfSections
    }
    
    func expectToSee(title: String, inSectionHeader: Int) {
        let locationsListView = tester().waitForView(withAccessibilityLabel: AccessibilityConstants.LocationsList.locationsTableView.rawValue) as! UITableView
        let titleInSectionHeader = locationsListView.headerView(forSection: inSectionHeader)?.textLabel?.text
        expect(titleInSectionHeader) == title
    }
    
    func expectToSee(numberOfRows: Int, inSection: Int, inTableView accessibilityIdentifier: String) {
        let locationsListView = tester().waitForView(withAccessibilityLabel: AccessibilityConstants.LocationsList.locationsTableView.rawValue) as! UITableView
        let currentNoOfRows = locationsListView.numberOfRows(inSection: inSection)
        expect(currentNoOfRows) == numberOfRows
    }
    
    func expectToSeeCellWithTextLabel(labelText: String, atIndexPath indexPath: IndexPath) {
        let noteCell = tester().waitForCell(at: indexPath, inTableViewWithAccessibilityIdentifier: AccessibilityConstants.LocationsList.locationsTableView.rawValue)
        expect(noteCell?.textLabel?.text) == labelText
    }
}
