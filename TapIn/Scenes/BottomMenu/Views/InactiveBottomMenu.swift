import SwiftUI

struct InactiveBottomMenu: View {
    @EnvironmentObject var sidebar: SidebarVM
    
    var body: some View {
        if let activeWorkspace = sidebar.activeWorkspace
        {
            HStack {
                VStack {
                    Text("Active Workspace: \(activeWorkspace.name)")
                    HStack {
                        Button("Go to", action: {
                            sidebar.navigate(to: activeWorkspace)
                        })
                        Button("Cancel", action: {})
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 6)
            .background(Color(r: 37, g: 37, b: 42, opacity: 1))
        }
        else
        {
            Text("Error")
        }
    }
}
