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
    
    func isChild() -> Bool {
        return !parent.isEmpty
    }
    
    // - MARK: CRUD
    
    // MARK: Sessions
    
    /// Number of workspace sessions completed today
    /// - Returns: an int
    func numSessionsCompletedToday() -> Int {
        let startOfDay = Calendar.current.startOfDay(for: Date.init())
        let todayInterval = DateInterval(start: startOfDay, end: startOfDay.advanced(by: 60 * 60 * 24))
        
        let sessionsInInterval = getSessionsInInterval(todayInterval)
        return sessionsInInterval.count
    }
    
    /// Get the amount of minutes worked on a workspace in a certain time interval
    /// - Parameter dateInterval: Time interval
    /// - Returns: Time in minutes
    func getWorkDuration(dateInterval: DateInterval) -> Double {
        let sessionsInInterval = getSessionsInInterval(dateInterval)
        return sessionsInInterval.sum(of: \.duration)
    }
    
    /// Get a Result set of sessions in this workspace that were completed within a certain date interval
    /// - Parameter dateInterval: Date Interval to get results from
    /// - Returns: Result set
    private func getSessionsInInterval(_ dateInterval: DateInterval) -> Results<SessionDB> {
        let startTime = dateInterval.start
        let endTime = dateInterval.end
        
        return sessions.filter("completedTime BETWEEN {%@, %@}", startTime, endTime)
    }
    
    static func getTopLevelWorkspaces() -> Results<WorkspaceDB> {
        let realm = RealmManager.shared.realm
        return realm.objects(WorkspaceDB.self).where({ $0.parent.count == 0 })
    }
    
}
