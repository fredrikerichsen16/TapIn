import SwiftUI

struct BottomMenuWorkspaceTabController<Content>: View where Content: View {
    let workspaceTab: WorkspaceTab
    let content: Content
    
    init(workspaceTab: WorkspaceTab, @ViewBuilder content: () -> Content) {
        self.workspaceTab = workspaceTab
        self.content = content()
    }
    
    var body: some View {
        VStack {
            Text(workspaceTab.label).font(.body)
            
            content
        }
    }
}
