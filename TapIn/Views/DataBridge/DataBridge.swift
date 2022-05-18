//
//  DataBridge.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 25/01/2022.
//

import SwiftUI
import RealmSwift

struct DataBridge: View {
    @Environment(\.realm) var realm
    
    @State private var textField: String = ""
    
//    @ObservedResults(WorkspaceDB.self) var workspaces
    
    @ObservedObject var workspaces: WorkspacesVM
    
    var body: some View {
        VStack {
            Text("Items")
                .font(.title)
            
            HStack {
                TextField("", text: $textField)
                    .padding()
                    .frame(width: 300, height: 25, alignment: .center)
                Button("Submit", action: onSubmit)
            }
            
            List {
                ForEach(workspaces.workspaces) { workspace in
                    WorkspaceDetail(workspace: workspace)
                }
            }
        }
    }
    
    func onSubmit() {
        try? realm.write({
            let ws = WorkspaceDB(name: self.textField, isWork: true)
            
            realm.add(ws)
        })
    }
}

struct WorkspaceDetail: View {
    @Environment(\.realm) var realm
    @State private var textField: String = ""
    @ObservedRealmObject var workspace: WorkspaceDB
    
    var body: some View {
        VStack {
            Text("\(workspace.name), son of \(workspace.parent.first?.name ?? "Nobody")")
                .font(.title3)
            
            HStack {
                TextField("", text: $textField)
                    .padding()
                    .frame(width: 300, height: 25, alignment: .center)
                Button("Submit", action: onSubmit)
            }
            
            Button("Delete") {
                print("Delete")
            }
        }
    }
    
    private func onSubmit() {
        try? realm.write {
            guard let thawed = workspace.thaw() else { return }
            thawed.name = textField
        }
//        $workspace.children.append(WorkspaceDB(name: textField, isWork: true))
    }
}

//struct DataBridge_Previews: PreviewProvider {
//    static var previews: some View {
//        DataBridge()
//    }
//}
