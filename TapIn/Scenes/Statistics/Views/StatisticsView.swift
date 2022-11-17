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
            
            if #available(macOS 13.0, *)
            {
                if showChart
                {
                    if vm.chartData.isEmpty
                    {
                        Spacer()
                        Text("No work was logged in this period.")
                    }
                    else
                    {
                        chart
                    }
                }
                else
                {
                    if vm.listData.isEmpty
                    {
                        Spacer()
                        Text("No work was logged in this period.")
                    }
                    else
                    {
                        table
                    }
                }
            }
            else
            {
                Spacer()
                Text("Chart is only supported by MacOS Ventura (13.0) and later.")
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
                y: .value("Minutes", data.minutes)
            )
            .foregroundStyle(by: .value("Workspace", data.workspace.name))
            .cornerRadius(2)
        }
        .chartXAxisLabel(position: .bottom, alignment: .center) {
            Text("Period")
        }
        .chartYAxisLabel(position: .trailing, alignment: .center) {
            Text("Average minutes worked per day")
        }
    }
    
    var table: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Total time worked in this period by folder and workspace")
                .font(.system(size: 20))
        
            ScrollView(showsIndicators: false) {
                ForEach(vm.listData) { data in
                    Spacer().frame(height: 30)
                    
                    TotalTimeWorkedBoxComponent(folder: true, data: data)
                    
                    if let children = data.children
                    {
                        ForEach(children) { child in
                            TotalTimeWorkedBoxComponent(folder: false, data: child)
                        }
                    }
                }
            }
        }
    }
}
