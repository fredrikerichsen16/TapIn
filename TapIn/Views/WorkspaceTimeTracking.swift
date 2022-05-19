//
//  WorkspaceTimeTracking.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 26/06/2021.
//

import SwiftUI
import RealmSwift

struct WorkspaceTimeTracking: View {
    @ObservedRealmObject var timeTracker: TimeTrackerDB
    
    var status: String {
        let startOfDay = Calendar.current.startOfDay(for: Date.init())
        let amountWorkedToday = timeTracker.workspace.first!.getWorkDuration(dateInterval: DateInterval(start: startOfDay, end: startOfDay.advanced(by: 60 * 60 * 24)))
        let amountWorkedTodayMinutes = Int(amountWorkedToday / 60)
        
        return "You have worked \(amountWorkedTodayMinutes) minutes today!"
    }
    
    var body: some View {
        Text(status)
            .font(.headline)
    }
}

//struct WorkspaceTimeTracking_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkspaceTimeTracking()
//    }
//}
