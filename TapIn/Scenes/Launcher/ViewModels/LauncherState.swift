import Foundation
import RealmSwift

class LauncherState: ObservableObject {
    private var workspace: WorkspaceDB
    
    init(workspace: WorkspaceDB) {
        self.workspace = workspace
        self.launcher = workspace.launcher
        self.realm = RealmManager.shared.realm
        self.launcherInstances = Array(launcher.launcherInstances)
        self.setToken()
    }
    
    var realm: Realm
    
    @Published var launcher: LauncherDB
    
    @Published var launcherInstances: [LauncherInstanceDB] = []
    
    var token: NotificationToken? = nil

    func setToken() {
        self.token = launcher.observe({ [unowned self] (changes) in
            switch changes
            {
            case .change(_, _):
                self.launcherInstances = Array(launcher.launcherInstances)
                objectWillChange.send()
            default:
                break
            }
        })
    }
    
    // MARK: Sidebar
    
    func duplicate(launcherInstance: LauncherInstanceDB) {
        guard let launcher = launcher.thaw() else { return }
        
        try? realm.write
        {
            let duplicatedLauncher = LauncherInstanceDB(duplicate: launcherInstance)
            launcher.launcherInstances.append(duplicatedLauncher)
        }
    }
    
    func delete(launcherInstance: LauncherInstanceDB) {
        guard
            let launcher = launcher.thaw(),
            let instanceIndex = launcher.launcherInstances.firstIndex(where: { $0.id == launcherInstance.id })
        else { return }
        
        try? realm.write {
            launcher.launcherInstances.remove(at: instanceIndex)
        }
    }
    
    func deleteInstance(by id: ObjectId) {
        guard
            let launcher = launcher.thaw(),
            let instanceIndex = launcher.launcherInstances.firstIndex(where: { $0.id == id })
        else { return }
        
        try? realm.write {
            launcher.launcherInstances.remove(at: instanceIndex)
        }
    }
    
    // MARK: Popover
    
    func createEmptyInstance(type: RealmLauncherType) {
        let newInstance: LauncherInstanceDB
        
        switch type
        {
        case .website:
            newInstance = LauncherInstanceDB(
                name: "New " + RealmLauncherType.website.label(),
                type: .website,
                instantiated: true,
                appUrl: nil,
                fileUrl: nil,
                launchDelay: 0.0,
                hideOnLaunch: false
            )
        case .app, .file, .folder:
            newInstance = LauncherInstanceDB(
                name: "New " + type.label(),
                type: type,
                instantiated: false
            )
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
