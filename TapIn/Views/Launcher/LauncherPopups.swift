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
	
	var body: some View {
		List {
			Button(action: {
                workspaces.activeWorkspace!.launcher.selected = nil
				navigator.navigate("/workspace-launcher/file")
			}, label: {
				Label("File", systemImage: "doc")
			})
			.buttonStyle(PlainButtonStyle())
			
			Button(action: {
				navigator.navigate("/workspace-launcher/folder")
			}, label: {
				Label("Folder", systemImage: "folder")
			})
			.buttonStyle(PlainButtonStyle())
			
			Button(action: {
				navigator.navigate("/workspace-launcher/application")
			}, label: {
				Label("Application", systemImage: "music.note")
			})
			.buttonStyle(PlainButtonStyle())
			
			Button(action: {
				navigator.navigate("/workspace-launcher/website")
			}, label: {
				Label("Website", systemImage: "link")
			})
			.buttonStyle(PlainButtonStyle())
			
			Button(action: {
				navigator.navigate("/workspace-launcher/terminal")
			}, label: {
				Label("Terminal", systemImage: "terminal")
			})
			.buttonStyle(PlainButtonStyle())
			
			Button(action: {
				navigator.navigate("/workspace-launcher/automation")
			}, label: {
				Label("Automation", systemImage: "paperplane")
			})
			.buttonStyle(PlainButtonStyle())
		}
		.frame(width: 160, height: 165)
	}
}

struct Popover_Previews: PreviewProvider {
    static var previews: some View {
		Popover()
    }
}
