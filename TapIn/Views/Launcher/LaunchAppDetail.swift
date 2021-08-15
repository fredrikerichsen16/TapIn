import SwiftUI
import SwiftUIRouter

//struct FileDetail: View {
//	@State private var openWithSelection: Int = 0
//	@State private var name: String = ""
//	@State private var openableApps: [URL] = []
//
//    @EnvironmentObject var workspaces: Workspaces
//
//    var selectedWorkspace: Workspace {
//        workspaces.activeWorkspace!
//    }
//
//    var selectedApp: LaunchInstance? {
//        if let selected = workspaces.activeWorkspace!.launcher.selected
//        {
//            return workspaces.activeWorkspace!.launcher.instances[selected]
//        }
//        else
//        {
//            return nil
//        }
//    }
//
//	var body: some View {
//		VStack(alignment: .center) {
//			if selectedApp == nil
//			{
//				Image(systemName: "square.and.arrow.down")
//					.font(.system(size: 60))
//					.onTapGesture {
//						let panel = NSOpenPanel()
//							panel.allowsMultipleSelection = false
//							panel.canChooseDirectories = true
//
//						if panel.runModal() == .OK {
//							if let url = panel.url {
//                                selectedWorkspace.launcher.createLaunchInstance(name: url.lastPathComponent, appFirst: false, app: nil, file: url)
//                                selectedWorkspace.launcher.selected = selectedWorkspace.launcher.instances.count - 1
//
//                                self.openableApps = selectedApp!.getCompatibleApps()
//							}
//						}
//					}
//
//				Text("Drop a file here (or click to upload)")
//					.font(.body)
//					.padding()
//			}
//			else
//			{
//                Image(nsImage: LaunchInstance.getIcon(for: selectedApp!.getApp(), size: 128))
//					.font(.system(size: 80))
//					.onTapGesture {
//						let panel = NSOpenPanel()
//							panel.allowsMultipleSelection = false
//							panel.canChooseDirectories = false
//							panel.canChooseFiles = true
//
//						if panel.runModal() == .OK {
//							if let url = panel.url {
//                                print(url)
//							}
//						}
//					}
//
//				Text("Open with...")
//				Picker("", selection: $openWithSelection) {
//					ForEach(Array(zip(openableApps.indices, openableApps)), id: \.0) { index, app in
//						HStack {
//							Image(nsImage: LaunchInstance.getIcon(for: app, size: 16))
//							Text(app.lastPathComponent)
//						}.tag(index)
//					}
//				}
//				.pickerStyle(PopUpButtonPickerStyle())
//				.onChange(of: openWithSelection) { appIdx in
//                    selectedWorkspace.launcher.instances[selectedWorkspace.launcher.selected!].app = openableApps[appIdx]
//
//					let url = URL(fileURLWithPath: name)
//					print("""
//						- Path: \(url.path)
//						- Is directory?: \(url.hasDirectoryPath)
//						- Is file?: \(url.isFileURL)
//						- Scheme: \(url.scheme)
//						- Last Path Component: \(url.lastPathComponent)
//						- Extension: \(url.pathExtension)
//						- File exitsts?: \(FileManager.default.fileExists(atPath: url.path))
//						- urlForApp: \(NSWorkspace.shared.urlForApplication(toOpen: url))
//					""")
//				}
//
//				Text("Name")
//
//				TextField("", text: $name)
//					.textFieldStyle(RoundedBorderTextFieldStyle())
//			}
//		}
//	}
//}

struct LaunchAppDetail: View {
	@EnvironmentObject var navigator: Navigator
    @EnvironmentObject var workspaces: Workspaces
	
    var displayName: String {
        if let ws = workspaces.activeWorkspace,
           let selected = ws.launcher.selected {
            return selected.name
        }
        
        return "N/A"
    }
    
    var body: some View {
        Text(displayName).font(.largeTitle)
//		SwitchRoutes {
//			Route(path: "/workspace-launcher/file") {
//				FileDetail()
//			}
//			Route(path: "/workspace-launcher/folder") {
//				Text("Folder")
//			}
//			Route(path: "/workspace-launcher/application") {
//				Text("Application")
//			}
//		}
    }
}

struct LaunchAppDetail_Previews: PreviewProvider {
    static var previews: some View {
        LaunchAppDetail()
    }
}
