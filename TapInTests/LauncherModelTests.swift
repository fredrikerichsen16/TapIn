import XCTest
@testable import TapIn

class LauncherModelTests: XCTestCase {

    private var craftApp: LaunchInstance!
    private var notesApp: LaunchInstance!
    
    override func setUpWithError() throws {
        let craftURL = URL(fileURLWithPath: "/Applications/Craft.app")
        let notesURL = URL(fileURLWithPath: "/Applications/Notes.app")
        
        craftApp = AppLauncher(name: "Craft", app: craftURL, file: nil)
        notesApp = AppLauncher(name: "Notes", app: notesURL, file: nil)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_getCompatibleApps() {
        let icon = craftApp
        
        XCTAssertNotNil(icon)
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

//struct LaunchInstance: Identifiable {
//    var id = UUID()
//    var name: String
//    var app: URL?
//    var file: URL?
//    var appFirst: Bool = true
//
//    func getApp() -> URL {
//        if let app = app
//        {
//            return app
//        }
//        else
//        {
//            return getDefaultApp()
//        }
//    }
//
//    init(name: String, appFirst: Bool, app: URL?, file: URL?) {
//        self.name = name
//        self.appFirst = appFirst
//        self.app = app
//        self.file = file
//    }
//
//    func getAppIcon(size: Int = 80) -> NSImage {
//        let app = getApp()
//        let image = NSWorkspace.shared.icon(forFile: app.path)
//            image.size = NSSize(width: size, height: size)
//
//        return image
//    }
//
//    func getFileIcon(size: Int = 80) -> NSImage? {
//        if let file = file
//        {
//            let image = NSWorkspace.shared.icon(forFile: file.path)
//                image.size = NSSize(width: size, height: size)
//
//            return image
//        }
//
//        return nil
//    }
//
////    static func getIcon(for url: URL, size: Int = 80) -> NSImage {
////        let image: NSImage = NSWorkspace.shared.icon(forFile: url.path)
////            image.size = NSSize(width: size, height: size)
////
////        return image
////    }
//
//    func getDefaultApp() -> URL {
//        if file != nil,
//           let defaultApp = NSWorkspace.shared.urlForApplication(toOpen: file!)
//        {
//            return defaultApp
//        }
//        else
//        {
//            return URL(fileURLWithPath: "/Applications/Notes.app")
//        }
//    }
//
//    func getCompatibleApps() -> [URL] {
//        guard file != nil else { fatalError("File is not defined") }
//
//        let cfUrl = file! as CFURL
//
//        var URLs: [URL] = []
//
//        if let appURLs = LSCopyApplicationURLsForURL(cfUrl, .all)?.takeRetainedValue()
//        {
//            for url in appURLs as! [URL] {
//                URLs.append(url)
//            }
//        }
//
//        return URLs
//    }
//
//    func open() {
//        if file != nil
//        {
//            let config = NSWorkspace.OpenConfiguration()
//                config.activates = true
//
//            NSWorkspace.shared.open([file!], withApplicationAt: getApp(), configuration: config) { (app, error) in
//                print(app)
//            }
//        }
//        else
//        {
//            NSWorkspace.shared.open(getApp())
//        }
//    }
//
//    func urlInfo(for url: URL) {
//        print("""
//            - Path: \(url.path)
//            - Is directory?: \(url.hasDirectoryPath)
//            - Is file?: \(url.isFileURL)
//            - Scheme: \(url.scheme)
//            - Last Path Component: \(url.lastPathComponent)
//            - Extension: \(url.pathExtension)
//            - File exitsts?: \(FileManager.default.fileExists(atPath: url.path))
//            - urlForApp: \(NSWorkspace.shared.urlForApplication(toOpen: url))
//        """)
//    }
//}
