import NetworkExtension

class FilterDataProvider: NEFilterDataProvider {
    
    private var blacklist: [String] = []

    override func startFilter(completionHandler: @escaping (Error?) -> Void) {
        if let config = filterConfiguration.vendorConfiguration,
           let blacklist = config["blacklist"] as? [String]
        {
            self.blacklist = blacklist
        }
        
        // Add code to initialize the filter.
        completionHandler(nil)
    }
    
    override func stopFilter(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        // Add code to clean up filter resources.
        completionHandler()
    }
    
    override func handleNewFlow(_ flow: NEFilterFlow) -> NEFilterNewFlowVerdict {
        if let url = flow.url?.absoluteString {
            if blacklist.contains(where: { url.contains($0) }) {
                return .drop()
            }
        }
        
        return .allow()
    }
}
