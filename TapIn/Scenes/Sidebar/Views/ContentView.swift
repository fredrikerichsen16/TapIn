import SwiftUI
import SwiftUIRouter
import RealmSwift

struct ContentView: View {
    @EnvironmentObject var stateManager: StateManager
    @EnvironmentObject var sidebarVM: SidebarVM
    
    var body: some View {
        Router {
            Sidebar()
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//	static var previews: some View {
//		ContentView()
//	}
//}
