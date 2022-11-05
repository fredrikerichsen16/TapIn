import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var sidebarVM: SidebarVM
    
    var body: some View {
        NavigationView {
            List(selection: $sidebarVM.sidebarModel.selection) {
                Section(header: Text("Pages")) {
                    ForEach(sidebarVM.sidebarModel.pageLinks) { item in
                        SidebarButtonToPage(menuItem: item)
                    }
                }
                
                Section(header: Text("Workspaces")) {
                    OutlineGroup(sidebarVM.sidebarModel.outline, children: \.children) { outlineItem in
                        if outlineItem.menuItem.folder != nil
                        {
                            SidebarButtonToFolder(menuItem: outlineItem.menuItem)
                        }
                        else if outlineItem.menuItem.workspace != nil
                        {
                            SidebarButtonToWorkspace(menuItem: outlineItem.menuItem)
                        }
                    }
                }
                .collapsible(false)
                
                Spacer()
                
                HStack {
                    Button(action: sidebarVM.addFolder) {
                        Image(systemName: "plus")
                    }
                    
                    Button(action: openSettingsWindow) {
                        Image(systemName: "gearshape")
                    }
                    
                    Button(action: sidebarVM.test) {
                        Image(systemName: "heart.fill")
                    }
                    
                    Spacer()
                }
            }
            .listStyle(.sidebar)
            .padding()
            .frame(minWidth: 200, idealWidth: 300, maxWidth: 500, maxHeight: .infinity)
        }
    }
    
    func openSettingsWindow() {
        if #available(macOS 13.0, *) {
            NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
        } else {
            NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
        }
    }
}
