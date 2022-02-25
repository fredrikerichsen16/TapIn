import SwiftUI

class StateManager: ObservableObject {
    
    @Published var sidebarSelection: String? = "home"
    
}
