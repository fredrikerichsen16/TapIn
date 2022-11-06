import Foundation
import RealmSwift

final class LauncherDB: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true)
    var id: ObjectId
    
    @Persisted(originProperty: "launcher")
    var workspace: LinkingObjects<WorkspaceDB>
    
    @Persisted
    var launcherInstances = List<LauncherInstanceDB>()
}
