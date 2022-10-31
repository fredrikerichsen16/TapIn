import SwiftUI
import RealmSwift

@main
struct TapinApp: SwiftUI.App {
    let stateManager = StateManager()
    
	var body: some Scene {
		WindowGroup {
            ContentView()
                .frame(minWidth: 500, idealWidth: 700, maxWidth: 1000, minHeight: 500, idealHeight: 500, maxHeight: 800, alignment: .center)
                .environment(\.realm, RealmManager.shared.realm)
                .environmentObject(stateManager)
		}
		.windowStyle(HiddenTitleBarWindowStyle())
        
        SwiftUI.Settings {
            SettingsView()
        }
	}
}
