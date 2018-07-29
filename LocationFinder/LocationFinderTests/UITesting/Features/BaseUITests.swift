//
//  BaseUITests.swift
//  LocationFinderTests
//
//  Created by karthick on 7/22/18.
//  Copyright © 2018 karthick. All rights reserved.
//

import KIF
import Nimble

class BaseUITests: KIFTestCase {
    override func beforeAll() {
        super.beforeAll()
    }
    
    override func beforeEach() {
        super.beforeEach()
        backToRoot()
    }
}
