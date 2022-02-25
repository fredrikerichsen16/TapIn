//
//  MenuItemTests.swift
//  TapInTests
//
//  Created by Fredrik Skjelvik on 25/02/2022.
//

import XCTest
@testable import TapIn

class MenuItemTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_identifiable() throws {
        let statistics = MenuItem.statistics
        let home = MenuItem.home
        
        XCTAssertEqual(home.id, "home")
        XCTAssertEqual(statistics.id, "statistics")
    }
    
    func test_getMenuItems_emptyParameter() throws {
        XCTAssertNoThrow({
            MenuItem.getMenuItems(workspaces: [])
        })
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
