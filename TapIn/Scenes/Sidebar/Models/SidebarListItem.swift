import Foundation
import RealmSwift

struct SidebarListItem: Identifiable, Hashable {
    let id: String
    var name: String
    let icon: String
    var folder: Bool
    var children: [SidebarListItem]?
    
    var objectId: ObjectId? {
        return try? ObjectId(string: id)
    }
    
    init(id: String, name: String, icon: String) {
        self.id = id
        self.name = name
        self.icon = icon
        self.folder = false
        self.children = nil
    }
    
    init(folder: FolderDB, children: [SidebarListItem]? = nil) {
        self.id = folder.id.stringValue
        self.name = folder.name
        self.icon = IconKeys.folder
        self.folder = true
        self.children = children
    }
    
    init(workspace: WorkspaceDB) {
        self.id = workspace.id.stringValue
        self.name = workspace.name
        self.icon = IconKeys.pointRight
        self.folder = false
        self.children = nil
    }
    
    func getFolder() -> FolderDB? {
        guard let id = objectId else { return nil }
        
        return RealmManager.shared.realm.object(ofType: FolderDB.self, forPrimaryKey: id)
    }
    
    func getWorkspace() -> WorkspaceDB? {
        guard let id = objectId else { return nil }
        
        return RealmManager.shared.realm.object(ofType: WorkspaceDB.self, forPrimaryKey: id)
    }
}
