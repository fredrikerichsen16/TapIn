import Foundation
import RealmSwift

final class WorkspaceDB: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true)
    var id: ObjectId
    
    @Persisted
    var name: String = "New Workspace"
    
    @Persisted
    var children = RealmSwift.List<WorkspaceDB>()
    
    @Persisted(originProperty: "children")
    var parent: LinkingObjects<WorkspaceDB>
    
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
    var sessions = RealmSwift.List<SessionDB>()
        
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
    
    func isTopLevel() -> Bool {
        return parent.isEmpty
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

    static func getTopLevelWorkspaces() -> Results<WorkspaceDB> {
        let realm = RealmManager.shared.realm
        return realm.objects(WorkspaceDB.self).where({ $0.parent.count == 0 })
    }
    
}
