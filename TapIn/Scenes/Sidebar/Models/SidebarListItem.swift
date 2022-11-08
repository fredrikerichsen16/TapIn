enum SidebarListItem {
    case home
    case statistics
    case workspace(WorkspaceDB)
    case folder(FolderDB)
    
    var label: String {
        switch self
        {
        case .home:
            return "Home"
        case .statistics:
            return "Statistics"
        case .workspace(let workspace):
            return workspace.name
        case .folder(let folder):
            return folder.name
        }
    }
    
    var icon: String {
        switch self
        {
        case .home:
            return IconKeys.house
        case .statistics:
            return IconKeys.piechart
        case .workspace(_):
            return IconKeys.pointRight // ["heart.fill", "bolt.fill", "square.fill", "app.fill", "hand.point.right.fill", "doc.fill", "doc.text.fill"].randomElement()!
        case .folder(_):
            return IconKeys.folder
        }
    }
    
    var workspace: WorkspaceDB? {
        if case .workspace(let workspace) = self {
            return workspace
        }
        
        return nil
    }
    
    var folder: FolderDB? {
        if case .folder(let folder) = self {
            return folder
        }
        
        return nil
    }
}

extension SidebarListItem: Identifiable {
    var id: String {
        switch self
        {
        case .home:
            return "home"
        case .statistics:
            return "statistics"
        case .workspace(let workspace):
            return workspace.id.stringValue
        case .folder(let folder):
            return folder.id.stringValue
        }
    }
}

extension SidebarListItem: Hashable {}
