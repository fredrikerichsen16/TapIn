import Foundation

struct WorkspaceStatisticsModel {
    let id: String
    let name: String
    
    init(_ workspace: WorkspaceDB) {
        self.id = workspace.id.stringValue
        self.name = workspace.name
    }
}

struct SessionStatisticsModel: Identifiable {
    let id: String
    let duration: Int // in minutes
    let completedTime: Date
    let workspace: WorkspaceStatisticsModel
    let parentWorkspace: WorkspaceStatisticsModel
    
    init(_ session: SessionDB) {
        self.id = session.id.stringValue
        self.duration = Int(session.duration / 60)
        self.completedTime = session.completedTime
        
        let sessionWorkspace = session.getWorkspace()
        let workspace = WorkspaceStatisticsModel(sessionWorkspace)
        self.workspace = workspace
        
        if let parent = sessionWorkspace.parent.first
        {
            self.parentWorkspace = WorkspaceStatisticsModel(parent)
        }
        else
        {
            self.parentWorkspace = workspace
        }
    }
}

struct IntervalSubdivision: Identifiable {
    let id = UUID()
    let label: String
    let interval: DateInterval
}

struct StatisticsData: Identifiable {
    let id = UUID()
    let intervalLabel: String
    let minutes: Int
    let workspace: WorkspaceDB
}
