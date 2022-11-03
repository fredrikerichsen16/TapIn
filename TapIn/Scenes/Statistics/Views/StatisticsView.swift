import SwiftUI
import RealmSwift
import Charts

// Set up simple SwiftUI view
struct StatisticsView: View {
    @StateObject var vm = StatisticsState()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Statistics").font(.largeTitle)

            HStack {
                Picker("Time Unit", selection: $vm.interval.granularity) {
                    Text("Week").tag(TimeGranularity.week)
                    Text("Month").tag(TimeGranularity.month)
                    Text("Year").tag(TimeGranularity.year)
                }
                .fixedSize()
                .onChange(of: vm.interval.granularity) { _ in
                    vm.submit()
                }

                Spacer()

                Button(action: vm.reduceUnit, label: {
                    Image(systemName: "chevron.left")
                })

                Button("This \(vm.interval.granularity.rawValue)", action: vm.resetToNow)

                Button(action: vm.increaseUnit, label: {
                    Image(systemName: "chevron.right")
                })
            }

            Text(vm.interval.label)
                .font(.headline)
            
            chart
            
            table
            
            Spacer()
        }
        .onAppear {
            vm.submit()
        }
        .padding(25)
    }
    
    // MARK: Chart
    
    var chart: some View {
        Chart(vm.sessionData) { data in
            BarMark(
                x: .value("Time", data.intervalLabel),
                y: .value("Minutes", data.minutes / 60)
            )
            .foregroundStyle(by: .value("Workspace", data.workspace.name))
        }
        .chartXAxisLabel(position: .bottom, alignment: .center) {
            Text("Period")
        }
        .chartYAxisLabel(position: .trailing, alignment: .center) {
            Text("Average minutes worked per day")
        }
        
    }
    
    var table: some View {
        Text("Table")
    }
    
//    var chart: some View {
//        // Create  table showing contents of sessions
//        List(vm.sessions) { session in
//            HStack {
//                Text(session.workspace.name)
//                Text("\(session.duration) min")
//                Text("\(session.completedTime)")
//            }
//        }
//
//        List {
//            Text("Number completed sessions: \(vm.numSessions)")
//            Text("Duration worked: \(vm.workDuration)")
//        }
//    }
}
