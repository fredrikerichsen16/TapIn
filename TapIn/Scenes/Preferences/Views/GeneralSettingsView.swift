import SwiftUI
import UserNotifications

struct GeneralSettingsView: View {
    @AppStorage("colorScheme") private var colorScheme = "dark"
    @AppStorage("displayToolbarWidget") private var displayToolbarWidget = true
    
    @State private var enableNotifications = false
    
    var body: some View {
        Form {
            Picker("Appearance", selection: $colorScheme) {
                Text("System").tag("system")
                Text("Dark").tag("dark")
                Text("Light").tag("light")
            }
            
            Toggle("Display toolbar widget", isOn: $displayToolbarWidget)
            
            Toggle(isOn: $enableNotifications, label: {
                VStack {
                    Text("Enable notifications")
                    Text("TapIn only shows notifications during active use of the app. E.g. telling you that a session has ended.")
                }
            })
            .onChange(of: enableNotifications) { enable in
                guard enable else {
                    return
                }
                
                UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (success, error) in
                    if success
                    {
                        print("Notifications activated")
                    }
                    else if let error
                    {
                        print(error.localizedDescription)
                    }
                })
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
