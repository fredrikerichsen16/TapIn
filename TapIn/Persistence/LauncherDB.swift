import Foundation
import RealmSwift

final class LauncherDB: EmbeddedObject {
    @Persisted(originProperty: "launcher")
    var workspace: LinkingObjects<WorkspaceDB>
    
    @Persisted
    var launcherInstances = List<LauncherInstanceDB>()
    
    // Default setting
    @Persisted
    var hideOnLaunch = false
}
