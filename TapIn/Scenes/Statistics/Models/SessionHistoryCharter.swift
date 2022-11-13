import Foundation

class SessionHistoryCharter {
    var sessions: [SessionDB]
    var workspaces: [WorkspaceDB]
    let interval: IntervalHolder
    let calendar = Calendar.current
    
    init(sessions: [SessionDB], workspaces: [WorkspaceDB], interval: IntervalHolder) {
        self.sessions = sessions
        self.workspaces = workspaces
        self.interval = interval
    }
    
    func chart() -> [ChartData] {
        let subdivisions = getIntervalSubdivisions()
        var data = [ChartData]()

        for (_, subdivision) in subdivisions.enumerated() {
            let sessionsInInterval = sessions.filter({ session in
                session.completedTime > subdivision.interval.start && session.completedTime < subdivision.interval.end && session.workspace.first != nil
            })

            for workspace in workspaces
            {
                let sessionsInWorkspace = sessionsInInterval.filter({ $0.workspace.first == workspace })

                let total = sessionsInWorkspace.reduce(0, { current, session in
                    current + session.duration
                })
                
                let average = total / Double(subdivision.numberOfDays)

                data.append(ChartData(intervalLabel: subdivision.label, seconds: average, workspace: workspace))
            }
        }
        
        // Filter out folders that have insignificant amount of work done
        data = data.filter({ $0.seconds > 120 })

        return data
    }
    
    func list() -> [ListData] {
        // Get folders
        var folders: [FolderDB] = []
        
        for workspace in workspaces
        {
            if let folder = workspace.folder.first {
                folders.append(folder)
            }
        }
        
        folders = Array(Set(folders))
        
        // Get data
        var data: [ListData] = []

        for folder in folders
        {
            var workspacesData: [ListData] = []
            
            for workspace in folder.workspaces
            {
                let sessionsInWorkspace = sessions.filter({ $0.workspace.first == workspace })
                
                let total = sessionsInWorkspace.reduce(0, { current, session in
                    current + session.duration
                })
                
                let average = total / Double(interval.numberOfDays)
                
                workspacesData.append(ListData(seconds: average, name: workspace.name))
            }
            
            let total = workspacesData.reduce(0, { $0 + $1.seconds })
            let average = total / Double(workspacesData.count)
            
            data.append(ListData(seconds: average, name: folder.name, children: workspacesData))
        }

        return data
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
