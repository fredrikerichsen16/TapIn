import Foundation
import RealmSwift

struct IntervalHolder {
    private let currentYear: Int
    private let currentMonth: Int
    private let currentWeek: Int

    var year: Int
    var month: Int
    var week: Int
    var granularity: TimeGranularity

    init() {
        let date = Date()
        let calendar = Calendar.current
        self.currentYear = calendar.component(.year, from: date)
        self.currentMonth = calendar.component(.month, from: date)
        self.currentWeek = calendar.component(.weekOfYear, from: date)

        self.year = currentYear
        self.month = currentMonth
        self.week = currentWeek
        self.granularity = .week
    }

    mutating func reduceUnit() {
        switch granularity
        {
        case .year:
            if year > 2020 {
                self.year -= 1
            }
        case .month:
            self.month -= 1

            if month == 0 {
                self.month = 12
                self.year -= 1
            }
        case .week:
            self.week -= 1

            if week == 0 {
                self.week = 52
                self.year -= 1
            }
        }
    }

    mutating func increaseUnit() {
        switch granularity
        {
        case .year:
            if year < currentYear {
                self.year += 1
            }
        case .month:
            self.month += 1

            if month == 13 {
                self.month = 1
                self.year += 1
            }
        case .week:
            self.week += 1

            if week == 53 {
                self.week = 1
                self.year += 1
            }
        }
    }

    mutating func reset() {
        year = currentYear
        month = currentMonth
        week = currentWeek
    }
    
    var label: String {
        switch granularity
        {
        case .year:
            return "\(year)"
        case .month:
            // Return month name followed by year
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM"
            let monthName = dateFormatter.string(from: DateComponents(calendar: Calendar.current, year: year, month: month).date!)
            return "\(monthName) \(year)"
        case .week:
            return "Week \(week), \(year)"
        }
    }
}

class StatisticsState: ObservableObject {
    @Published var workspaces: Results<WorkspaceDB>
    
    var realm: Realm {
        RealmManager.shared.realm
    }

    init() {
        let realm = RealmManager.shared.realm
        self.workspaces = realm.objects(WorkspaceDB.self)
    }

    // MARK: Dates
    @Published var interval = IntervalHolder()

    func reduceUnit() {
        interval.reduceUnit()
        submit()
    }

    func increaseUnit() {
        interval.increaseUnit()
        submit()
    }
    
    func resetToNow() {
        interval.reset()
        submit()
    }

    func submit() {
        // Query
        let queryer = SessionHistoryQueryer()
            queryer.completed(within: interval)
        
        // Get Results
        let numSessions = queryer.getNumSessionsCompleted()
        let workDuration = queryer.getWorkDurationFormatted()
        
        self.numSessions = numSessions
        self.workDuration = workDuration
        
        let charter = queryer.getCharter(for: interval)
        let data = charter.chart()
        
        self.sessionData = data
    }
    
    @Published var numSessions = 0
    @Published var workDuration = ""
    @Published var sessionData = [StatisticsData]()
}
