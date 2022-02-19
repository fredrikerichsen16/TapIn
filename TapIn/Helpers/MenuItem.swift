enum MenuItem {
    case home
    case statistics
    case work(WorkspaceDB)
    case leisure(WorkspaceDB)
    
    init(workspace: WorkspaceDB, work: Bool) {
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
    
    var workspace: WorkspaceDB? {
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
    
//    static func getMenuItems(work: Bool, workspaces: [WorkspaceDB]) -> [MenuItem] {
//        var menuItems = [MenuItem]()
//
//        for workspace in workspaces
//        {
//            if workspace.isWork == work {
//                menuItems.append(MenuItem.init(workspace: workspace, work: work))
//            }
//        }
//
//        return menuItems
//    }
    
    static func getMenuItems(workspaces: [WorkspaceDB]) -> [MenuItem] {
        var menuItems = [MenuItem]()
        
        for workspace in workspaces
        {
            menuItems.append(MenuItem.init(workspace: workspace, work: workspace.isWork))
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
        case .work(let ws):
            return ws.name + "-work"
        case .leisure(let ws):
            return ws.name + "-leisure"
        }
    }
    
}
