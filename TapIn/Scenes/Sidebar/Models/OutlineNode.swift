import Foundation

struct OutlineNode: Identifiable {
    var id: String
    var sidebarListItem: SidebarListItem
    var children: [OutlineNode]? = nil
    
    init(workspace: WorkspaceDB) {
        self.sidebarListItem = .workspace(workspace)
        self.id = self.sidebarListItem.id
    }
    
    init(folder: FolderDB, children: [OutlineNode]) {
        self.sidebarListItem = SidebarListItem.folder(folder)
        self.id = self.sidebarListItem.id
        self.children = children
    }
}
