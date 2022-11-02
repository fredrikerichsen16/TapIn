import Foundation
import RealmSwift

final class LauncherDB: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true)
    var id: ObjectId
    
    @Persisted(originProperty: "launcher")
    var workspace: LinkingObjects<WorkspaceDB>
    
    @Persisted
    var launcherInstances = RealmSwift.List<LauncherInstanceDB>()
    
    var parentLauncherInstances: RealmSwift.List<LauncherInstanceDB>? {
        workspace.first?.parent.first?.launcher.launcherInstances
    }
    
    // MARK: CRUD
    
    func openAll() {
        for launcher in launcherInstances
        {
            launcher.opener.openApp()
        }
    }
    
}
