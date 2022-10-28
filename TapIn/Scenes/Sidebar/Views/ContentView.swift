import SwiftUI
import SwiftUIRouter
import RealmSwift

struct ContentView: View {
    @EnvironmentObject var stateManager: StateManager

    var body: some View {
        Router {
            NavigationView {
                List(selection: $stateManager.sidebarSelection) {
                    SidebarButtonToPage(menuItem: MenuItem.home)
                    SidebarButtonToPage(menuItem: MenuItem.statistics)

                    SidebarWorkspacesSection(stateManager: stateManager)
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
