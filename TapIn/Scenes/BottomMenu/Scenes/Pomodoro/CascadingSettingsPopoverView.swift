import SwiftUI

struct CascadingSettingsPopoverView: View {
    @State private var tabs: [WorkspaceTab]
    @State private var selectedTabs: Set<WorkspaceTab> = Set()
    
    init(tabs: [WorkspaceTab]) {
        self.tabs = tabs
    }
    
    func insert(_ tab: WorkspaceTab) {
        selectedTabs.insert(tab)
        UserDefaultsManager.main.cascadingOptions = selectedTabs
    }
    
    func remove(_ tab: WorkspaceTab) {
        selectedTabs.remove(tab)
        UserDefaultsManager.main.cascadingOptions = selectedTabs
    }
    
    func contains(_ tab: WorkspaceTab) -> Bool {
        selectedTabs.contains(tab)
    }

    var body: some View {
        Form {
            Section("Cascading Options") {
                Text("Also start/stop the following when session begins/ends")
                
                ForEach(tabs, id: \.self) { tab in
                    Toggle(tab.label, isOn: Binding(
                        get: { contains(tab) },
                        set: { val,_ in
                            val ? insert(tab) : remove(tab)
                        }
                    ))
                }
            }
        }
        .formStyle(.grouped)
        .frame(width: 240)
        .onAppear {
            selectedTabs = UserDefaultsManager.main.cascadingOptions
        }
    }
}
