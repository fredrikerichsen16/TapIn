//
//  LauncherPopups.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 26/06/2021.
//

import SwiftUI
import SwiftUIRouter
import RealmSwift

struct Popover: View {
    @Environment(\.realm) var realm
	@EnvironmentObject var navigator: Navigator
    
    @ObservedRealmObject var launcher: LauncherDB
    @Binding var selection: Int?
    @Binding var showingPopover: Bool
    
    func createEmptyWebsiteInstance() {
        let newInstance = LauncherInstanceDB(
            name: RealmLauncherType.website.label(),
            type: .website,
            instantiated: true,
            appPath: nil,
            filePath: nil,
            launchDelay: 0.0,
            hideOnLaunch: false
        )
        
        $launcher.launcherInstances.append(newInstance)
        
        showingPopover = false
    }
    
    func createEmptyInstance(type: RealmLauncherType) {
        let newInstance = LauncherInstanceDB(name: type.label(), type: type, instantiated: false)
        
        $launcher.launcherInstances.append(newInstance)
        
        print(launcher.launcherInstances.count)
        
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
                createEmptyWebsiteInstance()
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
