import SwiftUI
import SwiftUIRouter
import RealmSwift

struct ContentView: View {
    @EnvironmentObject var stateManager: StateManager
    
    var body: some View {
        Router {
            Sidebar(stateManager: stateManager)
//            Sidebar(vm: SidebarVM(stateManager: stateManager))
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//	static var previews: some View {
//		ContentView()
//	}
//}
