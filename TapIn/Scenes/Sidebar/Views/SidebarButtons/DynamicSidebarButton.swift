import SwiftUI

struct DynamicSidebarButton<ContentA, ContentB>: View where ContentA: View, ContentB: View {
    @EnvironmentObject var sidebarState: SidebarState
    
    let sidebarListItem: SidebarListItem
    let destination: ContentA
    let contextMenu: ContentB
    let onSubmitChangeName: (_ name: String) -> Void
    
    @State var nameField: String = ""
    @State var isRenaming = false
    
    @Namespace var mainNamespace
    
    init(sidebarListItem: SidebarListItem, @ViewBuilder destination: () -> ContentA, @ViewBuilder contextMenu: () -> ContentB, onSubmitChangeName: @escaping (String) -> Void) {
        self.sidebarListItem = sidebarListItem
        self.destination = destination()
        self.contextMenu = contextMenu()
        self.onSubmitChangeName = onSubmitChangeName
    }
    
    var body: some View {
        if isRenaming
        {
            TextField("", text: $nameField) // passing it to bind
                .textFieldStyle(.roundedBorder) // adds border
                .prefersDefaultFocus(in: mainNamespace)
                .onSubmit {
                    onSubmitChangeName(nameField)
                    isRenaming = false
                }
        }
        else
        {
            NavigationLink(destination: destination) {
                Label(sidebarListItem.label, systemImage: sidebarListItem.icon)
                    .padding(.vertical, 5)
            }
            .tag(sidebarListItem)
            .contextMenu {
                contextMenu
                
                Button("Rename") {
                    beginRenamingWorkspace()
                }
            }
        }
    }
    
    func beginRenamingWorkspace() {
        if let workspace = sidebarListItem.workspace
        {
            nameField = workspace.name
            isRenaming = true
        }
        else if let folder = sidebarListItem.folder
        {
            nameField = folder.name
            isRenaming = true
        }
        else
        {
            nameField = ""
            isRenaming = false
        }
    }
}

