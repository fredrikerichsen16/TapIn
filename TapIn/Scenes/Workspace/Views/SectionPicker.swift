//
//  SectionPicker.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 19/02/2022.
//

import SwiftUI
import SwiftUIRouter

struct SectionPicker: View {
    @State var pageSelection = "workspace-pomodoro"
    @EnvironmentObject var navigator: Navigator
    
    var body: some View {
        HStack(alignment: .center) {
            Picker("", selection: $pageSelection) {
                Text("Pomodoro").tag("workspace-pomodoro")
                Text("Time Tracking").tag("workspace-timetracking")
                Text("Launcher").tag("workspace-launcher")
                Text("Blocker").tag("workspace-blocker")
                Image(systemName: "ellipsis")
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: pageSelection) { selection in
                guard selection != "more" else { return }

                navigator.navigate("/" + selection, replace: true)
            }
            .frame(width: 400)
        }
    }
}

struct SectionPicker_Previews: PreviewProvider {
    static var previews: some View {
        SectionPicker()
    }
}
