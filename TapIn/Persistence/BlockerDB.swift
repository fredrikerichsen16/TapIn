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

enum BlockerStrength: String, PersistableEnum {
    case lenient // can be turned off
    case normal  // can be turned off by closing app
    case extreme // can be turned off by restarting computer
    
    var label: String {
        return self.rawValue.capitalized
    }
    
    func getExplanation() -> String {
        switch self
        {
        case .lenient:
            return "Blocker can be deactivated in the app while a work session is in progress."
        case .normal:
            return "Blocker can be deactivated by closing the app or ending the work session."
        case .extreme:
            return "Blocker can only be deactivated by restarting computer."
        }
    }
}

