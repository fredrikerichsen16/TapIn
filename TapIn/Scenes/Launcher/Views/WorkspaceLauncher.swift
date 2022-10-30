import SwiftUI
import RealmSwift
import QuickLook

struct WorkspaceLauncher: View {
	@State private var showingSheet = false
    @State private var selectedInstance: ObjectId? = nil
    
    @EnvironmentObject var launcherState: LauncherState
	
    var body: some View {
		VStack(alignment: .leading) {
			Spacer().frame(height: 25)

			NavigationView {
                VStack(alignment: .leading) {
                    List(launcherState.launcherInstances, id: \.id, selection: $selectedInstance) { instance in
                        launcherInstanceListItem(instance: instance)
                    }
                    .frame(width: 210, alignment: .center)

                    LauncherInstanceListControlButtons(selectedInstance: $selectedInstance)
                }
                .padding()

                Text("Select one of the launch items or click \"+\" to create a new one").font(.callout)
			}
            .quickLookPreview($quickLookURL)

			Spacer()
		}
    }
    
    @ViewBuilder
    private func launcherInstanceListItem(instance: LauncherInstanceDB) -> some View {
        NavigationLink(destination: navigationLinkDestination(instance: instance)) {
            HStack {
                Image(nsImage: instance.appController.iconForApp(size: 34))
                
                Text(instance.name)
                
                Spacer()
            }
            .tag(instance.id)
        }
        .contextMenu(ContextMenu(menuItems: {
            listItemContextMenu(instance: instance)
        }))
    }
    
    /// Return a view for editing/opening the app/file/etc. based on the launcher type of the given launcher instance. Is the view that appears on the right when you click a navigation link on the left.
    /// - Parameter instance: Launcher Instance from the Realm database
    /// - Returns: Launcher view
    @ViewBuilder
    private func navigationLinkDestination(instance: LauncherInstanceDB) -> some View {
        switch instance.fullType {
            case .app:
                AppLauncherView(launcherState: launcherState, launcherInstance: instance)
            case .file:
                FileLauncherView(launcherInstance: instance)
            case .folder:
                FileLauncherView(launcherInstance: instance)
            case .website:
                WebsiteLauncherView(launcherInstance: instance)
            case .empty(_):
                EmptyLauncherView(launcherInstance: instance)
            default:
                Text("DEFAULT: \(instance.name)")
        }
    }
    
    @State private var quickLookURL: URL? = nil
    
    @ViewBuilder
    private func listItemContextMenu(instance: LauncherInstanceDB) -> some View {
        SwiftUI.Group {
            Button("Open") {
                instance.opener.openApp()
            }
            
            Button("Disable") {
                print("Disable not implemented yet")
            }
            
            Button("Duplicate") {
                launcherState.duplicate(launcherInstance: instance)
            }
            
            Button("Quick Look") {
                quickLookURL = instance.fileController.getFile() ?? instance.appController.getApp()
            }
            
            Button("Delete") {
                launcherState.delete(launcherInstance: instance)
            }
        }
    }
}

/// The plus and minus buttons below the list of launcher list items, for adding or removing launcher instances
struct LauncherInstanceListControlButtons: View {
    @EnvironmentObject var launcherState: LauncherState
    @Binding var selectedInstance: ObjectId?
    @State var appSelection: Int? = nil
    @State var showingPopover = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            Button(action: {
                showingPopover.toggle()
            }, label: {
                Image(systemName: "plus")
                    .font(.system(size: 16.0))
            })
            .buttonStyle(PlainButtonStyle())
            .popover(isPresented: $showingPopover) {
                Popover(selection: $appSelection, showingPopover: $showingPopover)
            }
            
            Button(action: {
                guard let id = selectedInstance else { return }
                launcherState.deleteInstance(by: id)
            }, label: {
                Image(systemName: "minus")
                    .font(.system(size: 16.0))
            })
            .buttonStyle(PlainButtonStyle())
        }
    }
}
