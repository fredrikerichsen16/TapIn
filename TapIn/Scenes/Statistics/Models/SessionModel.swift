import Foundation

struct WorkspaceStatisticsModel: Equatable, Identifiable {
    let id: String
    let name: String
}

//struct WorkspaceStatisticsModel {
//    let id: String
//    let name: String
//
//    init(_ workspace: WorkspaceDB) {
//        self.id = workspace.id.stringValue
//        self.name = workspace.name
//    }
//}
//
//struct SessionStatisticsModel: Identifiable {
//    let id: String
//    let duration: Int // in minutes
//    let completedTime: Date
//    let workspace: WorkspaceStatisticsModel
//    let parentWorkspace: WorkspaceStatisticsModel
//
//    init(_ session: SessionDB) {
//        self.id = session.id.stringValue
//        self.duration = Int(session.duration / 60)
//        self.completedTime = session.completedTime
//
//        let sessionWorkspace = session.workspace.first!
//        let workspace = WorkspaceStatisticsModel(sessionWorkspace)
//        self.workspace = workspace
//
//        if let parent = sessionWorkspace.parent.first
//        {
//            self.parentWorkspace = WorkspaceStatisticsModel(parent)
//        }
//        else
//        {
//            self.parentWorkspace = workspace
//        }
//    }
//}

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
    let workspace: WorkspaceStatisticsModel
    let children: [ListData]?
    
    var formattedDuration: String {
        let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .abbreviated
            formatter.allowedUnits = [.minute, .hour]
        
        return formatter.string(from: seconds)!
    }
    
    init(seconds: Double, workspace: WorkspaceDB, children: [ListData]? = nil) {
        self.seconds = seconds
        self.workspace = WorkspaceStatisticsModel(id: workspace.id.stringValue, name: workspace.name)
        self.children = children
    }
}
