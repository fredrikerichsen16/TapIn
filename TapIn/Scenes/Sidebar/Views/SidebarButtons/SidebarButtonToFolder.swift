import SwiftUI

struct SidebarButtonToFolder: View {
    @EnvironmentObject var sidebarState: SidebarState
    @State var listItem: SidebarListItem

    var body: some View {
        DynamicSidebarButton(
            listItem: listItem,
            destination: {
                if let folder = listItem.getFolder()
                {
                    FolderView()
                        .environmentObject(FolderState(folder: folder))
                        .environment(\.listItem, listItem)
                }
                else
                {
                    EmptyView()
                }
            },
            contextMenu: {
                Button("Add workspace") {
                    sidebarState.addWorkspace(toFolder: listItem)
                }
    
                Button("Delete") {
                    sidebarState.delete(folder: listItem)
                }
    
                Button("Create new folder") {
                    sidebarState.addFolder()
                }
                
                Button("Settings") {
                    let settingsWindowSelectorName: String
                    
                    if #available(macOS 13.0, *) {
                        settingsWindowSelectorName = "showSettingsWindow:"
                    } else {
                        settingsWindowSelectorName = "showPreferencesWindow:"
                    }
                    
                    NSApp.sendAction(Selector((settingsWindowSelectorName)), to: nil, from: nil)
                }
            },
            onSubmitChangeName: {(name) in
                sidebarState.rename(listItem, name: name)
            }
        )
    }
}
