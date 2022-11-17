import Foundation
import RealmSwift

class StatisticsState: ObservableObject {
    @Published var workspaces: Results<WorkspaceDB>
    
    var realm: Realm {
        RealmManager.shared.realm
    }

    init() {
        let realm = RealmManager.shared.realm
        self.workspaces = realm.objects(WorkspaceDB.self)
    }

    // MARK: Dates
    @Published var interval = IntervalHolder()

    func reduceUnit() {
        interval.reduceUnit()
        submit()
    }

    func increaseUnit() {
        interval.increaseUnit()
        submit()
    }
    
    func resetToNow() {
        interval.reset()
        submit()
    }

    @Published var chartData = [ChartData]()
    @Published var listData = [ListData]()
    
    func submit() {
        let frozen = realm.freeze()
        
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
