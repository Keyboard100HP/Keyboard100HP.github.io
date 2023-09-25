import Foundation
import ServiceManagement

class Monitoring {
    
    func launchHelper() {
        var authRef: AuthorizationRef?
        let status = AuthorizationCreate(nil, nil, [], &authRef)
        if status == errAuthorizationSuccess {
            var error: Unmanaged<CFError>?
            if SMJobBless(kSMDomainSystemLaunchd, "room.KeyReaderHelper" as CFString, authRef, &error) {
                print("Helper launched successfully")
            } else {
                if let error = error?.takeRetainedValue() {
                    print("Error launching helper: \(error)")
                }
            }
        }
    }
    
    func run() {
        launchHelper()
        // Здесь может быть дополнительный код для вашего основного приложения.
        
        let helper = HelperMain()
        helper.run()
    }
}
