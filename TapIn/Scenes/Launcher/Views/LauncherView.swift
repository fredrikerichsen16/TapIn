import SwiftUI
import RealmSwift
import QuickLook

struct LauncherView: View {
    @EnvironmentObject var workspace: WorkspaceVM
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()

            NavigationView {
                VStack(alignment: .leading) {
                    List(workspace.launcher.instances, id: \.id, selection: $workspace.launcher.selectedInstance) { instance in
                        listItem(for: instance)
                    }
                    .frame(width: 210, alignment: .center)
                    // TODO: Change background color to clear

                    LauncherInstanceListControlButtons()
                }
                .padding()

                Text("Select one of the launch items or click \"+\" to create a new one").font(.callout)
            }
            .quickLookPreview($quickLookURL)

            Spacer()
        }
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
            workspace.launcher.duplicate(instance)
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
            guard let id = workspace.launcher.selectedInstance else { return }
            
            workspace.launcher.selectedInstance = nil
            workspace.launcher.deleteInstance(by: id)
        }
    }
}

/// The plus and minus buttons below the list of launcher list items, for adding or removing launcher instances
struct LauncherInstanceListControlButtons: View {
    @EnvironmentObject var workspace: WorkspaceVM
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
