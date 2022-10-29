import Foundation
import RealmSwift

//@Published var workspaces: Results<WorkspaceDB>
//
//init() {
//    let realm = RealmManager.shared.realm
//    self.workspaces = realm.objects(WorkspaceDB.self)
//
//    self.token = workspaces.observe({ [unowned self] (changes) in
//        switch changes
//        {
//        case .update(_, deletions: _, insertions: _, modifications: _):
////                self.workspaces = realm.objects(WorkspaceDB.self)
//            objectWillChange.send()
//        default:
//            break
//        }
//    })
//}
//
//var token: NotificationToken? = nil

class SidebarVM: ObservableObject {
    var stateManager: StateManager
    
    init(stateManager: StateManager) {
        self.stateManager = stateManager
    }
    
    var realm: Realm {
        RealmManager.shared.realm
    }
    
    var workspaceMenuItems: [MenuItemNode] {
        stateManager.sidebarModel.menuItems
    }

    func onNavigation(to workspace: WorkspaceDB) {
        stateManager.selectedWorkspace = workspace
        stateManager.sidebarModel.selection = MenuItem.workspace(workspace).id
    }
    
    // MARK: CRUD
    
    func addWorkspace() {
        try? realm.write({
            let ws = WorkspaceDB(name: "New Workspace")

            realm.add(ws)
        })
    }
    
    func renameWorkspace(_ workspace: WorkspaceDB, name: String) {
        guard let workspace = workspace.thaw() else { return }
        
        if name == "" {
            return
        }

        try? realm.write {
            workspace.name = name
        }
    }
    
    func deleteWorkspace(_ workspace: WorkspaceDB) {
        stateManager.sidebarModel.selection = MenuItem.home.id
        
        guard let thawed = workspace.thaw() else { return }
        
        try! realm.write {
            realm.delete(thawed)
        }
        
        objectWillChange.send()
    }
    
    func addChild(to workspace: WorkspaceDB) {
        guard let workspace = workspace.thaw() else { return }
        
        // You can only nest once, i.e. two levels
        if workspace.isChild() {
            print("Cannot add more than one level of nesting")
            return
        }
        
        let childWorkspace = WorkspaceDB(name: "New Workspace")
        
        try! realm.write {
            workspace.children.append(childWorkspace)
        }
    }
    
}
