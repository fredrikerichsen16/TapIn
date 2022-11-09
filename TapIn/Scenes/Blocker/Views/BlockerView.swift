import SwiftUI

struct BlockerView: View {
    @EnvironmentObject var workspace: WorkspaceState
    
    var vm: BlockerState {
        workspace.blocker
    }
    
    @State private var addWebsiteFieldValue = ""
    @State private var tableSelection: Set<Int> = Set()
    
    var body: some View {
        VStack {
            Text("Blocked Websites").font(.headline)
            
            Table(workspace.blocker.blacklist, selection: $tableSelection) {
                TableColumn("URL", value: \.url)
            }
            
            Form {
                HStack {
                    TextField("Add Website to Blacklist", text: $addWebsiteFieldValue)
                        .onSubmit {
                            add()
                        }
                    
                    Button("Add", action: add)
                    
                    Button("Delete") {
                        if tableSelection.isEmpty {
                            return
                        }
                        
                        workspace.blocker.deleteBlacklistedWebsite(by: tableSelection)
                        
                        tableSelection = Set()
                    }
                    .disabled(tableSelection.isEmpty)
                }
            }
        }
        .padding()
        .onAppear {
            vm.fetch()
        }
    }
    
    func add() {
        workspace.blocker.addBlacklistedWebsite(url: addWebsiteFieldValue)
        addWebsiteFieldValue = ""
    }
}

struct WorkspaceBlocker_Preview: PreviewProvider {
    static var previews: some View {
        let workspace = WorkspaceState.preview
        
        BlockerView()
            .environmentObject(workspace)
            .environmentObject(workspace.blocker)
    }
}
