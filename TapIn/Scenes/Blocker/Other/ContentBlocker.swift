import NetworkExtension
import SystemExtensions

enum BlockerStatus {
    case active
    case inactive
    case indeterminate
}

class ContentBlocker: NSObject {
    
    static let shared = ContentBlocker()

    var status = BlockerStatus.indeterminate
    
    // Get the Bundle of the system extension.
    lazy var extensionBundle: Bundle = {
        let extensionsDirectoryURL = URL(fileURLWithPath: "Contents/Library/SystemExtensions", relativeTo: Bundle.main.bundleURL)
        let extensionURLs: [URL]
        do
        {
            extensionURLs = try FileManager.default.contentsOfDirectory(at: extensionsDirectoryURL,
                                                                        includingPropertiesForKeys: nil,
                                                                        options: .skipsHiddenFiles)
        }
        catch let error
        {
            fatalError("Failed to get the contents of \(extensionsDirectoryURL.absoluteString): \(error.localizedDescription)")
        }

        guard let extensionURL = extensionURLs.first else {
            fatalError("Failed to find any system extensions")
        }

        guard let extensionBundle = Bundle(url: extensionURL) else {
            fatalError("Failed to create a bundle with URL \(extensionURL.absoluteString)")
        }

        return extensionBundle
    }()
    
    private var blacklist: [String] = []
    
    func setBlacklist(_ blacklist: [String]) {
        self.blacklist = blacklist
    }
    
    func start() {
        status = .indeterminate
        
        guard !NEFilterManager.shared().isEnabled else {
            print("Enabled")
            return
        }
        
        guard let extensionIdentifier = extensionBundle.bundleIdentifier else {
            return
        }
        
        let activationRequest = OSSystemExtensionRequest.activationRequest(forExtensionWithIdentifier: extensionIdentifier, queue: .main)
            activationRequest.delegate = self

        OSSystemExtensionManager.shared.submitRequest(activationRequest)
    }
    
    func stop() {
        NEFilterManager.shared().isEnabled = false
        NEFilterManager.shared().saveToPreferences { error in
            if let error
            {
                print("Failed to disable the filter configuration: \(error.localizedDescription)")
                self.status = .inactive
                return
            }
        }
    }

    func enableFilterConfiguration() {
        let filterManager = NEFilterManager.shared()
        
        guard !filterManager.isEnabled else {
            print("Already enabled")
            return
        }
        
        loadFilterConfiguration(success: {
            let providerConfiguration = NEFilterProviderConfiguration()
                providerConfiguration.filterPackets = false
                providerConfiguration.filterSockets = true
                providerConfiguration.username = "Tapin"
                providerConfiguration.organization = "Tapin"
                providerConfiguration.vendorConfiguration = [:]
                providerConfiguration.vendorConfiguration!["blacklist"] = self.blacklist
                providerConfiguration.filterDataProviderBundleIdentifier = self.extensionBundle.bundleIdentifier
            
            filterManager.providerConfiguration = providerConfiguration
            filterManager.isEnabled = true
            
            filterManager.saveToPreferences { error in
                if let error {
                    print("Failed to save _the_ filter configuration: \(error.localizedDescription)")
                    self.status = .inactive
                    return
                }
                
                print("DID START")
            }
        }, failure: {
            self.status = .inactive
        })
    }
    
    func loadFilterConfiguration(success: @escaping () -> Void, failure: @escaping () -> Void) {
        NEFilterManager.shared().loadFromPreferences { error in
            DispatchQueue.main.async {
                if let error {
                    print("Failed to load the filter configuration: \(error.localizedDescription)")
                    return failure()
                }
                
                return success()
            }
        }
    }
    
}

extension ContentBlocker: OSSystemExtensionRequestDelegate {

    // MARK: OSSystemExtensionActivationRequestDelegate
    func request(_ request: OSSystemExtensionRequest, didFinishWithResult result: OSSystemExtensionRequest.Result) {
        guard result == .completed else {
            print("Unexpected result \(result.rawValue) for system extension request")
            status = .inactive
            return
        }

        enableFilterConfiguration()
    }

    func request(_ request: OSSystemExtensionRequest, didFailWithError error: Error) {
        print("System extension request failed: \(error.localizedDescription)")
        status = .inactive
    }

    func requestNeedsUserApproval(_ request: OSSystemExtensionRequest) {
        print("Extension \(request.identifier) requires user approval")
    }

    func request(_ request: OSSystemExtensionRequest,
                 actionForReplacingExtension existing: OSSystemExtensionProperties,
                 withExtension extension: OSSystemExtensionProperties) -> OSSystemExtensionRequest.ReplacementAction {

        print("Replacing extension \(request.identifier) version \(existing.bundleShortVersion) with version \(`extension`.bundleShortVersion)")
        return .replace
    }
}
