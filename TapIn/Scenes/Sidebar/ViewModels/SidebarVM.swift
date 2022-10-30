import Foundation
import RealmSwift

class SidebarVM: ObservableObject {
    private var stateManager: StateManager
    
    init(stateManager: StateManager) {
        self.stateManager = stateManager
        let realm = RealmManager.shared.realm
        self.workspaces = realm.objects(WorkspaceDB.self)
        self.updateWorkspaceMenuItems()
        self.setToken()
    }
    
    @Published var workspaces: Results<WorkspaceDB>
    
    @Published var routes: [Route] = []
    
//    @Published var workspaceMenuItems: [MenuItemNode] = []
    
    @Published var menuItems = [MenuItem]()
    
    func updateWorkspaceMenuItems() {
        let workspaces = Array(workspaces.filter({ $0.parent.isEmpty }))
        
        var menuItems = [MenuItem.home, MenuItem.statistics]
        for workspace in workspaces
        {
            menuItems.append(MenuItem.workspace(workspace))
        }
        
        self.menuItems = menuItems
        
//        self.workspaceMenuItems = [MenuItemNode(menuItem: MenuItem.home), MenuItemNode(menuItem: MenuItem.statistics)] + MenuItemNode.createOutline(workspaces: workspaces)
    }
    
    @Published var selection: MenuItem? = nil
    
    @Published var sidebarSelection: String? = MenuItem.home.id //
    
    var token: NotificationToken? = nil

    func setToken() {
        self.token = workspaces.observe({ [unowned self] (changes) in
            switch changes
            {
            case .update(_, deletions: _, insertions: _, modifications: _):
                objectWillChange.send()
                self.updateWorkspaceMenuItems()
            default:
                break
            }
        })
    }
    
    var realm: Realm {
        RealmManager.shared.realm
    }

    func onNavigation(to workspace: WorkspaceDB) {
        stateManager.selectedWorkspace = workspace
        sidebarSelection = MenuItem.workspace(workspace).id
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
        sidebarSelection = MenuItem.home.id
        
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
