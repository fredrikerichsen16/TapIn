import Foundation

class ClampedFormatter: Formatter {
    var lower: Int
    var upper: Int

    init(min: Int, max: Int) {
        self.lower = min
        self.upper = max
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func string(for obj: Any?) -> String? {
        guard let number = obj as? Int else {
            return nil
        }
        return String(number)
    }

    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {

        guard let number = Int(string) else {
            return false
        }
        
        obj?.pointee = max(min(number, upper), lower) as AnyObject
        
        return true
    }
}
