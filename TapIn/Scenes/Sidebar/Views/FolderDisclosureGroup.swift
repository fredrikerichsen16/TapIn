import SwiftUI

struct FolderDisclosureGroup: View {
    @State private var isExpanded = false
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
    }
}

struct FolderDisclosureGroup_Previews: PreviewProvider {
    static var previews: some View {
        FolderDisclosureGroup(folder: SidebarListItem(name: "Work", icon: IconKeys.folder))
    }
}
