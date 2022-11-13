import SwiftUI

// WorkspaceCoordinator

private struct WorkspaceCoordinatorKey: EnvironmentKey {
    static let defaultValue = WorkspaceCoordinator.shared
}

// SubscriptionManager

private struct SubscriptionManagerKey: EnvironmentKey {
    static let defaultValue = SubscriptionManager.shared
}

extension EnvironmentValues {
    var workspaceCoordinator: WorkspaceCoordinator {
        get { self[WorkspaceCoordinatorKey.self] }
        set { self[WorkspaceCoordinatorKey.self] = newValue }
    }
    
    var subscriptionManager: SubscriptionManager {
        get { self[SubscriptionManagerKey.self] }
        set { self[SubscriptionManagerKey.self] = newValue }
    }
}
