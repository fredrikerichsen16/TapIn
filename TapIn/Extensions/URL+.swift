import Cocoa

extension URL {
    var fileName: String {
        let cutLocation = lastPathComponent.lastIndex(of: ".") ?? lastPathComponent.endIndex
        return String(lastPathComponent[lastPathComponent.startIndex ..< cutLocation])
    }
}

