import SwiftUI

struct WorkspaceLauncher: View {
	@State private var showingSheet = false
	@State private var showingPopover = false
	@State private var appSelection: Int? = nil
    
    @EnvironmentObject var workspace: Workspace
    
    var instances: [LaunchInstance] {
        workspace.launcher.instances
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
                            .onTapGesture(count: 2) {
                                instance.launch()
                            }
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
                Popover(selection: $appSelection, showingPopover: $showingPopover)
			}
			
			Spacer()
		}
    }
    
    @ViewBuilder
    func navigationLinkDestination(instance: LaunchInstance, index: Int) -> some View {
        switch instance {
            case is AppLauncher:
                AppLauncherView(workspace: workspace, instanceIndex: index)
            case is FileLauncher:
                FileLauncherView(workspace: workspace, instanceIndex: index)
            case is EmptyInstance:
                LaunchAppDetail(appIndex: index)
            default:
                Text("Default")
        }
        Text("Default")
    }
}

//struct WorkspaceLauncher_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkspaceLauncher()
//    }
//}
