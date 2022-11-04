import Foundation
import RealmSwift

enum TimeGranularity: String {
    case year
    case month
    case week
}

class SessionHistoryQueryer {
    let calendar = Calendar.current
    var sessions: Results<SessionDB>

    init(sessions: Results<SessionDB>? = nil) {
        if let sessions = sessions
        {
            self.sessions = sessions
        }
        else
        {
            let realm = RealmManager.shared.realm
            self.sessions = realm.objects(SessionDB.self)
        }
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
        return SessionHistoryCharter(sessions: Array(sessions), interval: interval)
    }
}

class SessionHistoryCharter {
    var sessions: [SessionDB]
    let interval: IntervalHolder
    let calendar = Calendar.current
    
    init(sessions: [SessionDB], interval: IntervalHolder) {
        self.sessions = sessions
        self.interval = interval
    }
    
    func chart() -> [ChartData] {
        return []
//        let workspaces = Array(WorkspaceDB.getTopLevelWorkspaces())
//        let subdivisions = getIntervalSubdivisions()
//        var data = [ChartData]()
//
//        for (_, subdivision) in subdivisions.enumerated() {
//            let sessionsInInterval = sessions.filter({ session in
//                session.completedTime > subdivision.interval.start && session.completedTime < subdivision.interval.end
//            })
//
//            for workspace in workspaces
//            {
//                let sessionsInWorkspace = sessionsInInterval.filter({ $0.workspace.first == workspace })
//
//                let total = sessionsInWorkspace.reduce(0, { current, session in
//                    current + session.duration
//                })
//                let average = total / Double(subdivision.numberOfDays)
//
//                data.append(ChartData(intervalLabel: subdivision.label, seconds: average, workspace: workspace))
//            }
//        }
//
//        return data
    }
    
    func list() -> [ListData] {
        return []
//        let workspaces = Array(WorkspaceDB.getTopLevelWorkspaces())
//        var data = [ListData]()
//
//        for workspace in workspaces
//        {
//            var childrenListData = [ListData]()
//            for childWorkspace in [workspace] + workspace.children
//            {
//                let sessionsInChildWorkspace = sessions.filter({ $0.workspace.first == childWorkspace })
//
//                let total = sessionsInChildWorkspace.reduce(0, { current, session in
//                    current + session.duration
//                })
//                let average = total / Double(interval.durationInDays)
//
//                childrenListData.append(ListData(seconds: average, workspace: childWorkspace))
//            }
//
//            let total = childrenListData.reduce(0, { current, session in
//                current + session.seconds
//            })
//
//            let average = total / Double(childrenListData.count)
//
//            data.append( ListData(seconds: average, workspace: workspace, children: childrenListData) )
//        }
//
//        return data
    }
    
    func getIntervalSubdivisions() -> [IntervalSubdivision] {
        var intervals = [IntervalSubdivision]()
        
        switch interval.granularity
        {
        case .week:
            let keys = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

            var currentDate = DateComponents(calendar: calendar, weekOfYear: interval.week, yearForWeekOfYear: interval.year).date!
            for i in 0..<7
            {
                let additionToEndOfThisWeek = DateComponents(calendar: calendar, day: 1, second: -1)
                let additionToBeginningOfNextWeek = DateComponents(calendar: calendar, day: 1)

                let endOfWeek = calendar.date(byAdding: additionToEndOfThisWeek, to: currentDate)
                let subdivisionInterval = DateInterval(start: currentDate, end: endOfWeek!)
                currentDate = calendar.date(byAdding: additionToBeginningOfNextWeek, to: currentDate)!

                intervals.append(IntervalSubdivision(label: keys[i], interval: subdivisionInterval))
            }
        case .month:
            var currentDate = DateComponents(calendar: calendar, year: interval.year, month: interval.month, day: 1).date!
            var intervalStart = currentDate

            let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d"

            while calendar.component(.month, from: currentDate) == interval.month
            {
                let addition = DateComponents(calendar: calendar, day: 1)
                currentDate = calendar.date(byAdding: addition, to: currentDate)!

                let isSunday = calendar.component(.weekday, from: currentDate) == 1
                let isLastDayOfMonth = calendar.component(.day, from: currentDate) == calendar.range(of: .day, in: .month, for: currentDate)!.count - 1
                if isSunday || isLastDayOfMonth
                {
                    let intervalEnd = calendar.date(byAdding: DateComponents(calendar: calendar, day: 1, second: -1), to: currentDate)!

                    let key = dateFormatter.string(from: intervalStart) + " - " + dateFormatter.string(from: intervalEnd)
                    let subdivisionInterval = DateInterval(start: intervalStart, end: intervalEnd)
                    intervals.append(IntervalSubdivision(label: key, interval: subdivisionInterval))

                    intervalStart = calendar.date(byAdding: DateComponents(calendar: calendar, second: 1), to: intervalEnd)!
                }
            }
        case .year:
            let keys = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

            for i in 0..<12
            {
                let beginningOfMonth = DateComponents(calendar: calendar, year: interval.year, month: i + 1, day: 1).date!
                let endOfMonth = DateComponents(
                    calendar: calendar,
                    year: interval.year,
                    month: i + 1,
                    day: calendar.range(of: .day, in: .month, for: beginningOfMonth)!.count,
                    hour: 23,
                    minute: 59,
                    second: 59
                ).date!
                
                let subdivisionInterval = DateInterval(start: beginningOfMonth, end: endOfMonth)

                intervals.append(IntervalSubdivision(label: keys[i], interval: subdivisionInterval))
            }
        }

        return intervals
    }
}
