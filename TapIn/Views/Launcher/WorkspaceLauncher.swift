import SwiftUI

struct WorkspaceLauncher: View {
	@State private var showingSheet = false
	@State private var showingPopover = false
	@State private var appSelection: UUID? = nil
    
    @EnvironmentObject var workspaces: Workspaces
    
    var instances: [IdentifiableLaunchInstance] {
        if let ws = workspaces.activeWorkspace {
            return ws.launcher.instances
        }
        
        return [IdentifiableLaunchInstance]()
    }
	
    var body: some View {
		VStack(alignment: .leading) {
			Spacer().frame(height: 15)
			
			HStack {
                List(selection: $appSelection) {
                    ForEach(instances, id: \.id) { item in
                        let instance = item.launchInstance
                        
                        HStack {
                            Image(nsImage: instance.mainIcon(size: 34))
                            
                            Text(instance.name)
                            
                            Spacer()
                        }
                        .tag(item.id)
//                        .onTapGesture {
//                            instance.launch()
//                        }
                    }
				}
				.frame(width: 250, alignment: .topLeading)
                .onChange(of: appSelection) { selection in
                    for instance in instances {
                        print(instance.id)
                        print("TISSS")
                        if instance.id == selection {
                            workspaces.activeWorkspace!.launcher.selected = instance.launchInstance
                            return
                        }
                    }
                }
				
				Spacer()
				
                LaunchAppDetail()
				
				Spacer()
			}
			
			Button("Add") {				
				showingPopover.toggle()
			}
			.popover(isPresented: $showingPopover) {
				Popover()
			}
			
			Spacer()
		}
    }
}

struct WorkspaceLauncher_Previews: PreviewProvider {
    static var previews: some View {
        WorkspaceLauncher()
    }
}
