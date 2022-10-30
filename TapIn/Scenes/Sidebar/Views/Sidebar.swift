import SwiftUI

//struct Park: Identifiable, Hashable {
//    var id = UUID()
//    var name: String
//}

//struct Sidebar: View {
//    @State var presentedParks = [Park(name: "Yosemite")]
//    @State var parks = [Park(name: "Yosemite"), Park(name: "Yukon"), Park(name: "Folgefonna")]
//
//    var body: some View {
//        NavigationStack(path: $presentedParks) {
//            List(parks) { park in
//                NavigationLink(park.name, value: park)
//            }
//            .navigationDestination(for: Park.self) { park in
//                Text(park.name).font(.largeTitle)
//            }
//        }
//    }
//}

enum Route: Hashable {
    case page(MenuItem)
    case workspace(MenuItem)
    case pomodoro
    case timetracker
    case launcher
    case blocker
}

struct Sidebar: View {
    @EnvironmentObject var stateManager: StateManager
    @EnvironmentObject var sidebarVM: SidebarVM
    
    @State var selection: MenuItem? = nil

    var body: some View {
        NavigationSplitView(sidebar: {
            List(sidebarVM.menuItems, selection: $selection) { menuItem in
                NavigationLink(value: menuItem, label: {
                    Label(menuItem.label, systemImage: menuItem.icon)
                })
            }
            .navigationSplitViewStyle(.prominentDetail)
//            .navigationSplitViewColumnWidth(min: 150, ideal: 200, max: 400)
        }, detail: {
            switch selection
            {
            case .workspace(let workspace):
                WorkspaceBrowse()
                    .environmentObject(WorkspaceVM.getCurrent(for: workspace, stateManager: stateManager))
            case .home, .statistics:
                Text(sidebarVM.selection!.label).font(.largeTitle).foregroundColor(.blue)
            case nil:
                EmptyView()
            }
        })
        
//        NavigationSplitView(sidebar: {
//            List(sidebarVM.menuItems, selection: $sidebarVM.selection) { menuItem in
//                NavigationLink(value: menuItem, label: {
//                    Label(menuItem.label, systemImage: menuItem.icon)
//                })
//            }
//            .navigationSplitViewStyle(.prominentDetail)
////            .navigationSplitViewColumnWidth(min: 150, ideal: 200, max: 400)
//        }, detail: {
//            switch sidebarVM.selection
//            {
//            case .workspace(let workspace):
//                WorkspaceBrowse()
//                    .environmentObject(WorkspaceVM.getCurrent(for: workspace, stateManager: stateManager))
//            case .home, .statistics:
//                Text(sidebarVM.selection!.label).font(.largeTitle).foregroundColor(.blue)
//            case nil:
//                EmptyView()
//            }
//        })

//        NavigationView {
//            NavigationStack(path: $path) {
//                List(pages, selection: $selection) { page in
//                    NavigationLink(page.label, value: page)
////                        .tag(page)
//                }
//                .listStyle(SidebarListStyle())
//                .frame(minWidth: 180, maxWidth: 250)
//                .padding(.top)
//
//                List(users) { user in
//                    NavigationLink(user.name, value: user)
////                        .tag(page)
//                }
//            }
//            .navigationTitle("Home")
//            .navigationDestination(for: MenuItem.self) { menuItem in
//                HomeView(menuItem: menuItem)
//            }
//            .navigationDestination(for: User.self) { user in
//                Text(user.name).font(.largeTitle).foregroundColor(.red)
//            }
//        }

//        NavigationView {
//            List(selection: $sidebarVM.sidebarSelection) {
//                Section(header: Text("")) {
//                    SidebarButtonToPage(menuItem: MenuItem.home)
//                    SidebarButtonToPage(menuItem: MenuItem.statistics)
//                }
//
//                Section(header: Text("Workspaces")) {
//                    OutlineGroup(sidebarVM.workspaceMenuItems, children: \.children) { menuItemNode in
//                        SidebarButtonToWorkspace(menuItem: menuItemNode.menuItem)
//                    }
//                }
//                .collapsible(false)
//
//                Spacer()
//
//                Button("Add Workspace", action: {
//                    sidebarVM.addWorkspace()
//                })
//
//                Text(sidebarVM.sidebarSelection ?? "?")
//            }
//            .listStyle(SidebarListStyle())
//            .frame(minWidth: 180, maxWidth: 250)
//            .padding(.top)
//        }
    }

}


//struct HomeView: View {
//    @State var menuItem: MenuItem
//
//    var body: some View {
//        VStack {
//            Text(menuItem.label).font(.largeTitle).foregroundColor(.white)
//            Text(menuItem.icon).font(.subheadline).foregroundColor(.white)
//        }
//    }
//}
//
//struct User: Identifiable, Hashable {
//    var id = UUID()
//    var name: String
//}
//
//struct Sidebar: View {
////    @EnvironmentObject var stateManager: StateManager
////    @EnvironmentObject var sidebarVM: SidebarVM
//
//    @State var path = [MenuItem]()
//
//    @State var pages = [MenuItem.home, MenuItem.statistics]
//
//    @State var selection: MenuItem? = nil
//
//    @State var users = [User(name: "Bob"), User(name: "John")]
//
//    var body: some View {
////        NavigationSplitView(sidebar: {
////            List(pages) { page in
////                SidebarButtonToPage(menuItem: page)
////            }
////        }, detail: {
////
////        })
//
//        NavigationView {
//            NavigationStack(path: $path) {
//                List(pages, selection: $selection) { page in
//                    NavigationLink(page.label, value: page)
////                        .tag(page)
//                }
//                .listStyle(SidebarListStyle())
//                .frame(minWidth: 180, maxWidth: 250)
//                .padding(.top)
//
//                List(users) { user in
//                    NavigationLink(user.name, value: user)
////                        .tag(page)
//                }
//            }
//            .navigationTitle("Home")
//            .navigationDestination(for: MenuItem.self) { menuItem in
//                HomeView(menuItem: menuItem)
//            }
//            .navigationDestination(for: User.self) { user in
//                Text(user.name).font(.largeTitle).foregroundColor(.red)
//            }
//        }
//
////        NavigationView {
////            List(selection: $sidebarVM.sidebarSelection) {
////                Section(header: Text("")) {
////                    SidebarButtonToPage(menuItem: MenuItem.home)
////                    SidebarButtonToPage(menuItem: MenuItem.statistics)
////                }
////
////                Section(header: Text("Workspaces")) {
////                    OutlineGroup(sidebarVM.workspaceMenuItems, children: \.children) { menuItemNode in
////                        SidebarButtonToWorkspace(menuItem: menuItemNode.menuItem)
////                    }
////                }
////                .collapsible(false)
////
////                Spacer()
////
////                Button("Add Workspace", action: {
////                    sidebarVM.addWorkspace()
////                })
////
////                Text(sidebarVM.sidebarSelection ?? "?")
////            }
////            .listStyle(SidebarListStyle())
////            .frame(minWidth: 180, maxWidth: 250)
////            .padding(.top)
////        }
//    }
//
//}
