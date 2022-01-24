//
//  LauncherPopups.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 26/06/2021.
//

import SwiftUI
import SwiftUIRouter

struct Popover: View {
	@EnvironmentObject var navigator: Navigator
    @EnvironmentObject var workspace: Workspace
    
    @Binding var selection: Int?
    @Binding var showingPopover: Bool
    
    func createEmptyInstance(type: LauncherType) {
        workspace.launcher.addInstance(instance: LaunchInstanceBridge.createEmptyLauncher(type: type))
		self.selection = workspace.launcher.instances.count - 1
		showingPopover = false
    }
	
	var body: some View {
		List {
			Button(action: {
                createEmptyInstance(type: .file)
			}, label: {
				Label("File", systemImage: "doc")
			})
			.buttonStyle(PlainButtonStyle())
			
			Button(action: {
                createEmptyInstance(type: .folder)
			}, label: {
				Label("Folder", systemImage: "folder")
			})
			.buttonStyle(PlainButtonStyle())
			
			Button(action: {
                createEmptyInstance(type: .app)
			}, label: {
				Label("Application", systemImage: "music.note")
			})
			.buttonStyle(PlainButtonStyle())
			
			Button(action: {
                createEmptyInstance(type: .website)
			}, label: {
				Label("Website", systemImage: "link")
			})
			.buttonStyle(PlainButtonStyle())
			
			Button(action: {
//                createEmptyInstance(type: .app)
			}, label: {
				Label("Terminal", systemImage: "terminal")
			})
			.buttonStyle(PlainButtonStyle())
			
			Button(action: {
//                createEmptyInstance(type: .app)
			}, label: {
				Label("Automation", systemImage: "paperplane")
			})
			.buttonStyle(PlainButtonStyle())
		}
		.frame(width: 160, height: 165)
	}
}

//struct Popover_Previews: PreviewProvider {
//    static var previews: some View {
//		Popover()
//    }
//}
