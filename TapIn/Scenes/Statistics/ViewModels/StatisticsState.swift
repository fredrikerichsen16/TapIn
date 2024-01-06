import Foundation
import RealmSwift
import Factory

class StatisticsState: ObservableObject {
    @Injected(\.realmManager) var realmManager
    
    @Published
    var workspaces: Results<WorkspaceDB>
    
    init() {
        let realm = Container.shared.realmManager.callAsFunction().realm
        self.workspaces = realm.objects(WorkspaceDB.self)
    }

    // MARK: Dates
    @Published var interval = IntervalHolder()

    func reduceUnit() {
        interval.reduceUnit()
        refresh()
    }

    func increaseUnit() {
        interval.increaseUnit()
        refresh()
    }
    
    func resetToNow() {
        interval.reset()
        refresh()
    }

    @Published var chartData = [ChartData]()
    @Published var listData = [ListData]()
    
    func refresh() {
        let frozen = realmManager.realm.freeze()
        
        Task {
            let queryer = SessionHistoryQueryer(realm: frozen)
                queryer.completed(within: interval)

            let charter = queryer.getCharter(for: interval)

            DispatchQueue.main.async {
                self.chartData = charter.chart()
                self.listData = charter.list()
            }
        }
    }
}
