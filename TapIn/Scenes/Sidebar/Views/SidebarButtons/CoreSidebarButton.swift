import SwiftUI

struct CoreSidebarButton<Content>: View where Content: View {
    let listItem: SidebarListItem
    let destination: Content
    
    init(listItem: SidebarListItem, @ViewBuilder destination: () -> Content) {
        self.listItem = listItem
        self.destination = destination()
    }
    
    var body: some View {
        NavigationLink(destination: destination) {
            Label(listItem.name, systemImage: listItem.icon)
                .padding(.vertical, 5)
        }
        .tag(listItem)
    }
}
