import Cocoa

struct UninstantiatedWebLauncher: BaseLauncherInstanceBehavior, WebBasedBehavior {
    init(instance: LauncherInstanceDB) {
        self.object = instance
    }
    
    var object: LauncherInstanceDB
    let type = RealmLauncherType.website
    
    func setName(name: String) {
        write {
            object.name = name
        }
    }
    
    func setUrl(urlString: String) {
        guard let url = convertURL(urlString: urlString) else {
            return
        }
        
        write {
            object.fileUrl = url
            object.instantiated = true
        }
    }
}

struct InstantiatedWebLauncher: BaseLauncherInstanceBehavior, FileBehavior, Openable, WebBasedBehavior {
    init(instance: LauncherInstanceDB) {
        self.object = instance
        self.file = object.fileUrl!
    }
    
    var object: LauncherInstanceDB
    
    var file: URL
    
    let type = RealmLauncherType.website
    
    var app: URL? {
        return object.appUrl ?? getDefaultApp(fileUrl: file)
    }
    
    // DisplayableBehavior
    
    func getIcon(size: Int) -> NSImage {
        guard let app = app else {
            return getAbsentAppIcon(size: size)
        }
        
        return getAppIcon(for: app, size: size)
    }
    
    // FileBehavior
    
    func getCompatibleApps() -> [URL] {
        let cfURL = file as CFURL
        
        var URLs: [URL] = []
        
        if let appUrls = LSCopyApplicationURLsForURL(cfURL, .all)?.takeRetainedValue() {
            for url in appUrls as! [URL] {
                URLs.append(url)
            }
        }
        
        if let userSelectedApp = object.appUrl {
            if let indexInCompatibleApps = URLs.firstIndex(of: userSelectedApp)
            {
                URLs.move(fromOffsets: IndexSet(integer: indexInCompatibleApps), toOffset: 0)
            }
            else
            {
                write {
                    object.appUrl = nil
                }
            }
        }
        
        return URLs
    }
    
    // Openable
    
    func open() {
        let config = NSWorkspace.OpenConfiguration()
            config.activates = true
            config.hides = object.hideOnLaunch
        
        if let app = app
        {
            NSWorkspace.shared.open([file], withApplicationAt: app, configuration: config)
        }
        else
        {
            NSWorkspace.shared.open(file, configuration: config)
        }
    }
    
    // WebBasedBehavior
    
    func setName(name: String) {
        write {
            object.name = name
        }
    }
    
    func setUrl(urlString: String) {
        write {
            object.fileUrl = URL(filePath: urlString)
        }
    }
    
}
