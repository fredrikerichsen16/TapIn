import Foundation

struct OutlineNode: Identifiable {
    var id: String
    var menuItem: MenuItem
    var children: [OutlineNode]? = nil
    
    init(workspace: WorkspaceDB) {
        self.menuItem = .workspace(workspace)
        self.id = self.menuItem.id
    }
    
    init(folder: FolderDB, children: [OutlineNode]) {
        self.menuItem = .folder(folder)
        self.id = self.menuItem.id
        self.children = children
    }
}
