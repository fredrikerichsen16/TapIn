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
    @EnvironmentObject var workspaces: Workspaces
    
    @Binding var selection: Int?
    
    func createEmptyInstance(type: LauncherType) {
        if let ws = workspaces.activeWorkspace
        {
            ws.launcher.createEmptyLaunchInstance(type: type)
            self.selection = ws.launcher.instances.count - 1
        }
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
