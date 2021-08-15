enum MenuItem {
    case home
    case statistics
    case work(Workspace)
    case leisure(Workspace)
    
    init(workspace: Workspace, work: Bool) {
        if work
        {
            self = .work(workspace)
        }
        else
        {
            self = .leisure(workspace)
        }
    }
    
    var text: String {
        switch self
        {
            case .home:
                return "Home"
            case .statistics:
                return "Statistics"
            case .work(let ws):
                return ws.name
            case .leisure(let ws):
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
    
    var workspace: Workspace? {
        get {
            switch self {
                case .work(let ws):
                    return ws
                case .leisure(let ws):
                    return ws
                default:
                    return nil
            }
        }
    }
}

extension MenuItem: Identifiable {
    
    var id: String {
        switch self {
        case .home:
            return "home"
        case .statistics:
            return "statistics"
        case .work(let ws):
            return ws.name + "-work"
        case .leisure(let ws):
            return ws.name + "-leisure"
        }
    }
    
}
