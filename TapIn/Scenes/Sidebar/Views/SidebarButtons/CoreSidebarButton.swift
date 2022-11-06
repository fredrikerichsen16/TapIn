import SwiftUI

struct CoreSidebarButton<Content>: View where Content: View {
    let sidebarListItem: SidebarListItem
    let destination: Content
    
    init(sidebarListItem: SidebarListItem, @ViewBuilder destination: () -> Content) {
        self.sidebarListItem = sidebarListItem
        self.destination = destination()
    }
    
    var body: some View {
        NavigationLink(destination: destination) {
            Label(sidebarListItem.label, systemImage: sidebarListItem.icon)
                .padding(.vertical, 5)
        }
        .tag(sidebarListItem)
    }
}
