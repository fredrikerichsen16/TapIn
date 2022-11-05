import Foundation
import RealmSwift

final class WorkspaceDB: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true)
    var id: ObjectId
    
    @Persisted
    var name: String = "New Workspace"
    
    @Persisted(originProperty: "workspaces")
    var _folder: LinkingObjects<FolderDB>
    
    var folder: FolderDB {
        _folder.first!
    }
    
    @Persisted
    var pomodoro: PomodoroDB!
    
    @Persisted
    var blocker: BlockerDB!
    
    @Persisted
    var timeTracker: TimeTrackerDB!
    
    @Persisted
    var launcher: LauncherDB!
    
    @Persisted
    var note: NoteDB!
    
    @Persisted
    var sessions = List<SessionDB>()
        
    convenience init(name: String) {
        self.init()
        self.id = ObjectId.generate()
        self.name = name
        
        self.pomodoro = PomodoroDB()
        self.blocker = BlockerDB()
        self.timeTracker = TimeTrackerDB()
        self.launcher = LauncherDB()
        self.note = NoteDB()
    }
    
    // MARK: Sessions
    
    /// Number of workspace sessions completed today
    /// - Returns: an int
    func numSessionsCompletedToday() -> Int {
        let startOfDay = Calendar.current.startOfDay(for: Date.init())
        let todayInterval = DateInterval(start: startOfDay, end: startOfDay.advanced(by: 60 * 60 * 24))
        
        let sessionsToday = sessions.filter("completedTime BETWEEN {%@, %@}", todayInterval.start, todayInterval.end)
        
        return sessionsToday.count
    }
    
}
