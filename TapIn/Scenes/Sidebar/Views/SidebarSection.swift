//
//  SidebarSection.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 10/01/2022.
//

import SwiftUI
import RealmSwift

struct SidebarSection: View {
    @Environment(\.realm) var realm
    @ObservedResults(WorkspaceDB.self) private var workspaces
    @EnvironmentObject var stateManager: StateManager
    
    @Binding var selection: String?
    
    var body: some View {
        let workspaces = WorkspaceDB.getWorkspaces(realm: realm)
        
        Section(header: Text("Workspaces")) {
            ForEach(MenuItem.getMenuItems(workspaces: Array(workspaces)), id: \.id) { menuItem in
                if let ws = menuItem.workspace
                {
                    if ws.children.isEmpty
                    {
                        SidebarButton(menuItem: menuItem, selection: $selection)
                    }
                    else
                    {
                        SidebarDisclosure(menuItem: menuItem, workspaces: Array(ws.children), selection: $selection)
                    }
                }
            }
            
            Spacer()
            
            Button("Add Workspace") {
                try? realm.write({
                    let ws = WorkspaceDB(name: "New Workspace")

                    realm.add(ws)
                })
                
                stateManager.refresh()
            }
        }
        .collapsible(false)
    }
}

struct SidebarDisclosure: View {
    var menuItem: MenuItem
    var workspaces: [WorkspaceDB]
    
    @State var isExpanded = false
    
    @Binding var selection: String?
    
    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded, content: {
            ForEach(MenuItem.getMenuItems(workspaces: workspaces), id: \.id) { item in
                SidebarButton(menuItem: item, selection: $selection)
            }
        }, label: {
            SidebarButton(menuItem: menuItem, selection: $selection)
        })
    }
}

//struct SidebarSection_Previews: PreviewProvider {
//    static var previews: some View {
//        SidebarSection(work: true)
//    }
//}
