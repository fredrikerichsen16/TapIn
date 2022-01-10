import SwiftUI
import SwiftUIRouter

struct WorkspaceBrowse: View {
	@State var pageSelection = "workspace-pomodoro"
	@EnvironmentObject var navigator: Navigator
    @ObservedObject var workspace: Workspace
	
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
                    WorkspacePomodoro(workspace: workspace)
				}
				Route(path: "workspace-timetracking") { info in
					WorkspaceTimeTracking(workspace: workspace)
				}
				Route(path: "workspace-launcher/*") {
					WorkspaceLauncher(workspace: workspace)
				}
				Route(path: "workspace-blocker") {
					WorkspaceBlocker(workspace: workspace)
				}
			}
		}
		.padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 25))
		.onAppear {
			navigator.navigate("/workspace-pomodoro")
		}
    }
}
