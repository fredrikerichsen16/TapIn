import SwiftUI
import SwiftUIRouter

struct WorkspaceBrowse: View {
	@State var pageSelection = "workspace-pomodoro"
	@EnvironmentObject var navigator: Navigator
    @EnvironmentObject var workspace: Workspace
	
    var body: some View {
		VStack {
            HStack(alignment: .center) {
				Picker("", selection: $pageSelection) {
					Text("Pomodoro").tag("workspace-pomodoro")
					Text("Time Tracking").tag("workspace-timetracking")
					Text("Launcher").tag("workspace-launcher")
					Text("Blocker").tag("workspace-blocker")
//					Image(systemName: "ellipsis")
				}
				.pickerStyle(SegmentedPickerStyle())
				.onChange(of: pageSelection) { selection in
					guard selection != "more" else { return }
					
					navigator.navigate("/" + selection, replace: true)
				}
				.frame(width: 400)
			}
			
			SwitchRoutes {
				Route("workspace-pomodoro") {
                    WorkspacePomodoro()
				}
				Route("workspace-timetracking") { info in
					WorkspaceTimeTracking()
				}
				Route("workspace-launcher/*") {
					WorkspaceLauncher()
				}
				Route("workspace-blocker") {
					WorkspaceBlocker()
				}
			}
            
            Spacer()
            
            BottomMenu()
		}
        .edgesIgnoringSafeArea([.bottom, .horizontal])
		.onAppear {
			navigator.navigate("/workspace-pomodoro")
		}
    }
}
