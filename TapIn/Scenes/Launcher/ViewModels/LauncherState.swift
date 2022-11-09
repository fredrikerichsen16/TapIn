import Foundation
import RealmSwift

class LauncherState: ObservableObject {
    public var realm: Realm
    private var workspace: WorkspaceDB
    
    init(workspace: WorkspaceDB) {
        self.workspace = workspace
        self.launcher = workspace.launcher
        self.launcherInstances = workspace.launcher.launcherInstances
        self.realm = RealmManager.shared.realm
        self.fetch()
        setToken()
    }
    
    func fetch() {
        var instanceModels: [any BaseLauncherInstanceBehavior] = []
        
        for instance in launcher.launcherInstances
        {
            if let instanceModel = launcherInstanceFactory(instance: instance) {
                instanceModels.append(instanceModel)
            }
        }
        
        self.instances = instanceModels
    }
    
    // MARK: Observing realm
    
    var token: NotificationToken? = nil
    var launcherInstances: List<LauncherInstanceDB>
    func setToken() {
        self.token = launcherInstances.observe(keyPaths: [\LauncherInstanceDB.instantiated, \LauncherInstanceDB.appUrl, \LauncherInstanceDB.fileUrl, \LauncherInstanceDB.name], { [unowned self] (changes) in
            switch changes
            {
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                // Handle deletions
                instances.remove(atOffsets: IndexSet(deletions))
                
                // Handle insertions
                for index in insertions
                {
                    if let instanceModel = launcherInstanceFactory(instance: launcher.launcherInstances[index]) {
                        instances.insert(instanceModel, at: index)
                    }
                }
                
                // Handle modifications
                for index in modifications
                {
                    if let instanceModel = launcherInstanceFactory(instance: launcher.launcherInstances[index]) {
                        instances.remove(at: index)
                        instances.insert(instanceModel, at: index)
                        selectedInstance = instanceModel.id
                    }
                }
            default:
                break
            }
        })
    }
    
    @Published var launcher: LauncherDB
    @Published var instances: [any BaseLauncherInstanceBehavior] = []
    @Published var selectedInstance: ObjectId? = nil
    
    // MARK: Other
    
    func openAll() {
        for instance in instances
        {
            if instance.object.active, let openableInstance = instance as? Openable
            {
                openableInstance.open()
            }
        }
    }
    
    // MARK: CRUD
    
    func deleteInstance(by id: ObjectId) {
        guard
            let launcher = launcher.thaw(),
            let instanceIndex = instances.firstIndex(where: { $0.id == id })
        else { return }
        
        try? realm.write {
            launcher.launcherInstances.remove(at: instanceIndex)
        }
    }
    
    func duplicate(_ instance: any BaseLauncherInstanceBehavior) {
        let newInstance = LauncherInstanceDB(duplicate: instance.object)
        
        try? realm.write {
            launcher.launcherInstances.append(newInstance)
        }
    }
    
    func createEmptyInstance(type: RealmLauncherType) {
        let newInstance = LauncherInstanceDB(empty: type, hideOnLaunch: launcher.hideOnLaunch)
    
        try? realm.write {
            launcher.launcherInstances.append(newInstance)
        }
    }
}
