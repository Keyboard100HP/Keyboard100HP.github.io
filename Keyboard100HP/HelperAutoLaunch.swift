import Foundation

class AutoLaunchHelper {
    
    private static let launchAgentsPath = "~/Library/LaunchAgents/"
    private static let plistName = "room.Keyboard100HP.plist"
    
    init() {
        AutoLaunchHelper.setAutoLaunch(enabled: true)
    }
    
    static func setAutoLaunch(enabled: Bool) {
        let plistPath = launchAgentsPath.appending(plistName).expandingTildeInPath
        
        if enabled {
            // Создать .plist файл для launchd
            let dict: [String: Any] = [
                "Label": "room.Keyboard100HP",
                "Program": Bundle.main.bundlePath + "/Contents/MacOS/" + (Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "Keyboard100HP"),
                "RunAtLoad": true
            ]
            let plistData = try? PropertyListSerialization.data(fromPropertyList: dict, format: .xml, options: 0)
            try? plistData?.write(to: URL(fileURLWithPath: plistPath))
            
            // Запустить job
            let task = Process()
            task.launchPath = "/bin/launchctl"
            task.arguments = ["load", plistPath]
            task.launch()
        } else {
            // Удалить .plist файл из LaunchAgents
            try? FileManager.default.removeItem(atPath: plistPath)
            
            // Удалить job
            let task = Process()
            task.launchPath = "/bin/launchctl"
            task.arguments = ["unload", plistPath]
            task.launch()
        }
    }
}

extension String {
    var expandingTildeInPath: String {
        return (self as NSString).expandingTildeInPath
    }
}
