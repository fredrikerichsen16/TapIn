import NetworkExtension

func log(_ str: String) {
    let filename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("output.txt")

    do {
        try str.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
    } catch {
        
    }
}

class FilterDataProvider: NEFilterDataProvider {

    override func startFilter(completionHandler: @escaping (Error?) -> Void) {
//        let hostEndpoint = NWHostEndpoint(hostname: "www.instagram.com", port: "443")
//        let networkRule = NENetworkRule(destinationHost: hostEndpoint, protocol: .any)
//        let rule = NEFilterRule(networkRule: networkRule, action: .drop)
//        let settings = NEFilterSettings(rules: [rule], defaultAction: .drop)
//        apply(settings) { error in
//            completionHandler(error)
//        }
        
        // Add code to initialize the filter.
        completionHandler(nil)
    }
    
    override func stopFilter(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        // Add code to clean up filter resources.
        completionHandler()
    }
    
//    override func handleOutboundDataComplete(for flow: NEFilterFlow) -> NEFilterDataVerdict {
//        if let url = flow.url?.absoluteString {
//            if url.contains("facebook") {
//                return .drop()
//            }
//        }
//
//        return .allow()
//    }
    
    override func handleNewFlow(_ flow: NEFilterFlow) -> NEFilterNewFlowVerdict {
//        guard let socketFlow = flow as? NEFilterSocketFlow,
//              let remoteEndpoint = socketFlow.remoteEndpoint
//        else { return .drop() }
        
        if let url = flow.url?.absoluteString {
            if url.contains("facebook") {
                return .drop()
            }
        }
        
        
        if let socketFlow = flow as? NEFilterSocketFlow,
           let url = socketFlow.url?.absoluteString {
            if url.contains("youtube") {
                return .drop()
            }
        }
        
        return .allow()

//        if let host = flow.getHost()?.lowercased() {
//            if host.contains("151.101.193.140") || host.contains("151.101.65.140") || host.contains("151.101.129.140") || host.contains("151.101.1.140") {
//                return .drop()
//            }
//
//            return .allow()
//        } else {
//            return .allow()
//        }

//        let urlString = url.absoluteString
//
//        if urlString.contains("facebook") || urlString.contains("youtube") {
//            return .drop()
//        }
//
//        return .allow()
    }
}

extension NEFilterFlow {
    func getHost() -> String? {
        if let host = self.url?.host {
            return host
        }
        
        if let socketFlow = self as? NEFilterSocketFlow,
           let remoteEndpoint = socketFlow.remoteEndpoint as? NWHostEndpoint {
            return remoteEndpoint.hostname
        }
        
        return nil
    }
}
