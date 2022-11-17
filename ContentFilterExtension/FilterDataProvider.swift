import NetworkExtension

class FilterDataProvider: NEFilterDataProvider {
        
    private var blacklist: [String] = []
    private var terminateAtTime: TimeInterval = 0

    override func startFilter(completionHandler: @escaping (Error?) -> Void) {
        if let config = filterConfiguration.vendorConfiguration
        {
            if let blacklist = config["blacklist"] as? [String]
            {
                self.blacklist = blacklist
            }
            
            if let terminateAtTime = config["terminateAtTime"] as? TimeInterval {
                self.terminateAtTime = terminateAtTime
            }
        }
        
        // Add code to initialize the filter.
        completionHandler(nil)
    }
    
//    override func stopFilter(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
//        // Add code to clean up filter resources.
//        completionHandler()
//    }
    
    override func handleNewFlow(_ flow: NEFilterFlow) -> NEFilterNewFlowVerdict {
        if terminateAtTime < Date.now.timeIntervalSince1970
        {
            stopFilter(with: .userInitiated, completionHandler: {})
            return .allow()
        }
        
        if let url = flow.url?.absoluteString {
            if blacklist.contains(where: { url.contains($0) }) {
                return .drop()
            }
        }
        
        return .allow()
    }
    
}
