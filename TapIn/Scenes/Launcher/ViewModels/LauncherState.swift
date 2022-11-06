import Foundation
import RealmSwift

class LauncherState: ObservableObject {
    private var workspace: WorkspaceDB
    
    init(workspace: WorkspaceDB) {
        self.workspace = workspace
        self.launcher = workspace.launcher
        self.realm = RealmManager.shared.realm
        self.fetch()
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
    
    var realm: Realm
    
    @Published var launcher: LauncherDB
    @Published var instances: [any BaseLauncherInstanceBehavior] = []
    @Published var selectedInstance: UUID? = nil
    
    // MARK: CRUD
    
    func deleteInstance(by id: UUID) {
        guard
            let launcher = launcher.thaw(),
            let instanceIndex = instances.firstIndex(where: { $0.id == id })
        else { return }
        
        instances.remove(at: instanceIndex)
    
        try? realm.write {
            launcher.launcherInstances.remove(at: instanceIndex)
        }
    }
    
    func createEmptyInstance(type: RealmLauncherType) {
        let newInstance = LauncherInstanceDB(empty: type)
    
        guard let launcher = launcher.thaw() else { return }
    
        try? realm.write {
            launcher.launcherInstances.append(newInstance)
        }
        
        if let instanceModel = launcherInstanceFactory(instance: newInstance) {
            instances.append(instanceModel)
        }
    }
}























//func duplicate(launcherInstance: LauncherInstanceDB) {
//    guard let launcher = launcher.thaw() else { return }
//
//    try? realm.write
//    {
//        let duplicatedLauncher = LauncherInstanceDB(duplicate: launcherInstance)
//        launcher.launcherInstances.append(duplicatedLauncher)
//    }
//}
//
//func delete(launcherInstance: LauncherInstanceDB) {
//    guard
//        let launcher = launcher.thaw(),
//        let instanceIndex = launcher.launcherInstances.firstIndex(where: { $0.id == launcherInstance.id })
//    else { return }
//
//    try? realm.write {
//        launcher.launcherInstances.remove(at: instanceIndex)
//    }
//}
//
//func deleteInstance(by id: ObjectId) {
//    guard
//        let launcher = launcher.thaw(),
//        let instanceIndex = launcher.launcherInstances.firstIndex(where: { $0.id == id })
//    else { return }
//
//    try? realm.write {
//        launcher.launcherInstances.remove(at: instanceIndex)
//    }
//}
//
//// MARK: Popover
//
//
//func toggleHideOnLaunch(instance: LauncherInstanceDB, value: Bool) {
//    let instance = instance.thaw()
//
//    try? realm.write {
//        instance?.hideOnLaunch = value
//    }
//}
