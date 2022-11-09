import Foundation

@propertyWrapper
/// Property wrapper to use on properties that index an array. Makes sure the index never goes out of bounds of the array it is indexing.
struct IndexingCollection {
    var collectionLength: Int
    var index: Int
    
    init(wrappedValue: Int, collectionLength: Int) {
        self.index = wrappedValue
        self.collectionLength = collectionLength
    }

    var wrappedValue: Int {
        get
        {
            return index
        }
        set
        {
            if newValue < 0
            {
                self.index = collectionLength - 1
            }
            else if newValue >= collectionLength
            {
                self.index = 0
            }
            else
            {
                self.index = newValue
            }
        }
    }
}
