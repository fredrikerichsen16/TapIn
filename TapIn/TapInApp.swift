import SwiftUI
import RealmSwift

@main
struct TapinApp: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
//            ImgView()
            ContentView()
                .frame(minWidth: 500, idealWidth: 700, maxWidth: 1000, minHeight: 500, idealHeight: 500, maxHeight: 800, alignment: .center)
                .environment(\.realm, RealmManager.shared.realm)
                .environmentObject(SidebarVM())
                .userPreferenceColorScheme()
        }
        .windowStyle(HiddenTitleBarWindowStyle())

        SwiftUI.Settings {
            SettingsView()
        }
    }
}

struct ImgView: View {
    var body: some View {
        Image("Classical", bundle: .main)
            .resizable()
            .frame(width: 200, height: 350)
    }
}
