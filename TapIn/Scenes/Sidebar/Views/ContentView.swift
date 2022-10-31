import SwiftUI
import SwiftUIRouter
import RealmSwift

struct ContentView: View {
    @EnvironmentObject var stateManager: StateManager
    
    var body: some View {
        Sidebar(stateManager: stateManager)
    }
}

//struct ContentView_Previews: PreviewProvider {
//	static var previews: some View {
//		ContentView()
//	}
//}
