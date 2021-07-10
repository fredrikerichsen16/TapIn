import SwiftUI
import SwiftUIRouter

struct SelectedApp {
	var file: URL
	var _openWith: URL?
	var openWith: URL? {
		get {
			if _openWith != nil
			{
				return _openWith
			}
			else
			{
				return NSWorkspace.shared.urlForApplication(toOpen: file) ?? nil
			}
		}
		set {
			_openWith = newValue
		}
	}
	
	func getIcon(size: Int = 80) -> NSImage {
		var image = NSWorkspace.shared.icon(forFile: openWith?.path ?? "")
		
		if self.openWith != nil
		{
			image = NSWorkspace.shared.icon(forFile: file.path)
		}
		else
		{
			image = NSWorkspace.shared.icon(forFile: openWith!.path)
		}
		
		image.size = NSSize(width: size, height: size)
		
		return image
	}
	
	static func getIcon(url: URL, size: Int = 128) -> NSImage {
		let image: NSImage = NSWorkspace.shared.icon(forFile: url.path)
		
		image.size = NSSize(width: size, height: size)
		
		return image
	}
	
	func getCompatibleApps() -> [URL] {
		let cfUrl = file as CFURL

		var URLs: [URL] = []
		
		if let appURLs = LSCopyApplicationURLsForURL(cfUrl, .all)?.takeRetainedValue()
		{
			for url in appURLs as! [URL] {
				URLs.append(url)
			}
		}
		
		return URLs
	}
}

struct FileDetail: View {
	@State var selectedApp: SelectedApp? = nil
	@State private var openWithSelection: Int = 0
	@State private var name: String = ""
	@State private var openableApps: [URL] = []
	
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
								self.selectedApp = SelectedApp(file: url)
								
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
								
								let cfUrl = url as CFURL

								print("Can Open With:")
								if let applicationURLs = LSCopyApplicationURLsForURL(cfUrl, .all)?.takeRetainedValue() {
									print(applicationURLs)
								}
							}
						}
					}
				
				Text("Drop a file here (or click to upload)")
					.font(.body)
					.padding()
			}
			else
			{
				Image(nsImage: selectedApp!.getIcon())
					.font(.system(size: 80))
					.onTapGesture {
						let panel = NSOpenPanel()
							panel.allowsMultipleSelection = false
							panel.canChooseDirectories = false
							panel.canChooseFiles = true
		
						if panel.runModal() == .OK {
							if let url = panel.url {
								self.selectedApp = SelectedApp(file: url)
								openableApps = selectedApp!.getCompatibleApps()
								
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
								
								let cfUrl = url as CFURL

								print("Can Open With:")
								if let applicationURLs = LSCopyApplicationURLsForURL(cfUrl, .all)?.takeRetainedValue() {
									print(applicationURLs)
								}
							}
						}
					}
				
				Text("Open with...")
				Picker("", selection: $openWithSelection) {
					ForEach(Array(zip(openableApps.indices, openableApps)), id: \.0) { index, app in
						HStack {
							Image(nsImage: SelectedApp.getIcon(url: app, size: 16))
							Text(app.lastPathComponent)
						}.tag(index)
					}
				}
				.pickerStyle(PopUpButtonPickerStyle())
				.onChange(of: openWithSelection) { appIdx in
					print("Hei")
					selectedApp?.openWith = openableApps[appIdx]
					
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
