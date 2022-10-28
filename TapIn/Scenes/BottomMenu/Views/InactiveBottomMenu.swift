import SwiftUI

struct InactiveBottomMenu: View {
    @EnvironmentObject var stateManager: StateManager
    
    var body: some View {
        if let activeWorkspace = stateManager.activeWorkspace
        {
            HStack {
                Spacer()
                
                VStack {
                    Text("Active Workspace: \(activeWorkspace.name)")
                    HStack {
                        Button("Go to", action: {
                            stateManager.changeToWorkspace(ws: activeWorkspace)
                        })
                        Button("Cancel", action: {})
                    }
                }
                
                Spacer()
            }
            .padding(EdgeInsets.init(top: 2, leading: 22, bottom: 2, trailing: 22))
            .background(Color(r: 37, g: 37, b: 42, opacity: 1))
        }
        else
        {
            HStack {
                Text("Error")
            }
            .padding(EdgeInsets.init(top: 10, leading: 0, bottom: 10, trailing: 0))
            .background(Color(r: 37, g: 37, b: 42, opacity: 1))
        }
    }
}
