import Foundation
import RealmSwift

class SidebarVM: ObservableObject {
    
    var realm: Realm {
        RealmManager.shared.realm
    }
    
    init() {
        let realm = RealmManager.shared.realm
        self.workspaces = realm.objects(WorkspaceDB.self)
        self.updateWorkspaceMenuItems()
        self.setToken()
    }
    
    // MARK: General
    
    @Published var selectedWorkspace: WorkspaceDB? = nil
    @Published var activeWorkspace: WorkspaceDB? = nil

    /// I will remporarily use this to refresh the view, but it shouldn't be used because if your viewmodels and stuff are done correctly it's done automatically
    func refresh() {
        objectWillChange.send()
    }
    
    // MARK: Sidebar
    
    @Published var workspaces: Results<WorkspaceDB>
    
    @Published var workspaceMenuItems: [MenuItemNode] = []
    
    @Published var sidebarSelection: String? = MenuItem.home.id
    
    var token: NotificationToken? = nil

    func setToken() {
        self.token = workspaces.observe({ [unowned self] (changes) in
            switch changes
            {
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: _):
                if deletions.count + insertions.count > 0 {
                    objectWillChange.send()
                    self.updateWorkspaceMenuItems()
                }
            default:
                break
            }
        })
    }
    
    func updateWorkspaceMenuItems() {
        let workspaces = Array(workspaces.filter({ $0.parent.isEmpty }))
        
        self.workspaceMenuItems = MenuItemNode.createOutline(workspaces: workspaces)
    }
    
    // MARK: Navigation
    
    func onNavigation(to workspace: WorkspaceDB) {
        selectedWorkspace = workspace
        sidebarSelection = MenuItem.workspace(workspace).id
    }
    
    func navigate(to workspace: WorkspaceDB) {
        selectedWorkspace = workspace
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
    }

    func addChild(to workspace: WorkspaceDB) {
        guard let workspace = workspace.thaw() else { return }

        // You can only nest once, i.e. two levels
        if workspace.isChild() {
            print("Cannot add more than one level of nesting")
            return
        }

        let childWorkspace = WorkspaceDB(name: "New Workspace")

        try? realm.write {
            workspace.children.append(childWorkspace)
        }
    }
    
}
