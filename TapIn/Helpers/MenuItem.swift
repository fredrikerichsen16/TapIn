enum MenuItem {
    case home
    case statistics
    case workspace(WorkspaceDB)
    
    var label: String {
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
        get
        {
            switch self
            {
            case .workspace(let ws):
                return ws
            default:
                return nil
            }
        }
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
        case .workspace(let ws):
            return "workspace-\(ws.id)"
        }
    }
    
}

extension MenuItem: Hashable {
    
}
