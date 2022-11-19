import SwiftUI

struct FolderDisclosureGroup: View {
    @State private var isExpanded: Bool = false
    let folder: SidebarListItem
    
    var body: some View {
        DisclosureGroup(
            isExpanded: $isExpanded,
            content: {
                if let children = folder.children
                {
                    ForEach(children, id: \.self) { listItem in
                        SidebarButtonToWorkspace(listItem: listItem)
                    }
                }
            },
            label: {
                SidebarButtonToFolder(listItem: folder)
            }
        )
        .onChange(of: isExpanded, perform: { value in
            if let objectId = folder.objectId {
                UserDefaultsManager.main.setFolderIsExpanded(folderId: objectId.stringValue, value: value)
            }
        })
        .onAppear {
            if let objectId = folder.objectId {
                isExpanded = UserDefaultsManager.main.getFolderIsExpanded(folderId: objectId.stringValue)
            }
        }
    }
}

struct FolderDisclosureGroup_Previews: PreviewProvider {
    static var previews: some View {
        FolderDisclosureGroup(folder: SidebarListItem(name: "Work", icon: IconKeys.folder))
    }
}
