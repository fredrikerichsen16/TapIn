//    func loadData() {
//        let realm = RealmManager.shared.realm
//        let workspaces = Array(realm.objects(WorkspaceDB.self))
//        let subdivisions = getIntervalSubdivisions()
//        var data = [StatisticsData]()
//
//        for (_, subdivision) in subdivisions.enumerated() {
//            let sessionsInInterval = sessions.filter({ session in
//                session.completedTime > subdivision.interval.start && session.completedTime < subdivision.interval.end
//            })
//
//            for workspace in workspaces
//            {
//                let sessionsInWorkspace = sessionsInInterval.filter({ $0.workspace.first?.id == workspace.id })
//                let average = sessionsInWorkspace.reduce(0, { current, session in
//                    current + session.duration
//                })
//
//                // TODO: Need number of days present in IntervalSubdivision to calculate daily average
//
//                data.append(StatisticsData(intervalLabel: subdivision.label, seconds: average, workspace: workspace))
//            }
//        }
//
//        self.data = data
//    }
//
//    func getDataForChart() -> [StatisticsData] {
//        guard let data = data else {
//            return []
//        }
//
//        var result = [StatisticsData]()
//
//        let topLevelWorkspaces = data.filter({ $0.parentWorkspace == nil }).map({ $0.workspace })
//
//        for workspace in topLevelWorkspaces
//        {
//            let dataForWorkspace = data.filter({ $0.workspace == workspace || $0.parentWorkspace == workspace })
//            let average = dataForWorkspace.reduce(0, { $0 + $1.seconds })
//
//            result.append(StatisticsData(intervalLabel: workspace., seconds: <#T##Double#>, workspace: <#T##WorkspaceDB#>))
//        }
//    }


//    func chart() -> [IntervalSubdivision] {
//        let workspaces = Array(WorkspaceDB.getTopLevelWorkspaces())
//        let session = Array(s)
//
//        var subdivisions = getIntervalSubdivisions()
//        var data = [StatisticsData]()
//
//        for (idx, subdivision) in subdivisions.enumerated() {
//            let sessionsInInterval = sessions.filter("completedTime BETWEEN {%@, %@}", subdivision.interval.start, subdivision.interval.end)
//
//            for workspace in workspaces
//            {
//                let sessionsInWorkspace = sessionsInInterval.filter({ $0.isIn(workspace: workspace) })
////                let sessionsInWorkspace = sessionsInInterval.filter({ $0.isIn(workspace: workspace) })
//                let average = Int(sessionsInWorkspace.average(of: \.duration) ?? 0)
//
//                subdivisions[idx].data = average //.append(StatisticsData(averageMinutes: average))
//            }
//        }
//
//        return subdivisions
//    }


//struct SidebarButtonToWorkspace: View {
//    var realm: Realm {
//        RealmManager.shared.realm
//    }
//
//    @EnvironmentObject var stateManager: StateManager
//    @State var menuItem: MenuItem
//
//    var workspace: WorkspaceDB {
//        menuItem.workspace!
//    }
//
//    @State var renameWorkspaceField: String = ""
//    @State var isRenaming = false
//
//    @Namespace var mainNamespace
//
//    var body: some View {
//        if isRenaming
//        {
//            TextField("", text: $renameWorkspaceField) // passing it to bind
//                .textFieldStyle(.roundedBorder) // adds border
//                .prefersDefaultFocus(in: mainNamespace)
//                .onSubmit {
//                    workspace.renameWorkspace(realm, name: renameWorkspaceField)
//                    isRenaming = false
//                }
//        }
//        else
//        {
//            NavigationLink(destination: { WorkspaceBrowseIntermediate(workspace: workspace) }) {
//                Label(menuItem.label, systemImage: menuItem.icon)
//                    .padding(.vertical, 5)
//            }
//            .tag(menuItem.id)
//            .simultaneousGesture(TapGesture().onEnded {
//                stateManager.selectedWorkspace = workspace
////                stateManager.sidebarSelection = menuItem.id
//            })
//            .contextMenu(ContextMenu(menuItems: {
//                contextMenu
//            }))
//        }
//    }
//
////    @ViewBuilder
////    private func viewForMenuItem(_ item: MenuItem) -> some View {
////        switch item
////        {
////        case .workspace(let ws):
////            WorkspaceBrowse(workspace: ws)
////        default:
////            fatalError("18423403")
////        }
////    }
//}




//struct BgView<Content>: View where Content: View {
//    private let bgImage = Image.init(systemName: "m.circle.fill")
//    private let content: Content
//
//    public init(@ViewBuilder content: () -> Content) {
//        self.content = content()
//    }
//
//    var body : some View {
//        ZStack {
//            bgImage
//                .resizable()
//                .opacity(0.2)
//            content
//        }
//    }
//}
