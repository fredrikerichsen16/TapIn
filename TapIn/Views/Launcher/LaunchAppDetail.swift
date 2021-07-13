import SwiftUI
import SwiftUIRouter

struct FileDetail: View {
	@State private var openWithSelection: Int = 0
	@State private var name: String = ""
	@State private var openableApps: [URL] = []
    
    @EnvironmentObject var workspace: WorkspaceModel
    
    var selectedApp: LaunchInstance? {
        if let selected = workspace.launcher.selected
        {
            return workspace.launcher.instances[selected]
        }
        else
        {
            return nil
        }
    }
	
	var body: some View {
		VStack(alignment: .center) {
			if selectedApp == nil
			{
				Image(systemName: "square.and.arrow.down")
					.font(.system(size: 60))
					.onTapGesture {
						let panel = NSOpenPanel()
							panel.allowsMultipleSelection = false
							panel.canChooseDirectories = true
		
						if panel.runModal() == .OK {
							if let url = panel.url {
                                workspace.launcher.createLaunchInstance(name: url.lastPathComponent, appFirst: false, app: nil, file: url)
                                workspace.launcher.selected = workspace.launcher.instances.count - 1
                                
                                self.openableApps = selectedApp!.getCompatibleApps()
							}
						}
					}
				
				Text("Drop a file here (or click to upload)")
					.font(.body)
					.padding()
			}
			else
			{
                Image(nsImage: LaunchInstance.getIcon(for: selectedApp!.getApp(), size: 128))
					.font(.system(size: 80))
					.onTapGesture {
						let panel = NSOpenPanel()
							panel.allowsMultipleSelection = false
							panel.canChooseDirectories = false
							panel.canChooseFiles = true
		
						if panel.runModal() == .OK {
							if let url = panel.url {
                                print(url)
							}
						}
					}
				
				Text("Open with...")
				Picker("", selection: $openWithSelection) {
					ForEach(Array(zip(openableApps.indices, openableApps)), id: \.0) { index, app in
						HStack {
							Image(nsImage: LaunchInstance.getIcon(for: app, size: 16))
							Text(app.lastPathComponent)
						}.tag(index)
					}
				}
				.pickerStyle(PopUpButtonPickerStyle())
				.onChange(of: openWithSelection) { appIdx in
                    workspace.launcher.instances[workspace.launcher.selected!].app = openableApps[appIdx]
					
					let url = URL(fileURLWithPath: name)
					print("""
						- Path: \(url.path)
						- Is directory?: \(url.hasDirectoryPath)
						- Is file?: \(url.isFileURL)
						- Scheme: \(url.scheme)
						- Last Path Component: \(url.lastPathComponent)
						- Extension: \(url.pathExtension)
						- File exitsts?: \(FileManager.default.fileExists(atPath: url.path))
						- urlForApp: \(NSWorkspace.shared.urlForApplication(toOpen: url))
					""")
				}
				
				Text("Name")

				TextField("", text: $name)
					.textFieldStyle(RoundedBorderTextFieldStyle())
			}
		}
	}
}

struct LaunchAppDetail: View {
	@EnvironmentObject var navigator: Navigator
	
    var body: some View {
		SwitchRoutes {
			Route(path: "/workspace-launcher/file") {
				FileDetail()
			}
			Route(path: "/workspace-launcher/folder") {
				Text("Folder")
			}
			Route(path: "/workspace-launcher/application") {
				Text("Application")
			}
		}
    }
}

struct LaunchAppDetail_Previews: PreviewProvider {
    static var previews: some View {
        LaunchAppDetail()
    }
}
