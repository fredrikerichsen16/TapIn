import XCTest
@testable import TapIn

class PomodoroModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_readableTime() {
        let pomodoro = PomodoroModel(pomodoroDuration: 4739, shortBreakDuration: 30, longBreakDuration: 300, longBreakFrequency: 2)
        
        let pomodoroDuration = pomodoro.readableTime(\.pomodoroDuration)
        
        let shortBreakDuration = pomodoro.readableTime(\.shortBreakDuration)
        
        let longBreakDuration = pomodoro.readableTime(\.longBreakDuration)
        
        XCTAssertEqual("78:59", pomodoroDuration)
        XCTAssertEqual("00:30", shortBreakDuration)
        XCTAssertEqual("05:00", longBreakDuration)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
