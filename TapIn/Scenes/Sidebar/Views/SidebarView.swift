import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var sidebarState: SidebarState
    
    @AppStorage("subscribed") var subscribed: Bool = false
    
    var body: some View {
        NavigationView {
            List(selection: $sidebarState.sidebarModel.selection) {
                Section(header: Text("Pages")) {
                    ForEach(sidebarState.sidebarModel.pageLinks) { item in
                        sidebarButtonToPage(sidebarListItem: item)
                    }
                }
                .collapsible(false)
                
                Section(header: Text("Workspaces")) {
                    OutlineGroup(sidebarState.sidebarModel.outline, children: \.children) { outlineItem in
                        if outlineItem.sidebarListItem.folder != nil
                        {
                            SidebarButtonToFolder(sidebarListItem: outlineItem.sidebarListItem)
                        }
                        else if outlineItem.sidebarListItem.workspace != nil
                        {
                            SidebarButtonToWorkspace(sidebarListItem: outlineItem.sidebarListItem)
                        }
                    }
                }
                .collapsible(false)
                
                Spacer()
                
                if subscribed == true {
                    Text("Subscribed")
                } else {
                    Text("Not subscribed")
                }
                
                HStack {
                    Button(action: sidebarState.addFolder) {
                        Image(systemName: "plus")
                    }
                    
                    Button(action: openSettingsWindow) {
                        Image(systemName: "gearshape")
                    }
                    
                    Spacer()
                }
            }
            .listStyle(.sidebar)
            .padding()
            .frame(minWidth: 200, idealWidth: 300, maxWidth: 500, idealHeight: .infinity, maxHeight: .infinity)
        }
    }
    
    func openSettingsWindow() {
        if #available(macOS 13.0, *) {
            NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
        } else {
            NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
        }
    }
    
    @ViewBuilder
    private func sidebarButtonToPage(sidebarListItem: SidebarListItem) -> some View {
        CoreSidebarButton(sidebarListItem: sidebarListItem, destination: {
            switch sidebarListItem
            {
            case .home:
                Text("Home")
            case .statistics:
                StatisticsView()
            default:
                fatalError("1493403")
            }
        })
    }
}
