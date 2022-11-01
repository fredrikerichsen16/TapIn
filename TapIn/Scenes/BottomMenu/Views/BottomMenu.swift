import SwiftUI

struct BottomMenu: View {
    @EnvironmentObject var workspace: WorkspaceVM
    
    let height: CGFloat = 80.0
    
    var body: some View {
        if WorkspaceVM.shouldShowActiveBottomMenu(for: workspace.workspace)
        {
            ActiveBottomMenu()
                .frame(maxWidth: .infinity, minHeight: height, idealHeight: height, maxHeight: height, alignment: .center)
                .background(Color(r: 37, g: 37, b: 42, opacity: 1))
        }
        else
        {
            InactiveBottomMenu()
                .frame(maxWidth: .infinity, minHeight: height, idealHeight: height, maxHeight: height, alignment: .center)
                .background(Color(r: 37, g: 37, b: 42, opacity: 1))
        }
    }
}
