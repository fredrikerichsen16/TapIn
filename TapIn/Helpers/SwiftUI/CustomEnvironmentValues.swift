import SwiftUI

// WorkspaceCoordinator

private struct WorkspaceCoordinatorKey: EnvironmentKey {
    static let defaultValue = WorkspaceCoordinator.shared
}

// SubscriptionManager

private struct SubscriptionManagerKey: EnvironmentKey {
    static let defaultValue = SubscriptionManager.shared
}

// ListItem

private struct ListItemKey: EnvironmentKey {
    static let defaultValue: SidebarListItem = SidebarListItem(name: "", icon: "")
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
    
    var listItem: SidebarListItem {
        get { self[ListItemKey.self] }
        set { self[ListItemKey.self] = newValue }
    }
}
