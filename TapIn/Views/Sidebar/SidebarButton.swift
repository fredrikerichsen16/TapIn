//
//  SidebarButton.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 10/01/2022.
//

import SwiftUI
import RealmSwift

struct SidebarButton: View {
    @Environment(\.realm) var realm
    @ObservedResults(WorkspaceDB.self) var workspaces
    @EnvironmentObject var stateManager: StateManager
    @State var menuItem: MenuItem
    
    @State var renameWorkspaceField: String = ""
    @State var isRenaming = false
    
    @Binding var selection: String?
    
    @Namespace var mainNamespace
    
    var body: some View {
        if isRenaming
        {
            if #available(macOS 12.0, *) {
                TextField("", text: $renameWorkspaceField) // passing it to bind
                    .textFieldStyle(.roundedBorder) // adds border
                    .prefersDefaultFocus(in: mainNamespace)
                    .onSubmit {
                        guard let currentWorkspace = menuItem.workspace?.thaw(),
                              let thawedRealm = currentWorkspace.realm
                            else { return }
                        
                        if renameWorkspaceField == "" {
                            return
                        }
                        
                        try! thawedRealm.write {
                            currentWorkspace.name = renameWorkspaceField
                        }
                        
                        isRenaming = false
                    }
            }
        }
        else
        {
            NavigationLink(destination: viewForMenuItem(menuItem)) {
                Label(menuItem.text, systemImage: menuItem.icon)
                    .tag(menuItem.id)
                    .padding(.vertical, 5)
            }
            .contextMenu(ContextMenu(menuItems: {
                menuItemContextMenu(menuItem.workspace)
            }))
        }
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
            Button("Add Child Workspace") {
                guard let currentWorkspace = menuItem.workspace?.thaw(),
                      let thawedRealm = currentWorkspace.realm
                    else { return }
                
                try! thawedRealm.write {
                    let newWorkspace = WorkspaceDB(name: "New Workspace", isWork: currentWorkspace.isWork)
                    
                    currentWorkspace.children.append(newWorkspace)
                }
                
                selection = "home"
            }
            
            Button("Delete") {
                guard let currentWorkspace = menuItem.workspace?.thaw(),
                      let thawedRealm = currentWorkspace.realm
                    else { return }
                
                selection = "home"
                
                try! thawedRealm.write {
                    thawedRealm.delete(currentWorkspace)
                }
            }
            
            Button("Rename") {
                selection = "statistics"
//                beginRenamingWorkspace()
            }
        }
    }
    
    func beginRenamingWorkspace() {
        guard #available(macOS 12.0, *) else {
            return
        }
        
        renameWorkspaceField = menuItem.workspace!.name
        isRenaming = true
    }
    
    func renameWorkspace() {
        guard let currentWorkspace = menuItem.workspace?.thaw(),
              let thawedRealm = currentWorkspace.realm
            else { return }
        
        if renameWorkspaceField == "" {
            return
        }
        
        try! thawedRealm.write {
            currentWorkspace.name = renameWorkspaceField
        }
        
        isRenaming = false
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

//struct SidebarButton_Previews: PreviewProvider {
//    @State var selection: String? = "statistics"
//
//    static var previews: some View {
//        SidebarButton(menuItem: .statistics, selection: $selection)
//    }
//}
