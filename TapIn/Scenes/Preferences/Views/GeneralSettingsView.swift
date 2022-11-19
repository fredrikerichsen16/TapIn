import SwiftUI

struct GeneralSettingsView: View {
    @AppStorage(AppStorageKey.colorScheme) private var colorScheme = "dark"
    @AppStorage(AppStorageKey.notificationsEnabled) private var notificationsEnabled = false
    
    var body: some View {
        Form {
            Picker("Appearance", selection: $colorScheme) {
                Text("System").tag("system")
                Text("Dark").tag("dark")
                Text("Light").tag("light")
            }

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
