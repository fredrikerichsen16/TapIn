//
//  SidebarButton.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 10/01/2022.
//

import SwiftUI
import RealmSwift

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
            WorkspaceBrowse(workspaceDB: ws)
        case .leisure(let ws):
            WorkspaceBrowse(workspaceDB: ws)
        }
    }
    
    @ViewBuilder
    private func menuItemContextMenu(_ ws: WorkspaceDB?) -> some View {
        SwiftUI.Group {
            Button("Temporary") {
                print("Whateve")
            }
        }
//        if ws != nil
//        {
//            Group {
//                Button("Delete") {
//                    print("Delete")
//                }
//
//                Button("Add Child") {
//                    print("Add Child")
//                }
//
//                Button("Rename") {
//                    print("Rename")
//                }
//            }
//        }
//        else
//        {
//            Group {
//                Button("Delete") {
//                    print("Delete")
//                }
//
//                Button("Rename") {
//                    print("Rename")
//                }
//            }
//        }
    }

}

struct TemporaryView: View {
    @ObservedResults(WorkspaceDB.self) var results
    
    let workspace: WorkspaceDB
    
    var body: some View {
        VStack {
            List {
                Text("ID: \(workspace.id)")
                Text(workspace.name)
                Text(workspace.isWork ? "Is work" : "Is leisure")
                Text("Pomodoro duration: \(workspace.pomodoro?.pomodoroDuration ?? 6.9)")
            }
            
            Text("Temporary")
            
            List {
                ForEach(results.sorted(byKeyPath: "name"), id: \.id) { ws in
                    Text(ws.name)
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
