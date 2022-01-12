//
//  SidebarSection.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 10/01/2022.
//

import SwiftUI

struct SidebarSection: View {
    @ObservedObject var workspaces: Workspaces
    @State var work: Bool
    
    var body: some View {
        Section(header: sectionHeaderView()) {
            ForEach(workspaces.getTopLevelMenuItems(work: work), id: \.id) { item in
                if item.workspace!.hasChildren
                {
                    SidebarDisclosure(menuItem: item)
                }
                else
                {
                    SidebarButton(menuItem: item)
                }
            }
        }
        .collapsible(false)
    }
    
    func sectionHeaderView() -> some View {
        let title = work ? "Work" : "Leisure"
        return Text(title).padding(.bottom, 5)
    }
}

struct SidebarDisclosure: View {
    var menuItem: MenuItem
    var workspace: Workspace {
        menuItem.workspace!
    }
    
    @State var isExpanded = false
    
    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded, content: {
            ForEach(workspace.getChildrenMenuItems(), id: \.id) { item in
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
