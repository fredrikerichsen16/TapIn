import SwiftUI
import RealmSwift

struct LauncherTypeSelectionPopoverView: View {
    @EnvironmentObject var workspace: WorkspaceState
    @Binding var showingPopover: Bool
    
    func createEmptyInstance(type: RealmLauncherType) {
        workspace.launcher.createEmptyInstance(type: type)
		showingPopover = false
    }
    
    @State private var launcherInstanceTypes: [RealmLauncherType] = [.app, .file, .folder, .website]
	
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(launcherInstanceTypes, id: \.self) { instanceType in
                Button(action: {
                    createEmptyInstance(type: instanceType)
                }, label: {
                    Label(instanceType.label, systemImage: instanceType.icon)
                })
                .buttonStyle(.plain)
            }
        }
        .padding(20)
	}
}

//struct Popover_Previews: PreviewProvider {
//    static var previews: some View {
//        LauncherTypeSelectionPopoverView(showingPopover: .constant(true))
//    }
//}
