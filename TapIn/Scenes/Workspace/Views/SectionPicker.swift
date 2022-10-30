import SwiftUI
import SwiftUIRouter

struct SectionPicker: View {
    @State var selection = Route.pomodoro
    
    var body: some View {
        HStack(alignment: .center) {
            Picker("", selection: $selection) {
                NavigationLink("Pomodoro", value: Route.pomodoro)
                NavigationLink("Time Tracking", value: Route.timetracker)
                NavigationLink("Launcher", value: Route.launcher)
                NavigationLink("Blocker", value: Route.blocker)
//                Image(systemName: "ellipsis")
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 400)
        }
    }
}

struct SectionPicker_Previews: PreviewProvider {
    static var previews: some View {
        SectionPicker()
    }
}
