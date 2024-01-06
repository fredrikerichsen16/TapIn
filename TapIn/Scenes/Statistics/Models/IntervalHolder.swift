import Foundation

/// This is a data model for the time period (a particular week, month or year) for which data is being shown in the graph. There are also mutating methods for changing the time interval, and some other stuff
struct IntervalHolder {
    // Current y/m/w in the real world
    private let currentYear: Int
    private let currentMonth: Int
    private let currentWeek: Int

    // y/m/w that the user selects - variable
    var year: Int
    var month: Int
    var week: Int
    var granularity: TimeGranularity
    
    private let calendar: Calendar

    init() {
        // Set current y/m/w from current date
        let date = Date()
        let calendar = Calendar.current
        self.currentYear = calendar.component(.year, from: date)
        self.currentMonth = calendar.component(.month, from: date)
        self.currentWeek = calendar.component(.weekOfYear, from: date)

        // Start with current date, and "week" as granularity
        self.year = currentYear
        self.month = currentMonth
        self.week = currentWeek
        self.granularity = .week
        
        self.calendar = calendar
    }

    /// Reduce the year, month, or week by one - taking into account that e.g. going back from "January 2024" becomes "December 2023"
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
    
    /// Increase the year, month, or week by one - taking into account that e.g. going forward from "December 2023" becomes "January 2024"
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

    /// Reset date to current date
    mutating func reset() {
        year = currentYear
        month = currentMonth
        week = currentWeek
    }
    
    /// Readable label for the time period that the graph is showing data for.
    /// E.g. "2023" or "March 2021" or "Week 5, 2023"
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
    
    /// Get the number of days that the current interval contains. For now, just using simplified version
    var numberOfDays: Int {
        switch granularity
        {
        case .year:
            return 365
        case .month:
            return 30
        case .week:
            return 7
        }
    }
}
