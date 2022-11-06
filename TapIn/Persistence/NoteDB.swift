import Foundation
import RealmSwift

final class NoteDB: EmbeddedObject {
    @Persisted
    var contents: String = ""
    
    @Persisted(originProperty: "note")
    var workspace: LinkingObjects<WorkspaceDB>
}
