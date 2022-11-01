import Foundation

class TimeTrackerState: ObservableObject {
    private var workspace: WorkspaceDB
    
    init(workspace: WorkspaceDB) {
        self.workspace = workspace
    }
    
    @Published var hoursWorked = 4
}
