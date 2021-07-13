import SwiftUI

struct WorkspaceLauncher: View {
	@State private var showingSheet = false
	@State private var showingPopover = false
	@State private var appSelection: UUID? = nil
    @EnvironmentObject var workspace: WorkspaceModel
	
    var body: some View {
		VStack(alignment: .leading) {
			Spacer().frame(height: 15)
			
			Text("Workspace")
				.font(.largeTitle)
			
			HStack {
				List(selection: $appSelection) {
                    ForEach(workspace.launcher.instances, id: \.id) { app in
						HStack {
                            Image(nsImage: LaunchInstance.getIcon(for: app.getApp(), size: 48))

							Text(app.name)

							Spacer()
                        }
                        .tag(app.id)
                        .onTapGesture(count: 2) {
                            app.open()
                        }
					}
				}
				.frame(width: 250, alignment: .topLeading)
                .onChange(of: appSelection) { selection in
                    let instances = workspace.launcher.instances
                    for (idx, instance) in instances.enumerated() {
                        if instance.id == selection {
                            workspace.launcher.selected = idx
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
