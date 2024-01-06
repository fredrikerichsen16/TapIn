import SwiftUI
import RealmSwift
import QuickLook

struct LauncherView: View {
    @EnvironmentObject var workspace: WorkspaceState
    
    var vm: LauncherState {
        workspace.launcher
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List(vm.instances, id: \.id, selection: $workspace.launcher.selectedInstance) { instance in
                    listItem(for: instance)
                }
                .scrollContentBackground(.hidden)
                .frame(width: 210, alignment: .center)
                
                LauncherInstanceListControlButtonsView()
            }
            .padding()

            Text("Select one of the launch items or click \"+\" to create a new one").font(.callout)
        }
        .quickLookPreview($quickLookURL)
    }
    
    @ViewBuilder
    private func listItem(for instance: any BaseLauncherInstanceBehavior) -> some View {
        NavigationLink(destination: navigationDestination(for: instance)) {
            HStack {
                Image(nsImage: instance.getIcon(size: 34))
                Text(instance.name)
                Spacer()
            }
            .tag(instance.id)
            .opacity(instance.object.active ? 1 : 0.5)
        }
        .contextMenu {
            listItemContextMenu(for: instance)
        }
    }
    
    @ViewBuilder
    private func navigationDestination(for instance: any BaseLauncherInstanceBehavior) -> some View {
        if let fileSystemInstance = instance as? any FileSystemBasedBehavior & BaseLauncherInstanceBehavior
        {
            FileSystemInstanceLauncherView(instance: fileSystemInstance)
        }
        else if let webBasedInstance = instance as? any WebBasedBehavior & BaseLauncherInstanceBehavior
        {
            WebBasedInstanceLauncherView(instance: webBasedInstance)
        }
        else
        {
            Text("FAN!")
        }
    }
    
    @State private var quickLookURL: URL? = nil
    
    @ViewBuilder
    private func listItemContextMenu(for instance: any BaseLauncherInstanceBehavior) -> some View {
        if let openableInstance = instance as? Openable
        {
            Button("Open") {
                openableInstance.open()
            }
        }

        let enabled = instance.object.active
        Button(enabled ? "Disactivate" : "Activate") {
            instance.write {
                instance.object.active = !enabled
            }
        }

        Button("Duplicate") {
            vm.duplicate(instance)
        }

        if let fileInstance = instance as? FileBehavior
        {
            Button("Quick Look") {
                quickLookURL = fileInstance.file
            }
        }
        else if let appInstance = instance as? AppBehavior
        {
            Button("Quick Look") {
                quickLookURL = appInstance.app
            }
        }

        Button("Delete") {
            guard let id = vm.selectedInstance else { return }
            
            vm.selectedInstance = nil
            vm.deleteInstance(by: id)
        }
    }
}

//struct LauncherView_Preview: PreviewProvider {
//    static var previews: some View {
//        let workspace = WorkspaceState.preview
//
//        LauncherView()
//            .environmentObject(workspace)
//    }
//}
