import Foundation
import RealmSwift

final class BlockerDB: EmbeddedObject {
    @Persisted
    var blacklistedWebsites = List<String>()
    
    @Persisted
    var blockerStrength: BlockerStrength = .normal
    
    @Persisted(originProperty: "blocker")
    var workspace: LinkingObjects<WorkspaceDB>
}

enum BlockerStrength: Int, Comparable, PersistableEnum {
    case lenient // can be turned off any time
    case normal  // can be turned off by closing app
    case extreme // can be turned off by restarting computer
    
    var label: String {
        switch self
        {
        case .lenient:
            return "Lenient"
        case .normal:
            return "Normal"
        case .extreme:
            return "Extreme"
        }
    }
    
    func getExplanation() -> String {
        switch self
        {
        case .lenient:
            return "Blocker can be deactivated in the app while a work session is in progress."
        case .normal:
            return "Blocker can be deactivated by closing the app or ending the work session prematurely."
        case .extreme:
            return "Blocker cannot be deactivated (even by restarting computer) until session is completed (or, in the event that you close the app, that much time has elapsed)"
        }
    }
}

