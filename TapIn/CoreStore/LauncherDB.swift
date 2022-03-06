import Foundation
import RealmSwift

final class LauncherDB: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true)
    var id: ObjectId
    
    @Persisted(originProperty: "launcher")
    var workspace: LinkingObjects<WorkspaceDB>
    
    @Persisted
    var launcherInstances = RealmSwift.List<LauncherInstanceDB>()
    
    // MARK: CRUD
    
    func deleteById(id: ObjectId) {
        guard let realm = realm else { return }
        guard let instanceToDelete = realm.objects(LauncherInstanceDB.self).where({ ($0.id == id) }).first else { return }
        
        if let thawed = instanceToDelete.thaw() {
            try! realm.write {
                realm.delete(thawed)
            }
        }
    }
    
    func openAll() {
        for launcher in launcherInstances
        {
            launcher.opener.openApp()
        }
    }
    
}
