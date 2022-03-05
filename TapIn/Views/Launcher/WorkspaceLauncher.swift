import SwiftUI
import RealmSwift

struct WorkspaceLauncher: View {
	@State private var showingSheet = false
	@State private var showingPopover = false
	@State private var appSelection: Int? = nil
    @State private var selectedInstance: String? = nil
    
    @ObservedRealmObject var launcher: LauncherDB
    
//    var body: some View {
//        List(launcher.launcherInstances, id: \.id) { instance in
//            Text(instance.name)
//            Button("Open") {
//                if let bridge = instance.launcherBridge {
//                    bridge.opener.openApp()
//                } else {
//                    print("FAIL TO GET BRIDGE")
//                }
//            }
//        }
//    }
	
    var body: some View {
		VStack(alignment: .leading) {
			Spacer().frame(height: 25)

			NavigationView {
                VStack(alignment: .leading) {
                    List(launcher.launcherInstances, id: \.id, selection: $selectedInstance) { instance in
                        launcherInstanceMenuButton(instance: instance)
                    }
                    .frame(width: 210, alignment: .center)

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
                            print("Remove selected instance")
                        }, label: {
                            Image(systemName: "minus")
                                .font(.system(size: 16.0))
                        })
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()

                Text("Select one...").font(.title2)
			}

			Spacer()
		}
    }
    
    @ViewBuilder
    func navigationLinkDestination(instance: LaunchInstanceBridge) -> some View {
        switch instance.type {
            case .app:
                AppLauncherView()
//            case .file:
//                FileLauncherView(workspace: workspace)
//            case .folder:
//                FileLauncherView(workspace: workspace)
//            case .website:
//                WebsiteLauncherView(workspace: workspace)
//            case .empty(_):
//                EmptyLauncherView(launcher: launcher, instance: instance)
            default:
                Text("DEFAULT: \(instance.name)")
        }
    }
    
    @ViewBuilder
    func launcherInstanceMenuButton(instance: LauncherInstanceDB) -> some View {
        if let launcherBridge = instance.launcherBridge
        {
            NavigationLink(destination: navigationLinkDestination(instance: launcherBridge)) {
                HStack {
                    Image(nsImage: launcherBridge.appController.iconForApp(size: 34))
                    
                    Text(instance.name)
                    
                    Spacer()
                }
                .tag(instance.id.stringValue)
                .onTapGesture(count: 2) {
                    launcherBridge.opener.openApp()
                }
            }
        }
        else
        {
            Text("Cock and ballz babyy")
        }
    }
}

//struct WorkspaceLauncher_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkspaceLauncher()
//    }
//}
