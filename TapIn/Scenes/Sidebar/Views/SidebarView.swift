import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var sidebarState: SidebarState
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            List(selection: $sidebarState.sidebarModel.selection) {
                Section(header: Text("Pages")) {
                    ForEach(sidebarState.sidebarModel.pageLinks) { listItem in
                        sidebarButtonToPage(listItem: listItem)
                    }
                }
                .collapsible(false)
                
                Section(header: Text("Workspaces")) {
                    OutlineGroup(sidebarState.sidebarModel.outline, id: \.hashValue, children: \.children) { listItem in
                        if listItem.folder == true
                        {
                            SidebarButtonToFolder(listItem: listItem)
                        }
                        else
                        {
                            SidebarButtonToWorkspace(listItem: listItem)
                        }
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
        .background(colorScheme == .light ? Color.white : nil)
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
            switch listItem.id
            {
            case "statistics":
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

