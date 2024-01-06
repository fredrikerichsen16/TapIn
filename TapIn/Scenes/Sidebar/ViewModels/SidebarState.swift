import Foundation
import RealmSwift
import Factory

class SidebarState: ObservableObject {
    // MARK: Properties
    
    @Injected(\.realmManager) var realmManager: RealmManager
    
    @Published var folders: Results<FolderDB>
    
    @Published var pageLinks: [SidebarListItem] = [SidebarListItem(name: "Statistics", icon: IconKeys.piechart)]
    
    @Published var outline = [SidebarListItem]()
    
    @Published var selection: SidebarListItem? = nil
        
    init() {
        let realm = Container.shared.realmManager.callAsFunction().realm
        
        self.folders = realm.objects(FolderDB.self)
        self.setToken()
    }
    
    func setOutline(with folders: [FolderDB]) {
        let listItems = folders
            .map({ folder in
                SidebarListItem(folder: folder, children: folder.workspaces
                    .map({ workspace in
                        SidebarListItem(workspace: workspace)
                    }))
            })
        
        self.outline = listItems
    }
    
    // MARK: Token
    
    var token: NotificationToken? = nil
    
    private func setToken() {
        self.token = folders.observe(keyPaths: [\FolderDB.workspaces], { [unowned self] (changes) in
            switch changes
            {
            case .initial(let folders):
                setOutline(with: Array(folders))
            case .update(let folders, deletions: _, insertions: _, modifications: _):
                setOutline(with: Array(folders))
            default:
                break
            }
        })
    }
    
    // MARK: CRUD Model
    
    func update(_ listItem: SidebarListItem, name: String) {
        for (i, folder) in outline.enumerated()
        {
            if folder.objectId == listItem.objectId {
                outline[i].name = name
                return
            }

            if let children = folder.children
            {
                for (j, workspace) in children.enumerated()
                {
                    if workspace.objectId == listItem.objectId {
                        outline[i].children![j].name = name

                        return
                    }
                }
            }
        }
    }
    
    func selectListItem(by workspace: WorkspaceDB) {
        for folder in outline
        {
            for workspaceListItem in folder.children ?? []
            {
                if workspaceListItem.objectId == workspace.id {
                    selection = workspaceListItem
                }
            }
        }
    }
        
    // MARK: CRUD Realm
    
    func addFolder() {
        let realm = realmManager.realm
        
        try? realm.write {
            let folder = FolderDB(name: "New Folder")
            realm.add(folder)
        }
    }
    
    func rename(_ listItem: SidebarListItem, name: String) {
        let realm = realmManager.realm
        
        update(listItem, name: name)
        
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
        let realm = realmManager.realm
        
        guard listItem.folder == false,
              let workspace = listItem.getWorkspace()
        else { return }

        try? realm.write {
            realm.delete(workspace)
        }
    }

    func delete(folder listItem: SidebarListItem) {
        let realm = realmManager.realm
        
        guard listItem.folder == true,
              let folder = listItem.getFolder()
        else { return }
        
        selection = nil
        
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
        let realm = realmManager.realm
        
        guard listItem.folder == true,
              let folder = listItem.getFolder()
        else { return }
        
        let workspace = WorkspaceDB(name: "New Workspace")

        try? realm.write {
            folder.workspaces.append(workspace)
        }
    }
    
}
