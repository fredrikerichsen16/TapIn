import Foundation
import RealmSwift

final class SessionDB: EmbeddedObject {
    @Persisted
    var completedTime: Date
    
    @Persisted
    var duration: Double
    
    @Persisted(originProperty: "sessions")
    var workspace: LinkingObjects<WorkspaceDB>
    
    convenience init(stage: PomodoroStage) {
        self.init()
        self.completedTime = Date()
        self.duration = stage.getDurationInSeconds()
    }
    
    override var description: String {
        return """
        completion time: \(String(describing: completedTime))
        duration: \(String(duration))
        """
    }
    
}
