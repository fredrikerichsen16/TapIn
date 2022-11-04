import SwiftUI
import RealmSwift

@main
struct TapinApp: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            SidebarView()
//                .frame(minWidth: 600, idealWidth: 800, maxWidth: 1000, minHeight: 500, idealHeight: 600, maxHeight: 800, alignment: .center)
                .environment(\.realm, RealmManager.shared.realm)
                .environmentObject(SidebarVM())
                .userPreferenceColorScheme()
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .commands {
            SidebarCommands()
        }
        
        SwiftUI.Settings {
            SettingsView()
        }
    }
}
