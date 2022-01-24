import SwiftUI

struct WorkspaceLauncher: View {
	@State private var showingSheet = false
	@State private var showingPopover = false
	@State private var appSelection: Int? = nil
    
    @EnvironmentObject var workspace: Workspace
    
    var instances: [LaunchInstanceBridge] {
        workspace.launcher.instances
    }
	
    var body: some View {
		VStack(alignment: .leading) {
			Spacer().frame(height: 25)
			
			NavigationView {
                VStack(alignment: .leading) {
                    List(selection: $appSelection) {
                        ForEach(instances.indices, id: \.self) { (index) in
                            let instance = instances[index]
                            
                            NavigationLink(destination: navigationLinkDestination(instance: instance, index: index)) {
                                HStack {
                                    Image(nsImage: instance.appController.iconForApp(size: 34))
                                    
                                    Text(instance.name)
                                    
                                    Spacer()
                                }
                                .tag(index)
                                .onTapGesture(count: 2) {
                                    instance.opener.openApp()
                                }
                            }
                        }
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
                            Popover(selection: $appSelection, showingPopover: $showingPopover)
                        }
                        
                        Button(action: {
                            if let _appSelection = appSelection {
                                workspace.launcher.instances.remove(at: _appSelection)
                                appSelection = min(_appSelection, workspace.launcher.instances.count - 1)
                            }
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
    func navigationLinkDestination(instance: LaunchInstanceBridge, index: Int) -> some View {
        switch instance.type {
            case .app:
                AppLauncherView(workspace: workspace, instanceIndex: index)
            case .file:
                FileLauncherView(workspace: workspace, instanceIndex: index)
            case .folder:
                FileLauncherView(workspace: workspace, instanceIndex: index)
            case .empty(_):
                EmptyLauncherView(workspace: workspace, instanceIndex: index)
            default:
                Text("Default")
        }
    }
}

//struct WorkspaceLauncher_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkspaceLauncher()
//    }
//}
