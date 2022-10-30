//
//  WorkspaceTimeTracking.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 26/06/2021.
//

import SwiftUI
import RealmSwift

struct WorkspaceTimeTracking: View {
    @EnvironmentObject var workspaceVM: WorkspaceVM
    
    var timeTrackerState: TimeTrackerState {
        workspaceVM.timeTrackerState
    }
    
    var status: String {
        let startOfDay = Calendar.current.startOfDay(for: Date.init())
        let amountWorkedToday = workspaceVM.workspace.getWorkDuration(dateInterval: DateInterval(start: startOfDay, end: startOfDay.advanced(by: 60 * 60 * 24)))
        let amountWorkedTodayMinutes = Int(amountWorkedToday / 60)
        
        return "You have worked \(amountWorkedTodayMinutes) minutes today!"
    }
    
    var body: some View {
        Text(status)
            .font(.headline)
        Text("This application tracks how many minutes you work each day broken down by category. Every time you complete a pomodoro session, the amount of time you worked is logged. Alternatively you can turn on time tracking manually.")
    }
}

//struct WorkspaceTimeTracking_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkspaceTimeTracking()
//    }
//}
