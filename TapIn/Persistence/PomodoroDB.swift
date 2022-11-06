import Foundation
import RealmSwift

final class PomodoroDB: EmbeddedObject {
    @Persisted
    var pomodoroDuration: Int = 25 // in minutes
    
    @Persisted
    var shortBreakDuration: Int = 5 // in minutes
    
    @Persisted
    var longBreakDuration: Int = 15 // in minutes
    
    @Persisted
    var longBreakFrequency: Int = 3
    
    @Persisted(originProperty: "pomodoro")
    var workspace: LinkingObjects<WorkspaceDB>
}
