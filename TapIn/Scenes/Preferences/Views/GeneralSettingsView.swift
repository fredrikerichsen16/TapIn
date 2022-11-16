import SwiftUI
import UserNotifications

struct GeneralSettingsView: View {
    @AppStorage("colorScheme") private var colorScheme = "dark"
    @AppStorage("displayToolbarWidget") private var displayToolbarWidget = true
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false
    
    var body: some View {
        Form {
            Picker("Appearance", selection: $colorScheme) {
                Text("System").tag("system")
                Text("Dark").tag("dark")
                Text("Light").tag("light")
            }
            
            Toggle("Display toolbar icon", isOn: $displayToolbarWidget)
            
            Toggle(isOn: $notificationsEnabled, label: {
                Text("Enable notifications")
                Text("TapIn only shows notifications during active use of the app. E.g. telling you that a session has ended.")
            })
            .onChange(of: notificationsEnabled) { enable in
                if enable {
                    NotificationManager.main.requestAuthorization()
                }
            }
        }
        .formStyle(.grouped)
    }
}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView()
    }
}
