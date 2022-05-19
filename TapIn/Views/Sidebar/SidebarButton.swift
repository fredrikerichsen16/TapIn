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
                        guard let workspace = menuItem.workspace else { return }
                        workspace.renameWorkspace(realm, name: renameWorkspaceField)
                        isRenaming = false
                    }
            }
        }
        else
        {
            NavigationLink(tag: menuItem.id, selection: $selection, destination: { viewForMenuItem(menuItem) }, label: {
                Label(menuItem.text, systemImage: menuItem.icon)
                    .padding(.vertical, 5)
            })
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
            WorkspaceBrowse(workspace: ws)
        case .leisure(let ws):
            WorkspaceBrowse(workspace: ws)
        }
    }
    
    @ViewBuilder
    private func menuItemContextMenu(_ ws: WorkspaceDB?) -> some View {
        SwiftUI.Group {
            Button("Add Child Workspace") {
                guard let workspace = menuItem.workspace else { return }
                workspace.addChild(realm)
            }
            
            Button("Delete") {
                guard let workspace = menuItem.workspace else { return }
                
                selection = "home"
                
                workspace.deleteWorkspace(realm)
            }
            
            Button("Rename") {
                beginRenamingWorkspace()
            }
            
            Button("Test") {
                selection = nil
            }
            
            Button("Set Active") {
                print("MANUALLY SET")
                print(menuItem.workspace)
                stateManager.selectedWorkspace = menuItem.workspace
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
