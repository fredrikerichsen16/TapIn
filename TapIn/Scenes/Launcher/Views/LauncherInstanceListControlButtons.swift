import SwiftUI

/// The plus and minus buttons below the list of launcher list items, for adding or removing launcher instances
struct LauncherInstanceListControlButtonsView: View {
    @EnvironmentObject var workspace: WorkspaceState
    @State var showingPopover = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            Button(action: {
                showingPopover.toggle()
            }, label: {
                Image(systemName: IconKeys.plus)
                    .font(.system(size: 16.0))
            })
            .buttonStyle(.bordered)
            .popover(isPresented: $showingPopover) {
                LauncherTypeSelectionPopoverView(showingPopover: $showingPopover)
            }
            
            Button(action: {
                guard let id = workspace.launcher.selectedInstance else { return }
                
                workspace.launcher.selectedInstance = nil
                workspace.launcher.deleteInstance(by: id)
            }, label: {
                Image(systemName: IconKeys.minus)
                    .font(.system(size: 16.0))
            })
            .buttonStyle(.bordered)
            .disabled(workspace.launcher.selectedInstance == nil)
        }
    }
}

struct LauncherInstanceListControlButtonsView_Preview: PreviewProvider {
    static var previews: some View {
        let workspace = WorkspaceState.preview
        
        LauncherInstanceListControlButtonsView(showingPopover: true)
            .environmentObject(workspace)
    }
}

