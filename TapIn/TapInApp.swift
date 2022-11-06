import SwiftUI
import RealmSwift

@main
struct TapinApp: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            SidebarView()
                .environment(\.workspaceCoordinator, WorkspaceCoordinator.shared)
                .environment(\.realm, RealmManager.shared.realm)
                .environmentObject(SidebarState())
                .userPreferenceColorScheme()
        }
        .defaultSize(width: 600, height: 600)
        .windowStyle(HiddenTitleBarWindowStyle())
        .commands {
            SidebarCommands()
        }
        
        SwiftUI.Settings {
            SettingsView()
        }
    }
}
