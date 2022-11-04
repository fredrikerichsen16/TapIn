import Foundation
import RealmSwift

class SidebarVM: ObservableObject {
    
    var realm: Realm {
        RealmManager.shared.realm
    }
    
    init() {
        let realm = RealmManager.shared.realm
        self.folders = realm.objects(FolderDB.self)
        self.setToken()
        self.sidebarModel = SidebarModel()
        self.sidebarModel.setOutline(with: folders)
    }
    
    // MARK: General
    
    @Published var selectedWorkspace: WorkspaceDB? = nil
    @Published var activeWorkspace: WorkspaceDB? = nil
    
    // MARK: Sidebar
    
    @Published var folders: Results<FolderDB>
    
    @Published var sidebarModel: SidebarModel = SidebarModel()
    
    // MARK: Token
    
    var token: NotificationToken? = nil

    func setToken() {
        self.token = folders.observe({ [unowned self] (changes) in
            switch changes
            {
            case .update(_, deletions: _, insertions: _, modifications: _):
                objectWillChange.send()
                self.sidebarModel.setOutline(with: folders)
            default:
                break
            }
        })
    }
    
    // MARK: Navigation
    
    func onNavigation(to workspace: WorkspaceDB) {
        selectedWorkspace = workspace
        sidebarModel.selection = MenuItem.workspace(workspace)
    }
    
    func onNavigation(to folder: FolderDB) {
        selectedWorkspace = nil
        sidebarModel.selection = MenuItem.folder(folder)
    }
    
    func navigate(to workspace: WorkspaceDB) {
        selectedWorkspace = workspace
        sidebarModel.selection = MenuItem.workspace(workspace)
    }
        
    // MARK: CRUD
    
    func addFolder() {
        try? realm.write {
            let folder = FolderDB(name: "New Folder")
            realm.add(folder)
        }
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
    
    func test() {
        guard let folder = sidebarModel.selection?.folder else {
            return
        }
        
        print("Num workspaces pre deletion: ", folder.workspaces.count, realm.objects(WorkspaceDB.self).count)
    }

    func delete(workspace: WorkspaceDB) {
        sidebarModel.selection = MenuItem.folder(workspace.folder)
    
        guard let folder = workspace.folder.thaw() else {
            return
        }

        try? realm.write {
            guard let workspaceIndex = folder.workspaces.firstIndex(of: workspace) else {
                return
            }

            folder.workspaces.remove(at: workspaceIndex)
        }
    }

    func delete(folder: FolderDB) {
        guard let folder = folder.thaw() else {
            return
        }
        
        sidebarModel.selection = nil
        
        try? realm.write
        {
            realm.delete(folder)
        }
    }

    func addWorkspace(to folder: FolderDB) {
        guard let folder = folder.thaw() else {
            return
        }
        
        let workspace = WorkspaceDB(name: "New Workspace")

        try? realm.write {
            folder.workspaces.append(workspace)
        }
    }
    
}
