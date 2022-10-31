import Foundation
import RealmSwift

class SidebarVM: ObservableObject {
    private var stateManager: StateManager

    init(stateManager: StateManager) {
        self.stateManager = stateManager
    }
    
    var realm: Realm {
        RealmManager.shared.realm
    }

    func onNavigation(to workspace: WorkspaceDB) {
        stateManager.selectedWorkspace = workspace
        stateManager.sidebarSelection = MenuItem.workspace(workspace).id
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
        stateManager.sidebarSelection = MenuItem.home.id

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

        try! realm.write {
            workspace.children.append(childWorkspace)
        }
    }

}
