import SwiftUI
import SwiftUIRouter
import RealmSwift

struct ContentView: View {
	@State var selection: String? = "home"

	var body: some View {
		Router {
			NavigationView {
				List(selection: $selection) {
                    SidebarButton(menuItem: MenuItem.home)
                    SidebarButton(menuItem: MenuItem.statistics)

                    SidebarSection(work: true)
                    SidebarSection(work: false)
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
		ContentView()
	}
}
