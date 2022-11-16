import SwiftUI

struct DynamicSidebarButton<ContentA, ContentB>: View where ContentA: View, ContentB: View {
    @EnvironmentObject var sidebarState: SidebarState
    
    let listItem: SidebarListItem
    let destination: ContentA
    let contextMenu: ContentB
    let onSubmitChangeName: (_ name: String) -> Void
    
    @State var nameField: String = ""
    @State var isRenaming = false
    
    @Namespace var mainNamespace
    
    init(listItem: SidebarListItem, @ViewBuilder destination: () -> ContentA, @ViewBuilder contextMenu: () -> ContentB, onSubmitChangeName: @escaping (String) -> Void) {
        self.listItem = listItem
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
                Label(listItem.name, systemImage: listItem.icon)
                    .padding(.vertical, 5)
            }
            .tag(listItem.id)
            .contextMenu {
                contextMenu
                
                Button("Rename") {
                    beginRenamingWorkspace()
                }
            }
        }
    }
    
    func beginRenamingWorkspace() {
        nameField = listItem.name
        isRenaming = true
    }
}

