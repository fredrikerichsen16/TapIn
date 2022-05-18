//
//  WebsiteLauncherTests.swift
//  TapInTests
//
//  Created by Fredrik Skjelvik on 19/05/2022.
//

import XCTest
@testable import TapIn

class WebsiteLauncherTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_convertURL() throws {
        XCTAssertNil(convertURL(urlString: "googlecom@hello.com"))
        XCTAssertNil(convertURL(urlString: "javascript:alert('xss')"))
        XCTAssertNil(convertURL(urlString: "http://notld"))
        XCTAssertNil(convertURL(urlString: "http://potato.54.211.192.240/"))
        
        XCTAssertEqual(convertURL(urlString: "google.no"), "https://google.no")
        XCTAssertNotNil(convertURL(urlString: "google.com"), "https://google.com")
        XCTAssertNotNil(convertURL(urlString: " Google.com "), "https://google.com")
        XCTAssertNotNil(convertURL(urlString: "www.google.com"), "https://www.google.com")
        XCTAssertNotNil(convertURL(urlString: "http://google.com"), "http://google.com")
        XCTAssertNotNil(convertURL(urlString: "https://google.com"), "https://google.com")
        XCTAssertNotNil(convertURL(urlString: "https://www.google.com"), "https://www.google.com")
        XCTAssertNotNil(convertURL(urlString: "https://www.google.com/search?q=hello"), "https://www.google.com/search?q=hello")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
