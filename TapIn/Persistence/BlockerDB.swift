import Foundation
import RealmSwift

final class BlockerDB: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true)
    var id: ObjectId
    
    @Persisted
    var blacklistedWebsites = List<String>()
    
    @Persisted
    var blockerStrength: BlockerStrength = .normal
    
    @Persisted(originProperty: "blocker")
    var workspace: LinkingObjects<WorkspaceDB>
}

enum BlockerStrength: String, PersistableEnum {
    case lenient // can be turned off
    case normal  // can be turned off by closing app
    case extreme // can be turned off by restarting computer
}

