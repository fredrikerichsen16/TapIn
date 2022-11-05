import Foundation
import SwiftUI

class WorkspaceCoordinator {
    static let shared = WorkspaceCoordinator()
    private var currentWorkspace: WorkspaceVM? = nil
    
    private init() {}
    
    func getWorkspaceVM(for workspace: WorkspaceDB) -> WorkspaceVM {
        if let current = currentWorkspace, current.workspace == workspace
        {
            return current
        }

        return WorkspaceVM(workspace: workspace)
    }
    
    func getActiveWorkspace() -> WorkspaceVM? {
        return currentWorkspace
    }
    
    /// A different workspace is active than the workspace passed as an argument (used to e.g. disallow some actions in the UI)
    func otherWorkspaceIsActive(than workspace: WorkspaceDB) -> Bool {
        if let current = currentWorkspace
        {
            return current.workspace != workspace
        }
        
        return false
    }
    
    func setActive(workspace: WorkspaceVM) {
        self.currentWorkspace = workspace
    }
    
    func disactivate() {
        self.currentWorkspace = nil
    }
}

private struct WorkspaceCoordinatorKey: EnvironmentKey {
    static let defaultValue = WorkspaceCoordinator.shared
}

extension EnvironmentValues {
    var workspaceCoordinator: WorkspaceCoordinator {
        get { self[WorkspaceCoordinatorKey.self] }
        set { self[WorkspaceCoordinatorKey.self] = newValue }
    }
}
