import SwiftUI

@main
struct TapinApp: App {
	@Environment(\.scenePhase) var scenePhase

	var body: some Scene {
//        Settings {
//            SettingsView()
//        }
        
		WindowGroup {
			ContentView(workspaces: Workspaces())
				.frame(minWidth: 500, idealWidth: 700, maxWidth: 900, minHeight: 500, idealHeight: 500, maxHeight: 900, alignment: .center)
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
	}
	
}
