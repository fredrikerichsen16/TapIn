import SwiftUI
import RealmSwift
import Charts

// Set up simple SwiftUI view
struct StatisticsView: View {
    @StateObject var vm = StatisticsState()
    
    @State private var showChart = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Statistics").font(.largeTitle)

            HStack {
                Picker("", selection: $vm.interval.granularity) {
                    Text("Week").tag(TimeGranularity.week)
                    Text("Month").tag(TimeGranularity.month)
                    Text("Year").tag(TimeGranularity.year)
                }
                .fixedSize()
                .onChange(of: vm.interval.granularity) { _ in
                    vm.submit()
                }
                
                Picker("", selection: $showChart) {
                    Image(systemName: IconKeys.piechart).tag(true)
                    Image(systemName: IconKeys.bulletlist).tag(false)
                }
                .pickerStyle(.segmented)
                .fixedSize()

                Spacer()

                Button(action: vm.reduceUnit, label: {
                    Image(systemName: IconKeys.left)
                })

                Button("This \(vm.interval.granularity.rawValue)", action: vm.resetToNow)

                Button(action: vm.increaseUnit, label: {
                    Image(systemName: IconKeys.right)
                })
            }

            Text(vm.interval.label)
                .font(.headline)
            
            if showChart {
                chart
            } else {
                table
            }
            
            Spacer()
        }
        .onAppear {
            vm.submit()
        }
        .padding(25)
    }
    
    // MARK: Chart
    
    var chart: some View {
        Chart(vm.chartData) { data in
            BarMark(
                x: .value("Time", data.intervalLabel),
                y: .value("Minutes", data.hours)
            )
            .foregroundStyle(by: .value("Workspace", data.workspace.name))
            .cornerRadius(2)
        }
        .chartXAxisLabel(position: .bottom, alignment: .center) {
            Text("Period")
        }
        .chartYAxisLabel(position: .trailing, alignment: .center) {
            Text("Average hours worked per day")
        }
    }
    
    var table: some View {
        VStack {
            ForEach(vm.listData) { data in
                HStack {
                    Text(data.name)
                    Spacer()
                    Text(data.formattedDuration)
                }
                .padding()
                .background(Color.gray)
                
                if let children = data.children
                {
                    VStack {
                        ForEach(children) { child in
                            HStack {
                                Text(child.name)
                                Spacer()
                                Text(child.formattedDuration)
                            }
                            .padding()
                            .background(Color.blue)
                        }
                        .offset(x: 20)
                    }
                }
            }
        }
    }
}
