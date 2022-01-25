//
//  DataBridge.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 25/01/2022.
//

import SwiftUI

struct DataBridge: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \WorkspaceCD.name, ascending: true)],
                  animation: .default)
    private var workspaces: FetchedResults<WorkspaceCD>
    
    @State var workspaceName = ""
    @State var pickerSelection: String? = nil
    
    var body: some View {
        VStack {
            if #available(macOS 12.0, *) {
                TextField("", text: $workspaceName)
                    .onSubmit {
                        addWorkspace()
                    }
            }
            
            Picker("", selection: $pickerSelection) {
//                Text("None").tag(nil)
                ForEach(workspaces.indices, id: \.self) { idx in
                    let workspace = workspaces[idx]
                    let name = workspace.name!
                    
                    Text(name).tag(name)
                }
            }
            
            Text("Current Workspaces")
            List {
                ForEach(workspaces) { workspace in
                    VStack {
                        Text(workspace.name!)
                        Text(String(workspace.isWork))
                        if let parent = workspace.parent {
                            Text("Parent: \(parent.name!)")
                        } else {
                            Text("Pikk")
                        }
                        Button("Delete") {
                            viewContext.delete(workspace)
                            
                            try? viewContext.save()
                        }
                    }
                }
            }
        }
    }
    
    func addWorkspace() {
        withAnimation {
            let newWorkspace = WorkspaceCD(context: viewContext)
                newWorkspace.name = workspaceName
                newWorkspace.isWork = true
            
            print(pickerSelection)
            
            let result = WorkspaceCD.fetchRequest()
            
            let fetchRequest = NSFetchRequest<WorkspaceCD>(entityName: "WorkspaceCD")
                fetchRequest.fetchLimit = 1
                fetchRequest.predicate = NSPredicate(format: "name == Coding")
            
            if let parents = try? viewContext.fetch(fetchRequest) {
                let parent = parents[0]
                print(parent.name!)
                
                parent.addToChildren(newWorkspace)
            } else {
                print("NO PARENT")
            }
            
            PersistenceController.shared.container.saveContext(nil)
        }
    }
}

struct DataBridge_Previews: PreviewProvider {
    static var previews: some View {
        DataBridge()
    }
}
