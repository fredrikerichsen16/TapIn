//
//  SidebarSection.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 10/01/2022.
//

import SwiftUI
import RealmSwift

struct SidebarSection: View {
    @ObservedResults(WorkspaceDB.self) private var workspaces
    
    var work: Bool
    
    var body: some View {
        Section(header: sectionHeaderView()) {
            ForEach(MenuItem.getMenuItems(workspaces: getWorkspacesList()), id: \.id) { menuItem in
                if let ws = menuItem.workspace
                {
                    if ws.children.isEmpty
                    {
                        SidebarButton(menuItem: menuItem)
                    }
                    else
                    {
                        SidebarDisclosure(menuItem: menuItem, workspaces: Array(ws.children))
                    }
                }
            }
        }
        .collapsible(false)
    }
    
    func sectionHeaderView() -> some View {
        let title = work ? "Work" : "Leisure"
        return Text(title).padding(.bottom, 5)
    }
    
    func getWorkspacesList() -> [WorkspaceDB] {
        let workspacesToShow = workspaces.where {
            ($0.isWork == work) && ($0.parent.count == 0)
        }
        
        return Array(workspacesToShow)
    }
}

struct SidebarDisclosure: View {
    var menuItem: MenuItem
    var workspaces: [WorkspaceDB]
    
    @State var isExpanded = false
    
    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded, content: {
            ForEach(MenuItem.getMenuItems(workspaces: workspaces), id: \.id) { item in
                SidebarButton(menuItem: item)
            }
        }, label: {
            SidebarButton(menuItem: menuItem)
        })
    }
}

//struct SidebarSection_Previews: PreviewProvider {
//    static var previews: some View {
//        SidebarSection(work: true)
//    }
//}
