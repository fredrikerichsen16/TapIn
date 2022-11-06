import SwiftUI

// WorkspaceCoordinator

private struct WorkspaceCoordinatorKey: EnvironmentKey {
    static let defaultValue = WorkspaceCoordinator.shared
}

extension EnvironmentValues {
    var workspaceCoordinator: WorkspaceCoordinator {
        get { self[WorkspaceCoordinatorKey.self] }
        set { self[WorkspaceCoordinatorKey.self] = newValue }
    }
}
