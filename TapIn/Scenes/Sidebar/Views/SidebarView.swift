import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var sidebarState: SidebarState
    
    var body: some View {
        NavigationView {
            List(selection: $sidebarState.selection) {
                Section(header: Text("Pages")) {
                    ForEach(sidebarState.pageLinks, id: \.self) { listItem in
                        sidebarButtonToPage(listItem: listItem)
                    }
                }
                .collapsible(false)
                
                Section(header: Text("Workspaces")) {
                    ForEach(sidebarState.outline, id: \.self) { folder in
                        FolderDisclosureGroup(folder: folder)
                    }
                }
                .collapsible(false)
                
                Spacer()
                
                HStack {
                    Button(action: sidebarState.addFolder) {
                        Image(systemName: IconKeys.plus)
                    }
                    
                    Button(action: openSettingsWindow) {
                        Image(systemName: IconKeys.settings)
                    }
                    
                    Spacer()
                }
            }
            .listStyle(.sidebar)
            .padding()
        }
        .edgesIgnoringSafeArea([.all])
    }
    
    func openSettingsWindow() {
        if #available(macOS 13.0, *) {
            NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
        } else {
            NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
        }
    }
    
    @ViewBuilder
    private func sidebarButtonToPage(listItem: SidebarListItem) -> some View {
        CoreSidebarButton(listItem: listItem, destination: {
            switch listItem.name
            {
            case "Statistics":
                StatisticsView()
            default:
                EmptyView()
            }
        })
    }
}

struct SidebarView_Preview: PreviewProvider {
    static var previews: some View {
        SidebarView()
            .environmentObject(SidebarState.preview)
    }
}

