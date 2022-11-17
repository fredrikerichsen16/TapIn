import SwiftUI
import RealmSwift

@main
struct TapinApp: SwiftUI.App {
    @AppStorage("subscribed") var subscribed: Bool = false
    
    var body: some Scene {
        WindowGroup {
            SidebarView()
                .environment(\.workspaceCoordinator, WorkspaceCoordinator.shared)
                .environment(\.realm, RealmManager.shared.realm)
                .environment(\.subscriptionManager, SubscriptionManager.shared)
                .environmentObject(SidebarState())
                .userPreferenceColorScheme()
                .onAppear {
                    Task {
                        let subscription = await SubscriptionManager.shared.getSubscriptionState()
                        self.subscribed = subscription.isPremium()
                    }
                }
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
