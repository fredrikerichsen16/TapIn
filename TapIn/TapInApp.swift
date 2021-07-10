
//
//  TapinApp.swift
//  Tapin
//
//  Created by Fredrik Skjelvik on 20/06/2021.
//

import SwiftUI

@main
struct TapinApp: App {
	
	let persistenceController = PersistenceController.shared
	
	@Environment(\.scenePhase) var scenePhase
	
	var body: some Scene {
		WindowGroup {
			ContentView()
				.frame(minWidth: 500, idealWidth: 700, maxWidth: 900, minHeight: 500, idealHeight: 500, maxHeight: 900, alignment: .center)
				.environment(\.managedObjectContext, persistenceController.container.viewContext)
		}
		.windowStyle(HiddenTitleBarWindowStyle())
		.onChange(of: scenePhase) { (newScenePhase) in
			switch newScenePhase {
				case .background:
					print("Scene: Background")
					persistenceController.save()
				case .inactive:
					print("Scene: Inactive")
				case .active:
					print("Scene: Active")
				@unknown default:
					print("Scene: Unknown")
			}
		}
	}
	
}
