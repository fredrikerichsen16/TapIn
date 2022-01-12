//
//  SidebarButton.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 10/01/2022.
//

import SwiftUI

struct SidebarButton: View {
    @State var menuItem: MenuItem
    
    var body: some View {
        NavigationLink(destination: viewForMenuItem(menuItem)) {
            Label(menuItem.text, systemImage: menuItem.icon)
                .tag(menuItem.id)
                .padding(.vertical, 5)
        }
        .contextMenu(ContextMenu(menuItems: {
            menuItemContextMenu(menuItem.workspace)
        }))
    }
    
    @ViewBuilder
    private func viewForMenuItem(_ item: MenuItem) -> some View {
        switch item
        {
        case .home, .statistics:
            Text(item.text).font(.largeTitle)
        case .work(let ws):
            WorkspaceBrowse(workspace: ws)
        case .leisure(let ws):
            WorkspaceBrowse(workspace: ws)
        }
    }
    
    @ViewBuilder
    private func menuItemContextMenu(_ ws: Workspace?) -> some View {
        if ws != nil
        {
            Group {
                Button("Delete") {
                    print("Delete")
                }
                
                Button("Add Child") {
                    print("Add Child")
                }
                
                Button("Rename") {
                    print("Rename")
                }
            }
        }
        else
        {
            Group {
                Button("Delete") {
                    print("Delete")
                }

                Button("Rename") {
                    print("Rename")
                }
            }
        }
    }

}

struct SidebarButton_Previews: PreviewProvider {
    static var previews: some View {
        SidebarButton(menuItem: .statistics)
    }
}
