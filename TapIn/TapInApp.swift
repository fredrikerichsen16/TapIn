import SwiftUI
import RealmSwift

@main
struct TapinApp: SwiftUI.App {
    @AppStorage(AppStorageKey.subscribed) var subscribed: Bool = false
    
    var body: some Scene {
        WindowGroup {
            SidebarView()
                .environment(\.workspaceCoordinator, WorkspaceCoordinator.shared)
                .environment(\.realm, RealmManager.shared.realm)
                .environmentObject(SidebarState())
                .userPreferenceColorScheme()
                .onReceive(NotificationCenter.default.publisher(for: NSApplication.willTerminateNotification), perform: { output in
                    WorkspaceCoordinator.shared.terminate()
                })
        }
        .defaultSize(width: 600, height: 600)
        .windowStyle(.hiddenTitleBar)
        .commands {
            SidebarCommands()
        }
        
        Settings {
            SettingsView()
                .userPreferenceColorScheme()
        }
        .windowStyle(.hiddenTitleBar)
    }
}
