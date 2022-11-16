import SwiftUI

struct BlockerView: View {
    @EnvironmentObject var workspace: WorkspaceState
    
    var vm: BlockerState {
        workspace.blocker
    }
    
    var body: some View {
        VStack {
            Text("Blocked Websites").font(.headline)
            
            Table(vm.blacklist, selection: $workspace.blocker.tableSelection) {
                TableColumn("URL", value: \.url)
            }
            
            Form {
                HStack {
                    TextField("Add Website to Blacklist", text: $workspace.blocker.addWebsiteFieldValue)
                        .onSubmit(vm.add)
                    
                    Button("Add", action: vm.add)
                        .errorAlert(error: $workspace.blocker.error)
                    
                    Button("Delete", action: vm.delete)
                        .disabled(vm.tableSelection.isEmpty)
                }
            }
        }
        .padding()
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
