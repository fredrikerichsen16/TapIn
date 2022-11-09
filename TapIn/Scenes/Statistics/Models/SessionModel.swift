import Foundation

struct WorkspaceStatisticsModel: Equatable, Identifiable {
    let id: String
    let name: String
}

struct IntervalSubdivision: Identifiable {
    let id = UUID()
    let label: String
    let interval: DateInterval
    
    var numberOfDays: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: interval.start, to: interval.end)
        
        // weeks have time interval subdivisions of one day which technically (from 00:00 -> 23:59) is 0 days difference, therefore return max(..)
        return max(components.day!, 1)
    }
}

struct ChartData: Identifiable {
    let id = UUID()
    let intervalLabel: String
    let seconds: Double
    let workspace: WorkspaceStatisticsModel
    
    var hours: Double {
        return seconds / 3600
    }
    
    init(intervalLabel: String, seconds: Double, workspace: WorkspaceDB) {
        self.intervalLabel = intervalLabel
        self.seconds = seconds
        self.workspace = WorkspaceStatisticsModel(id: workspace.id.stringValue, name: workspace.name)
    }
}

struct ListData: Identifiable {
    let id = UUID()
    let seconds: Double
    let name: String
    let children: [ListData]?
    
    var formattedDuration: String {
        let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .abbreviated
            formatter.allowedUnits = [.minute, .hour]
        
        return formatter.string(from: seconds)!
    }
    
    init(seconds: Double, name: String, children: [ListData]? = nil) {
        self.seconds = seconds
        self.name = name
        self.children = children
    }
}
