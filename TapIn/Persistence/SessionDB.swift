import Foundation
import RealmSwift

final class SessionDB: Object, ObjectKeyIdentifiable {
    
    func easyThaw() -> (SessionDB, Realm) {
        guard let thawed = self.thaw(),
              let realm = thawed.realm else { fatalError("Easythaw failed") }
        
        return (thawed, realm)
    }
    
    @Persisted(primaryKey: true)
    var id: ObjectId
    
    @Persisted
    var completedTime: Date
    
    @Persisted
    var duration: Double
    
    @Persisted(originProperty: "sessions")
    var workspace: LinkingObjects<WorkspaceDB>
    
    convenience init(stage: PomodoroStage) {
        self.init()
        self.id = ObjectId.generate()
        self.completedTime = Date.now
        self.duration = stage.getDurationInSeconds()
    }
    
//    convenience init(duration: Double) {
//        self.init()
//        self.id = ObjectId.generate()
//        self.completedTime = Date.now
//        self.duration = duration
//    }
    
    override var description: String {
        return """
        completion time: \(String(describing: completedTime))
        duration: \(String(duration))
        """
    }
    
}
