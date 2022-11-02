import Foundation
import RealmSwift

final class NoteDB: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true)
    var id: ObjectId
    
    @Persisted
    var contents: String = ""
    
    @Persisted(originProperty: "note")
    var workspace: LinkingObjects<WorkspaceDB>
}
