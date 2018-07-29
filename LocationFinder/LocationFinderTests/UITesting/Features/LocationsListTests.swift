//
//  LocationsListTests.swift
//  LocationFinderTests
//
//  Created by karthick on 7/22/18.
//  Copyright © 2018 karthick. All rights reserved.
//

import Nimble
@testable import LocationFinder

class LocationsListTests: BaseUITests {
    
    func testDisplayNoLocationsOnLaunch() {
        // backToRoot()
        // terminateApp()
        // openTheApp()
        // expectToSeeMessageViewWithMessage("No Results found")
        // expectNotToSeeLocationsListView()
    }
    
    func testDisplayMultipleLocations() {
         clearOutLocationSearchField()
         enterSearchTextWhichHasMultipleCitiesWithSameName()
         waitToSeeLocationsListView()
         expectToSeeLocationsListViewWith(numberOfSections: 2)
//         expectToSeeDisplayAllSection()
//         expectToSeeSectionTwoWith(numberOfRows: 5)
//         expectNotToSeeMessageView()
    }
    
    func testNoResultsMessage() {
        // backToRoot()
        // enterSearcText()
        // expectToSeeLocationsListView()
        // clearSearchText()
        // expectToSeeMessageViewWithMessage("")
    }
    
    func testDisplaySingleLocation() {
        // backToRoot()
        // clearSearchTextField()
        // enterSearchTextWithSingleCity()
        // expectToSeeLocationsListViewWithSingleSection()
        // expectNotToSeeLocationsListViewWithMultipleSections()
        // expectToSeeSec0Row1WithCityName("")
    }
    
    func testDisplayMultipleLocationsTap() {
        
    }
    
    func testCityNameTap() {
        
    }

    
    // LocationsListSteps
    func clearOutLocationSearchField() {
        tester().clearTextFromView(withAccessibilityLabel: AccessibilityConstants.LocationsList.locationsSearchField.rawValue)
    }

    func enterSearchTextWhichHasMultipleCitiesWithSameName() {
        tester().enterText("SpringField", intoViewWithAccessibilityLabel: AccessibilityConstants.LocationsList.locationsSearchField.rawValue)
    }
//
//    func clearLocationSearchTextFieldAndEnterText(string: String) {
//        tester().clearText(fromAndThenEnterText: string, intoViewWithAccessibilityLabel: AccessibilityConstants.LocationsList.locationsSearchField)
//    }
    
    func waitToSeeLocationsListView() {
        tester().waitForView(withAccessibilityLabel: AccessibilityConstants.LocationsList.locationsTableView.rawValue)
    }
    
    func expectToSeeLocationsListViewWith(numberOfSections: Int) {
        expectToSeeTableViewWith(numberOfSections: numberOfSections)
    }
    
    func expectNotToSeeMessageView() {
        tester().waitForAbsenceOfView(withAccessibilityLabel: AccessibilityConstants.Common.messageView.rawValue)
    }
    
    func expectToSeeSectionTwoWith(numberOfRows: Int) {
        expectToSee(numberOfRows: numberOfRows, inSection: 2, inTableView: AccessibilityConstants.LocationsList.locationsTableView.rawValue)
    }
    
    func expectToSeeDisplayAllSection() {
        expectToSee(title: "DisplayAll", inSectionHeader: 1)
    }
}
