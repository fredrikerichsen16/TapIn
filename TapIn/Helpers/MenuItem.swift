enum MenuItem {
    case home
    case statistics
    case workspace(WorkspaceDB)
    
    var text: String {
        switch self
        {
            case .home:
                return "Home"
            case .statistics:
                return "Statistics"
            case .workspace(let ws):
                return ws.name
        }
    }
    
    var icon: String {
        switch self
        {
            case .home:
                return "house"
            case .statistics:
                return "chart.pie.fill"
            default:
                return "folder.fill"
        }
    }
    
    var workspace: WorkspaceDB? {
        get {
            switch self {
                case .workspace(let ws):
                    return ws
                default:
                    return nil
            }
        }
    }
    
    static func getMenuItems(workspaces: [WorkspaceDB]) -> [MenuItem] {
        var menuItems = [MenuItem]()
        
        for workspace in workspaces
        {
            menuItems.append(.workspace(workspace))
        }
        
        return menuItems
    }
}

extension MenuItem: Identifiable {
    
    var id: String {
        switch self {
        case .home:
            return "home"
        case .statistics:
            return "statistics"
        case .workspace(let ws):
            return "workspace-\(ws.id)"
        }
    }
    
}
