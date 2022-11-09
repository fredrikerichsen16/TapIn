import Foundation
import RealmSwift

class SidebarState: ObservableObject {
    // MARK: Preview
    static var preview: SidebarState = {
        return SidebarState(preview: true)
    }()
        
    init(preview: Bool) {
        let realm = RealmManager.preview.realm
        self.folders = realm.objects(FolderDB.self)
        self.sidebarModel = SidebarModel()
        self.setToken()
    }
    
    // MARK: Normal
    
    var realm: Realm {
        RealmManager.shared.realm
    }
    
    init() {
        let realm = RealmManager.shared.realm
        self.folders = realm.objects(FolderDB.self)
        self.sidebarModel = SidebarModel()
        self.setToken()
    }
    
    // MARK: Sidebar
    
    @Published var folders: Results<FolderDB>
    
    @Published var sidebarModel: SidebarModel = SidebarModel()
    
    // MARK: Token
    
    var token: NotificationToken? = nil

    func setToken() {
        self.token = folders.observe(keyPaths: [\FolderDB.workspaces, \FolderDB.name], { [unowned self] (changes) in
            switch changes
            {
            case .initial(let folders):
                sidebarModel.setOutline(with: folders)
            case .update(_, deletions: _, insertions: _, modifications: _):
                objectWillChange.send()
                sidebarModel.setOutline(with: folders)
            default:
                break
            }
        })
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
    
    func renameFolder(_ folder: FolderDB, name: String) {
        guard let folder = folder.thaw() else { return }

        if name == "" {
            return
        }

        try? realm.write {
            folder.name = name
        }
    }

//    func delete(workspace: WorkspaceDB) {
//        sidebarModel.selection = nil // SidebarListItem.folder(workspace.folder)
//        sidebarModel.outline = []
//
//        let realm = realm.thaw()
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
//            guard let workspace = realm.object(ofType: WorkspaceDB.self, forPrimaryKey: workspace.id) else {
//                return
//            }
//
//            let folder = workspace.folder
//
//            try? realm.write {
//                guard let workspaceIndex = folder.workspaces.firstIndex(of: workspace) else {
//                    return
//                }
//
//                folder.workspaces.remove(at: workspaceIndex)
//
//                realm.delete(workspace)
//            }
//        })
//    }
    
    func delete(workspace: WorkspaceDB) {
        sidebarModel.selection = nil // SidebarListItem.folder(workspace.folder)
        sidebarModel.outline = []
        
        let folder = workspace.folder

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            try? self.realm.write {
                guard let workspaceIndex = folder.workspaces.firstIndex(of: workspace) else {
                    return
                }
                
                folder.workspaces.remove(at: workspaceIndex)
                self.realm.delete(workspace)
            }
        })
    }

    func delete(folder: FolderDB) {
        sidebarModel.selection = nil
        
        do
        {
            try realm.write {
                let workspaces = folder.workspaces
                folder.workspaces.removeAll()
                realm.delete(workspaces)
                folder.isArchived = true
            }
        }
        catch let error as NSError
        {
            fatalError("Error: \(error)")
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
    
    deinit {
        token?.invalidate()
    }
    
}
