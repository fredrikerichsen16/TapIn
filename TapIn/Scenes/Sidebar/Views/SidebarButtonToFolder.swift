import SwiftUI

struct SidebarButtonToFolder: View {
    @EnvironmentObject var sidebarVM: SidebarVM
    @State var menuItem: MenuItem

    var folder: FolderDB {
        menuItem.folder!
    }

    var body: some View {
        NavigationLink(destination: {
            Text("Yes hello!")
        }) {
            Label(menuItem.label, systemImage: menuItem.icon)
                .padding(.vertical, 5)
        }
        .tag(menuItem)
        .contextMenu(ContextMenu(menuItems: {
            contextMenu
        }))
    }
}

// MARK: Context Menu
extension SidebarButtonToFolder {
    var contextMenu: some View {
        Group {
            Button("Add workspace") {
                sidebarVM.addWorkspace(to: folder)
            }
            
            Button("Delete") {
                sidebarVM.delete(folder: folder)
            }
            
            Button("Create new folder") {
                sidebarVM.addFolder()
            }
            
            Button("Rename") {
                print("Rename")
            }
        }
    }
}

