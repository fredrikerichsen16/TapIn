import SwiftUI

struct WorkspaceLauncher: View {
	@State private var showingSheet = false
	@State private var showingPopover = false
	@State private var appSelection: Int? = nil
    
    @EnvironmentObject var workspaces: Workspaces
    
    var instances: [LaunchInstance] {
        if let ws = workspaces.activeWorkspace {
            return ws.launcher.instances
        }
        
        return [LaunchInstance]()
    }
	
    var body: some View {
		VStack(alignment: .leading) {
			Spacer().frame(height: 15)
			
			NavigationView {
                List(selection: $appSelection) {
                    ForEach(instances.indices, id: \.self) { (index) in
                        let instance = instances[index]
                        
                        NavigationLink(destination: navigationLinkDestination(instance: instance, index: index)) {
                            HStack {
                                Image(nsImage: instance.mainIcon(size: 34))
                                
                                Text(instance.name)
                                
                                Spacer()
                            }
                            .tag(index)
//                            .onTapGesture(count: 2) {
//                                instance.launch()
//                            }
                        }
                    }
				}
				.frame(width: 200, alignment: .topLeading)
                
                Text("Select one...").font(.title2)
			}
			
			Button("Add") {				
				showingPopover.toggle()
			}
			.popover(isPresented: $showingPopover) {
                Popover(selection: $appSelection)
			}
			
			Spacer()
		}
    }
    
    @ViewBuilder
    func navigationLinkDestination(instance: LaunchInstance, index: Int) -> some View {
        switch instance {
            case is AppLauncher:
                AppLauncherView(instanceIndex: index)
            case is FileLauncher:
                FileLauncherView(instanceIndex: index)
            case is EmptyInstance:
                Text("EmptyInstance")
            default:
                Text("Default")
        }
    }
}

struct WorkspaceLauncher_Previews: PreviewProvider {
    static var previews: some View {
        WorkspaceLauncher()
    }
}
