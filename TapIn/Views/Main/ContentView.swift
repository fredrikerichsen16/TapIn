import SwiftUI
import SwiftUIRouter

struct ContentView: View {
    @ObservedObject var workspaces: Workspaces
	@State var selection: String? = "home"

	var body: some View {
		Router {
			NavigationView {
				List(selection: $selection) {
                    SidebarButton(menuItem: MenuItem.home)
                    SidebarButton(menuItem: MenuItem.statistics)
                    
                    SidebarSection(workspaces: workspaces, work: true)
                    SidebarSection(workspaces: workspaces, work: false)
				}
				.listStyle(SidebarListStyle())
				.frame(minWidth: 180, maxWidth: 300)
                .padding(.top)
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView(workspaces: Workspaces())
	}
}
