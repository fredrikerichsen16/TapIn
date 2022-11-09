import SwiftUI

struct SidebarButtonToFolder: View {
    @EnvironmentObject var sidebarState: SidebarState
    @State var sidebarListItem: SidebarListItem

    var folder: FolderDB {
        sidebarListItem.folder!
    }

    var body: some View {
        DynamicSidebarButton(
            sidebarListItem: sidebarListItem,
            destination: {
                FolderView()
                    .environmentObject(FolderState(folder: folder))
            },
            contextMenu: {
                Button("Add workspace") {
                    sidebarState.addWorkspace(to: folder)
                }
    
                Button("Delete") {
                    sidebarState.delete(folder: folder)
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
                sidebarState.renameFolder(folder, name: name)
            }
        )
    }
}
