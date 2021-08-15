import SwiftUI
import SwiftUIRouter

struct WorkspaceBrowse: View {
	@State var pageSelection = "workspace-pomodoro"
	@EnvironmentObject var navigator: Navigator
    @EnvironmentObject var workspaces: Workspaces
	
    var body: some View {
		VStack {
			HStack() {
				Spacer()
				
				Picker("", selection: $pageSelection) {
					Text("Pomodoro").tag("workspace-pomodoro")
					Text("Time Tracking").tag("workspace-timetracking")
					Text("Launcher").tag("workspace-launcher")
					Text("Blocker").tag("workspace-blocker")
					Image(systemName: "ellipsis")
				}
				.pickerStyle(SegmentedPickerStyle())
				.onChange(of: pageSelection) { selection in
					guard selection != "more" else { return }
					
					navigator.navigate("/" + selection, replace: true)
				}
				.frame(width: 400)
				
				Spacer()
				
				Button("Start") {
					print("Start")
				}
			}
			
			SwitchRoutes {
				Route(path: "workspace-pomodoro") {
					WorkspacePomodoro()
				}
				Route(path: "workspace-timetracking") { info in
					WorkspaceTimeTracking()
				}
				Route(path: "workspace-launcher/*") {
					WorkspaceLauncher()
				}
				Route(path: "workspace-blocker") {
					WorkspaceBlocker()
				}
			}
		}
		.padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 25))
		.onAppear {
			navigator.navigate("/workspace-pomodoro")
		}
    }
}
