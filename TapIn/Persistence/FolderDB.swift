import RealmSwift

// Create a simple Realm model called FolderDB
class FolderDB: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true)
    var id: ObjectId

    @Persisted
    var name: String
    
    @Persisted
    var workspaces: List<WorkspaceDB>

    @Persisted
    var isArchived: Bool

    convenience init(name: String = "New Folder") {
        self.init()
        self.id = ObjectId.generate()
        self.name = name
        self.isArchived = false
    }
}
