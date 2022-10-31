import Foundation
import RealmSwift

class LauncherState: ObservableObject {
//    private var stateManager: StateManager
    private var workspace: WorkspaceDB
    
    init(workspace: WorkspaceDB, stateManager: StateManager) {
//        self.stateManager = stateManager
        self.workspace = workspace
        self.launcher = workspace.launcher
        self.launcherInstances = Array(launcher.launcherInstances)
        self.setToken()
    }
    
    var realm: Realm {
        RealmManager.shared.realm
    }
    
    @Published var launcher: LauncherDB
    
    @Published var launcherInstances: [LauncherInstanceDB] = []
    
    var token: NotificationToken? = nil

    func setToken() {
        self.token = launcher.observe({ [unowned self] (changes) in
            switch changes
            {
            case .change(_, _):
                objectWillChange.send()
            default:
                break
            }
        })
    }
    
    // MARK: Sidebar
    
    func duplicate(launcherInstance: LauncherInstanceDB) {
        try? realm.write
        {
            let duplicatedLauncher = LauncherInstanceDB(duplicate: launcherInstance)
            realm.add(duplicatedLauncher)
        }
    }
    
    func delete(launcherInstance: LauncherInstanceDB) {
        guard let instance = launcherInstance.thaw() else {
            return
        }
        
        try? realm.write {
            realm.delete(instance)
        }
    }
    
    func deleteInstance(by id: ObjectId) {
        guard let instance = launcher.launcherInstances.first(where: { $0.id == id }) else {
            return
        }
        
        self.delete(launcherInstance: instance)
    }
    
    // MARK: Popover
    
    func createEmptyInstance(type: RealmLauncherType) {
        let newInstance: LauncherInstanceDB
        
        switch type
        {
        case .website:
            newInstance = LauncherInstanceDB(
                name: RealmLauncherType.website.label(),
                type: .website,
                instantiated: true,
                appUrl: nil,
                fileUrl: nil,
                launchDelay: 0.0,
                hideOnLaunch: false
            )
        case .app, .file, .folder:
            newInstance = LauncherInstanceDB(name: type.label(), type: type, instantiated: false)
        default:
            fatalError("Not implemented yet")
        }
        
        guard let launcher = launcher.thaw() else { return }
        
        try? realm.write {
            launcher.launcherInstances.append(newInstance)
        }
    }
    
    func toggleHideOnLaunch(instance: LauncherInstanceDB, value: Bool) {
        let instance = instance.thaw()
        
        try? realm.write {
            instance?.hideOnLaunch = value
        }
    }
}
