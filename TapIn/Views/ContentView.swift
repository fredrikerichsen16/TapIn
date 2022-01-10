import SwiftUI
import SwiftUIRouter

struct ContentView: View {
    @ObservedObject var workspaces: Workspaces
	@State var selection: String? = "home"

	var body: some View {
		Router {
			NavigationView {
				List(selection: $selection) {
                    navigationLink(.home)
                    navigationLink(.statistics)
                    
                    Section(header: sectionHeaderView(title: "Work")) {
                        ForEach(workspaces.getTopLevelMenuItems(work: true), id: \.id) { item in
                            topLevelNavigation(item)
                        }
                    }
                    .collapsible(false)
                    
                    Section(header: sectionHeaderView(title: "Leisure")) {
                        ForEach(workspaces.getTopLevelMenuItems(work: false), id: \.id) { item in
                            topLevelNavigation(item)
                        }
                    }
                    .collapsible(false)
				}
				.listStyle(SidebarListStyle())
				.frame(minWidth: 180, maxWidth: 300)
                .padding(.top)
			}
		}
	}
    
    func sectionHeaderView(title: String) -> some View {
        Text(title).padding(.bottom, 5)
    }
    
    @ViewBuilder
    private func topLevelNavigation(_ item: MenuItem) -> some View {
        let ws = item.workspace!
        
        if ws.hasChildren
        {
            DisclosureGroup(isExpanded: ws.$isExpanded, content: {
                ForEach(ws.getChildrenMenuItems(), id: \.id) { item in
                    navigationLink(item)
                }
            }, label: {
                navigationLink(item)
            })
        }
        else
        {
            navigationLink(item)
        }
    }
    
    @ViewBuilder
    private func viewForMenuItem(_ item: MenuItem) -> some View {
        switch item
        {
        case .home:
            Text("Home").font(.largeTitle)
        case .statistics:
            Text("Statistics").font(.largeTitle)
        case .work(let ws):
            WorkspaceBrowse(workspace: ws).onAppear {
                workspaces.activeWorkspace = ws
            }
        case .leisure(let ws):
            WorkspaceBrowse(workspace: ws).onAppear {
                workspaces.activeWorkspace = ws
            }
        }
    }
    
    @ViewBuilder
    private func navigationLink(_ item: MenuItem) -> some View {
        NavigationLink(destination: viewForMenuItem(item)) {
            Label(item.text, systemImage: item.icon)
                .tag(item.id)
                .padding(.vertical, 5)
        }
        .contextMenu(ContextMenu(menuItems: {
            menuItemContextMenu(item.workspace)
        }))
    }
    
    @ViewBuilder
    private func menuItemContextMenu(_ ws: Workspace?) -> some View {
        if let ws = ws
        {
            Group {
                Button("Delete") {
                    print("Delete")
                }
                
                Button("Add Child") {
                    print("Add Child")
                }
                
                Button("Rename") {
                    print("Rename")
                }
            }
        }
        else
        {
            Group {
                Button("Delete") {
                    print("Delete")
                }

                Button("Rename") {
                    print("Rename")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView(workspaces: Workspaces())
	}
}
