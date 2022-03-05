import Foundation
import RealmSwift

final class LauncherDB: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true)
    var id: ObjectId
    
    @Persisted(originProperty: "launcher")
    var workspace: LinkingObjects<WorkspaceDB>
    
    @Persisted
    var launcherInstances = RealmSwift.List<LauncherInstanceDB>()
    
    func replaceInstance(_ instance1: LauncherInstanceDB, _ instance2: LauncherInstanceDB) {
        guard let realm = realm else { return }
        
        try! realm.write {
            realm.delete(instance1)
            
            self.launcherInstances.append(instance2)
        }
    }
}
