import Foundation
import RealmSwift

enum PomodoroStageRealm: String, Equatable, PersistableEnum {
    case pomodoro
    case shortBreak
    case longBreak
}

final class SessionDB: Object, ObjectKeyIdentifiable {
    
    func easyThaw() -> (SessionDB, Realm) {
        guard let thawed = self.thaw(),
              let realm = thawed.realm else { fatalError("Easythaw failed") }
        
        return (thawed, realm)
    }
    
    @Persisted(primaryKey: true)
    var id: ObjectId
    
    @Persisted
    var completedTime: Date?
    
    @Persisted
    var stage: PomodoroStageRealm
    
    @Persisted
    var duration: Double
    
    @Persisted(originProperty: "sessions")
    var workspace: LinkingObjects<WorkspaceDB>
    
    convenience init(stage: PomodoroStageRealm, duration: Double) {
        self.init()
        self.id = ObjectId.generate()
        self.stage = stage
        self.duration = duration
    }
    
}
