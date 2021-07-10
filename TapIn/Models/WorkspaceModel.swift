//
//  WorkspaceModel.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 20/06/2021.
//

import SwiftUI
import CoreData

final class WorkspaceModel: ObservableObject {
	var name: String
	
	init(name: String) {
		self.name = name
	}
	
//	@Published var pomodoro: PomodoroModel = PomodoroModel()
//	@Published var timeTracker: TimeTrackerModel = TimeTrackerModel()
//	@Published var launcher: LauncherModel = LauncherModel()
//	@Published var blocker: BlockerModel = BlockerModel()
}
