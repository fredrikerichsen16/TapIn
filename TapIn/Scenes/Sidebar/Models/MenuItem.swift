enum MenuItem {
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
            return "house"
        case .statistics:
            return "chart.pie.fill"
        case .workspace(_):
            return "hand.point.right.fill" // ["heart.fill", "bolt.fill", "square.fill", "app.fill", "hand.point.right.fill", "doc.fill", "doc.text.fill"].randomElement()!
        case .folder(_):
            return "folder.fill"
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

extension MenuItem: Identifiable {
    
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

extension MenuItem: Hashable {}
