import SwiftUI
import RealmSwift

@main
struct TapinApp: SwiftUI.App {
	@Environment(\.scenePhase) var scenePhase
    @ObservedObject var stateManager = StateManager()
    
    let realmManager = RealmManager()
    
	var body: some Scene {
		WindowGroup {
            ContentView()
				.frame(minWidth: 500, idealWidth: 700, maxWidth: 900, minHeight: 500, idealHeight: 500, maxHeight: 900, alignment: .center)
                .environment(\.realm, realmManager.realm)
                .environmentObject(stateManager)
		}
		.windowStyle(HiddenTitleBarWindowStyle())
		.onChange(of: scenePhase) { (newScenePhase) in
			switch newScenePhase {
				case .background:
					print("Scene: Background")
				case .inactive:
					print("Scene: Inactive")
				case .active:
					print("Scene: Active")
				@unknown default:
					print("Scene: Unknown")
			}
		}
        
        SwiftUI.Settings {
            SettingsView()
        }
	}
}
