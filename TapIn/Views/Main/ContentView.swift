import SwiftUI
import SwiftUIRouter
import RealmSwift

struct ContentView: View {
	@Binding var selection: String?
    @EnvironmentObject var stateManager: StateManager

	var body: some View {
		Router {
			NavigationView {
                List(selection: $selection) {
                    SidebarButton(menuItem: MenuItem.home, selection: $selection)
                    SidebarButton(menuItem: MenuItem.statistics, selection: $selection)

                    SidebarSection(work: true, selection: $selection)
                    SidebarSection(work: false, selection: $selection)
				}
				.listStyle(SidebarListStyle())
				.frame(minWidth: 180, maxWidth: 300)
                .padding(.top)
			}
		}
	}
}

//struct ContentView_Previews: PreviewProvider {
//	static var previews: some View {
//		ContentView()
//	}
//}
