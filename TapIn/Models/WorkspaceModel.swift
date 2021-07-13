//
//  WorkspaceModel.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 20/06/2021.
//

import SwiftUI
import CoreData

final class WorkspaceModel: ObservableObject {
    @Published var uuid = UUID()
	@Published var name: String
    @Published var parent: WorkspaceModel?
    @Published var work: Bool
	
    init(name: String, parent: WorkspaceModel? = nil, work: Bool = true) {
		self.name = name
        self.parent = parent
        self.work = work
	}
	
	@Published var pomodoro: PomodoroModel = PomodoroModel()
	@Published var timeTracker: TimeTrackerModel = TimeTrackerModel()
	@Published var launcher: LauncherModel = LauncherModel()
	@Published var blocker: BlockerModel = BlockerModel()
}
