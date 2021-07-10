import SwiftUI

struct LaunchApp {
	let id = UUID()
	var name: String
	var openWith: String
	var openFile: String? = nil
	
	func getIcon() -> NSImage {
		let url = URL(fileURLWithPath: openWith)
		let fullUrl = url.path
		
		print(fullUrl)

		return NSWorkspace.shared.icon(forFile: fullUrl)
	}
	
	func url(_ file: String) -> URL {
		return URL(fileURLWithPath: file)
	}
	
	func open() {
		if openFile != nil
		{
			let config = NSWorkspace.OpenConfiguration()
				config.activates = true
			
			NSWorkspace.shared.open([self.url(openFile!)], withApplicationAt: self.url(openWith), configuration: config) { (app, error) in
				print(app)
			}
		}
		else
		{
			NSWorkspace.shared.open(url(openWith))
		}
	}
}

struct WorkspaceLauncher: View {
	@State private var showingSheet = false
	@State private var showingPopover = false
	@State private var appSelection: UUID? = nil
	
	var launchApps: [LaunchApp] = [
		LaunchApp(name: "Notion", openWith: "/Applications/Safari.app"),
		LaunchApp(name: "GitHub Desktop", openWith: "/Applications/GitHub Desktop.app"),
		LaunchApp(name: "Cheat Sheet", openWith: "/System/Applications/Preview.app", openFile: "/Users/fredrik/Desktop/xcode-cheat-sheet.pdf"),
		LaunchApp(name: "VU", openWith: "/Users/fredrik/Desktop/VU"),
		LaunchApp(name: "Stack Overflow", openWith: "/Applications/Safari.app", openFile: "https://www.stackoverflow.com")
	]
	
    var body: some View {
		VStack(alignment: .leading) {
			Spacer().frame(height: 15)
			
			Text("Workspace")
				.font(.largeTitle)
			
			HStack {
				List(selection: $appSelection) {
					ForEach(launchApps, id: \.id) { app in
						HStack {
							Image(nsImage: app.getIcon())
							
							Text(app.name)
							
							Spacer()
						}.tag(app.id)
					}
				}
				.frame(width: 250, alignment: .topLeading)
				
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
