import SwiftUI

struct GeneralSettingsView: View {
    @AppStorage("colorScheme") private var colorScheme = "dark"
    @AppStorage("displayToolbarWidget") private var displayToolbarWidget = true
    
    var body: some View {
        Form {
            Picker("Appearance", selection: $colorScheme) {
                Text("System").tag("system")
                Text("Dark").tag("dark")
                Text("Light").tag("light")
            }
            
            Toggle("Display toolbar widget", isOn: $displayToolbarWidget)
        }
        .formStyle(.grouped)
    }
}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView()
    }
}
