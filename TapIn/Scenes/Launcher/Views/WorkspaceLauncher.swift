import SwiftUI
import RealmSwift
import QuickLook

struct WorkspaceLauncher: View {
	@State private var showingSheet = false
    @State private var selectedInstance: ObjectId? = nil
    
    @ObservedRealmObject var launcher: LauncherDB
    @Environment(\.realm) var realm
	
    var body: some View {
		VStack(alignment: .leading) {
			Spacer().frame(height: 25)

			NavigationView {
                VStack(alignment: .leading) {
                    if let parentInstances = launcher.parentLauncherInstances, parentInstances.count > 0
                    {
                        List(parentInstances, id: \.id, selection: $selectedInstance) { instance in
                            launcherInstanceListItem(instance: instance)
                        }
                        
                        Divider()
                        Spacer()
                    }
                    
                    List(launcher.launcherInstances, id: \.id, selection: $selectedInstance) { instance in
                        launcherInstanceListItem(instance: instance)
                    }
                    .frame(width: 210, alignment: .center)

                    LauncherInstanceListControlButtons(launcher: launcher, selectedInstance: $selectedInstance)
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
            .tag(instance.id.stringValue)
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
                AppLauncherView(launcherInstance: instance)
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
                try! realm.write {
                    let duplicatedLauncher = LauncherInstanceDB(name: instance.name, type: instance.type, instantiated: instance.instantiated, appUrl: instance.appUrl, fileUrl: instance.fileUrl, launchDelay: instance.launchDelay, hideOnLaunch: instance.hideOnLaunch)
                    realm.add(duplicatedLauncher)
                }
            }
            
            Button("Quick Look") {
                quickLookURL = instance.fileController.getFile() ?? instance.appController.getApp()
            }
            
            Button("Delete") {
                let _ = LauncherInstanceDB.deleteById(realm, id: instance.id)
            }
        }
    }
}

//struct WorkspaceLauncher_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkspaceLauncher()
//    }
//}

/// The plus and minus buttons below the list of launcher list items, for adding or removing launcher instances
struct LauncherInstanceListControlButtons: View {
//    init(launcher: LauncherDB, selectedInstance: ObjectId?) {
//        self.launcher = launcher
//        self.selectedInstance = selectedInstance
//    }
    
    @ObservedRealmObject var launcher: LauncherDB
    @Binding var selectedInstance: ObjectId?
    @State var appSelection: Int? = nil
    @State var showingPopover = false
    @Environment(\.realm) var realm
    
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
                Popover(launcher: launcher, selection: $appSelection, showingPopover: $showingPopover)
            }
            
            Button(action: {
                guard let id = selectedInstance else { return }
                
                let _ = LauncherInstanceDB.deleteById(realm, id: id)
            }, label: {
                Image(systemName: "minus")
                    .font(.system(size: 16.0))
            })
            .buttonStyle(PlainButtonStyle())
        }
    }
}
