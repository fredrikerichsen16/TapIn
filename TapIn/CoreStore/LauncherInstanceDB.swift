import Foundation
import RealmSwift

final class LauncherInstanceDB: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true)
    var id: ObjectId
    
    @Persisted
    var type = RealmSwift.List<String>()
    
    @Persisted
    var whitelistedWebsites = RealmSwift.List<String>()
    
    @Persisted(originProperty: "blocker")
    var workspace: LinkingObjects<WorkspaceDB>
}
