import SwiftUI
import RealmSwift

struct Popover: View {
    @EnvironmentObject var workspace: WorkspaceVM
    @Binding var showingPopover: Bool
    
    func createEmptyInstance(type: RealmLauncherType) {
        workspace.launcher.createEmptyInstance(type: type)
		showingPopover = false
    }
    
    @State private var launcherInstanceTypes: [RealmLauncherType] = [.app, .file] // [.app, .file, .folder, .website, .terminal]
	
    var body: some View {
        List {
            ForEach(launcherInstanceTypes, id: \.self) { instanceType in
                Button(action: {
                    createEmptyInstance(type: instanceType)
                }, label: {
                    Label(instanceType.label, systemImage: instanceType.icon)
                })
                .buttonStyle(PlainButtonStyle())
            }
        }
		.frame(width: 160, height: 165)
	}
}

//struct Popover_Previews: PreviewProvider {
//    static var previews: some View {
//		Popover()
//    }
//}
