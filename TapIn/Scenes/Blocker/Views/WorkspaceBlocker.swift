import SwiftUI

struct WorkspaceBlocker: View {
    @EnvironmentObject var blockerState: BlockerState
    @State private var addWebsiteFieldValue = ""
    @State private var tableSelection: Set<Int> = Set()
    
    var body: some View {
        VStack {
            Text("Blocked Websites").font(.headline)
            
            Table(blockerState.blacklist, selection: $tableSelection) {
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
                        
                        blockerState.deleteBlacklistedWebsite(by: tableSelection)
                        
                        tableSelection = Set()
                    }
                    .disabled(tableSelection.isEmpty)
                }
            }
        }
        .padding()
    }
    
    func add() {
        blockerState.addBlacklistedWebsite(url: addWebsiteFieldValue)
        addWebsiteFieldValue = ""
    }
}

struct WorkspaceBlocker_Preview: PreviewProvider {
    static var previews: some View {
        let workspace = WorkspaceVM.preview
        
        WorkspaceBlocker()
            .environmentObject(workspace)
            .environmentObject(workspace.blockerState)
    }
}
