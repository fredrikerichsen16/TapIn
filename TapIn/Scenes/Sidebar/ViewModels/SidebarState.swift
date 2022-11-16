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
    
    // MARK: Properties
    
    var realm: Realm {
        RealmManager.shared.realm
    }
    
    @Published var folders: Results<FolderDB>
    
    @Published var sidebarModel: SidebarModel = SidebarModel()
    
    // MARK: Init
    
    init() {
        let realm = RealmManager.shared.realm
        self.folders = realm.objects(FolderDB.self)
        self.sidebarModel = SidebarModel()
        self.setToken()
    }
    
    // MARK: Token
    
    var token: NotificationToken? = nil
    
    private func setToken() {
        self.token = folders.observe(keyPaths: [\FolderDB.workspaces], { [unowned self] (changes) in
            switch changes
            {
            case .initial(let folders):
                sidebarModel.setOutline(with: Array(folders))
            case .update(let folders, deletions: _, insertions: _, modifications: _):
                sidebarModel.setOutline(with: Array(folders))
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
    
    func rename(_ listItem: SidebarListItem, name: String) {
        sidebarModel.update(listItem, name: name)
        
        if let folder = listItem.getFolder()?.thaw()
        {
            try? realm.write {
                folder.name = name
            }
        }
        else if let workspace = listItem.getWorkspace()?.thaw()
        {
            try? realm.write {
                workspace.name = name
            }
        }
    }

    func delete(workspace listItem: SidebarListItem) {
        guard listItem.folder == false,
              let workspace = listItem.getWorkspace()
        else { return }

        try? realm.write {
            realm.delete(workspace)
        }
    }

    func delete(folder listItem: SidebarListItem) {
        guard listItem.folder == true,
              let folder = listItem.getFolder()
        else { return }
        
        sidebarModel.selection = nil
        
        try? realm.write
        {
            for workspace in folder.workspaces
            {
                realm.delete(workspace)
            }
            
            realm.delete(folder)
        }
    }

    func addWorkspace(toFolder listItem: SidebarListItem) {
        guard listItem.folder == true,
              let folder = listItem.getFolder()
        else { return }
        
        let workspace = WorkspaceDB(name: "New Workspace")

        try? realm.write {
            folder.workspaces.append(workspace)
        }
    }
    
}
