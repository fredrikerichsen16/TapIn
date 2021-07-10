import CoreData

struct PersistenceController {
	
	static let shared = PersistenceController()
	
	let container: NSPersistentContainer
	
	init() {
		container = NSPersistentContainer(name: "TapInDataModel")
//		container.loadPersistentStores { (storeDescription, error) in
//			if let error = error as NSError? {
//				fatalError("Unresolved error: \(error.localizedDescription)")
//			}
//		}
	}
	
	func save(completion: @escaping (Error?) -> Void = {_ in}) {
		let context = container.viewContext
		
		guard context.hasChanges else { return }
		
		do {
			try context.save()
			completion(nil)
		} catch {
			completion(error)
		}
	}
	
	func delete(_ object: NSManagedObject, completion: @escaping (Error?) -> Void = {_ in}) {
		let context = container.viewContext
		context.delete(object)
		
		save(completion: completion)
	}
	
}
