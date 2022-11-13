import RealmSwift

class RealmObject: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true)
    var id: ObjectId
    
    @Persisted
    var isDeleted = false
}
