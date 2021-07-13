import SwiftUI
import SwiftUIRouter

struct ContentView: View {
    @EnvironmentObject var workspace: WorkspaceModel
	@State var selection: Set<Int> = [0]

	var body: some View {
		Router {
			NavigationView {
				List(selection: $selection) {
					NavigationLink(destination: Text("Home")) {
						Label("Home", systemImage: "house")
							.tag(0)
					}

					NavigationLink(destination: Settings()) {
						Label("Settings", systemImage: "gearshape")
							.tag(1)
					}

					Section(header: Text("Work")) {
                        NavigationLink(destination: WorkspaceBrowse()) {
							Label("University", systemImage: "folder")
								.tag(2)
						}

						NavigationLink(destination: Text("Leetcode")) {
							Label("Leetcode", systemImage: "folder")
								.tag(3)
						}

						NavigationLink(destination: Text("Startup")) {
							Label("Startup", systemImage: "folder")
								.tag(4)
						}
					}

					Section(header: Text("Leisure")) {
						NavigationLink(destination: Text("Chess")) {
							Label("Chess", systemImage: "folder")
								.tag(5)
						}

						NavigationLink(destination: Text("Reading")) {
							Label("Reading", systemImage: "folder")
								.tag(6)
						}
					}

					Spacer()

					Button("Add") {
						print("Add")
					}
				}
				.listStyle(SidebarListStyle())
				.frame(minWidth: 150, idealWidth: 200, maxWidth: 300, idealHeight: .infinity)
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
