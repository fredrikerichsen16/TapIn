import Foundation
import SwiftUI

class WorkspaceCoordinator {
    static let shared = WorkspaceCoordinator()
    private var currentWorkspace: WorkspaceState? = nil
    
    private init() {}
    
    func getWorkspaceVM(for workspace: WorkspaceDB) -> WorkspaceState {
        if let current = currentWorkspace, current.workspace == workspace
        {
            return current
        }

        return WorkspaceState(workspace: workspace)
    }
    
    func getActiveWorkspace() -> WorkspaceState? {
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
    
    func setActive(workspace: WorkspaceState) {
        self.currentWorkspace = workspace
    }
    
    func disactivate() {
        self.currentWorkspace = nil
    }
    
    /// App was terminated
    func terminate() {
        guard let workspace = currentWorkspace else {
            return
        }
        
        let isActive = workspace.blocker.isActive
        let blockerStrength = workspace.blocker.blocker.blockerStrength
        if isActive && blockerStrength < BlockerStrength.extreme {
            ContentBlocker.shared.stop()
        }
    }
}
