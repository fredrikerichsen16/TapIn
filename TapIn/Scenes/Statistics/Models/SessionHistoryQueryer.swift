import Foundation
import RealmSwift

class SessionHistoryQueryer {
    let calendar = Calendar.current
    var sessions: Results<SessionDB>
    var workspaces: Results<WorkspaceDB>

    init(realm: Realm) {
        self.sessions = realm.objects(SessionDB.self)
        self.workspaces = realm.objects(WorkspaceDB.self)
    }

    // MARK: Date filtering
    
    private func getDateInterval(year: Int, month: Int? = nil, week: Int? = nil) -> DateInterval {
        if let week = week
        {
            let startDate = DateComponents(calendar: calendar, weekOfYear: week, yearForWeekOfYear: year).date!
            let addition = DateComponents(calendar: calendar, day: 7, minute: -1)
            let endDate = calendar.date(byAdding: addition, to: startDate)!

            return DateInterval(start: startDate, end: endDate)
        }
        else if let month = month
        {
            let startDate = DateComponents(calendar: calendar, year: year, month: month).date!
            let addition = DateComponents(calendar: calendar, month: 1, second: -1)
            let endDate = calendar.date(byAdding: addition, to: startDate)!

            return DateInterval(start: startDate, end: endDate)
        }
        else
        {
            let startDate = DateComponents(calendar: calendar, year: year, month: 1, day: 1).date!
            let endDate = DateComponents(calendar: calendar, year: year, month: 12, day: 31, hour: 23, minute: 59).date!
            return DateInterval(start: startDate, end: endDate)
        }
    }
    
    func completed(within interval: IntervalHolder) {
        let year = interval.year
        let month = interval.granularity == .month ? interval.month : nil
        let week = interval.granularity == .week ? interval.week : nil
        
        let interval = self.getDateInterval(year: year, month: month, week: week)
        
        self.sessions = sessions.filter("completedTime BETWEEN {%@, %@}", interval.start, interval.end)
    }
    
    func completedThisWeek() {
        var interval = IntervalHolder()
            interval.granularity = .week
        
        completed(within: interval)
    }
    
    // MARK: Workspace Filtering
    
    func inWorkspace(workspace: WorkspaceDB) {
        self.sessions = sessions.where({ session in
            session.workspace == workspace
        })
    }
    
    // MARK: Getting results
    
    func getNumSessionsCompleted() -> Int {
        return self.sessions.count
    }
    
    func getWorkDuration() -> Double {
        return self.sessions.sum(of: \.duration)
    }
    
    func getWorkDurationFormatted() -> String {
        let workDurationInSeconds = getWorkDuration()
        
        let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .full // .abbreviated
            formatter.allowedUnits = [.minute, .hour]
        
        return formatter.string(from: workDurationInSeconds)!
    }
    
    func getSessions() -> [SessionDB] {
        return Array(sessions)
    }
    
    func getCharter(for interval: IntervalHolder) -> SessionHistoryCharter {
        return SessionHistoryCharter(sessions: Array(sessions), workspaces: Array(workspaces), interval: interval)
    }
}
