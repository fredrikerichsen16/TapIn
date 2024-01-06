import Foundation
import RealmSwift
import Factory

struct SidebarListItem: Hashable {
    var objectId: ObjectId?
    var name: String
    let icon: String
    var folder: Bool
    var expanded: Bool = false
    var children: [SidebarListItem]?
    
    init(name: String, icon: String) {
        self.objectId = nil
        self.name = name
        self.icon = icon
        self.folder = false
        self.children = nil
    }
    
    init(folder: FolderDB, children: [SidebarListItem]? = nil) {
        self.objectId = folder.id
        self.name = folder.name
        self.icon = IconKeys.folder
        self.folder = true
        self.children = children
    }
    
    init(workspace: WorkspaceDB) {
        self.objectId = workspace.id
        self.name = workspace.name
        self.icon = IconKeys.pointRight
        self.folder = false
        self.children = nil
    }
    
    func getFolder() -> FolderDB? {
        guard let id = objectId else { return nil }
        
        let realm = Container.realm.callAsFunction()
        return realm.object(ofType: FolderDB.self, forPrimaryKey: id)
    }
    
    func getWorkspace() -> WorkspaceDB? {
        guard let id = objectId else { return nil }
        
        let realm = Container.realm.callAsFunction()
        return realm.object(ofType: WorkspaceDB.self, forPrimaryKey: id)
    }
}
