import SwiftUI
import SwiftUIRouter
import RealmSwift

struct ContentView: View {
    @EnvironmentObject var stateManager: StateManager

    var body: some View {
        Router {
            NavigationView {
                List(selection: $stateManager.sidebarSelection) {
                    SidebarButton(menuItem: MenuItem.home, selection: $stateManager.sidebarSelection)
                    SidebarButton(menuItem: MenuItem.statistics, selection: $stateManager.sidebarSelection)

                    SidebarSection(selection: $stateManager.sidebarSelection)
                }
                .listStyle(SidebarListStyle())
                .frame(minWidth: 180, maxWidth: 250)
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
