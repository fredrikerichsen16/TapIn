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
    
//    @StateObject var menuBarState = MenuBarState()
}

// MARK: MenuBarExtra
//
//extension TapinApp {
//    var menuBarExtra: some Scene {
//        MenuBarExtra(content: {
//            Button("One") {
//                NotificationCenter.default.post(name: Notification.Name("GoToWorkspace"), object: self)
//            }
//            .keyboardShortcut("1")
//
//            Button("Two") {
//                menuBarState.pomodoroRemainingTime = "10:00"
//            }
//            .keyboardShortcut("2")
//
//            Button(menuBarState.pomodoroRemainingTime) {
//                print("three")
//            }
//            .keyboardShortcut("3")
//
//            Divider()
//
//            Button("Quit") {
//                NSApplication.shared.terminate(nil)
//            }
//            .keyboardShortcut("q")
//        }, label: {
//            Text("TapIn")
//        })
//        .menuBarExtraStyle(.menu)
//    }
//}
//
//class MenuBarState: ObservableObject {
//    @Published var pomodoroRemainingTime = "25:00"
//}
