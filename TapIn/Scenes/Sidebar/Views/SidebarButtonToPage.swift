import SwiftUI
import RealmSwift


struct SidebarButtonToPage: View {
    @State var menuItem: MenuItem

    var body: some View {
        NavigationLink(destination: { viewForMenuItem(menuItem) }) {
            Label(menuItem.label, systemImage: menuItem.icon)
        }
        .tag(menuItem)
    }

    @ViewBuilder
    private func viewForMenuItem(_ item: MenuItem) -> some View {
        switch item
        {
        case .home:
            Text(item.label).font(.largeTitle)
        case .statistics:
            StatisticsView()
        default:
            fatalError("1493403")
        }
    }
}

struct SidebarButtonToPage_Previews: PreviewProvider {
    static var previews: some View {
        SidebarButtonToPage(menuItem: .statistics)
    }
}






