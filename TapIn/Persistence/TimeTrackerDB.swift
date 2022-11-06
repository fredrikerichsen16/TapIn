import Foundation
import RealmSwift

final class TimeTrackerDB: EmbeddedObject {
    @Persisted
    var trackPomodoroTime: Bool = true
    
    @Persisted(originProperty: "timeTracker")
    var workspace: LinkingObjects<WorkspaceDB>
}
