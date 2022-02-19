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
    
    var body: some View {
        Text("WorkspaceTimeTracking (ID: \(timeTracker.id))")
    }
}

//struct WorkspaceTimeTracking_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkspaceTimeTracking()
//    }
//}
