import SwiftUI

struct SettingsView: View {
    @State private var selection: Tabs = .general
    
    private enum Tabs: Hashable {
        case general, subscription
    }
    
    var body: some View {
        TabView(selection: $selection) {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                .tag(Tabs.general)
            
            SubscriptionSettingsView()
                .tabItem {
                    Label("Subscription", systemImage: "heart.fill")
                }
                .tag(Tabs.subscription)
        }
        .frame(minWidth: 300, idealWidth: 450, maxWidth: 1200, minHeight: 300, idealHeight: 450, maxHeight: 1200, alignment: .center)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
