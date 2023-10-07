import Foundation


class UpdateManager: ObservableObject {
    static let shared = UpdateManager()
    
    @Published var isUpdateAvailable: Bool = false
    
    init() {
        checkUpdates()
    }
    
//    func checkUpdates(completion: @escaping (Bool) -> Void) {
    func checkUpdates() {
        let currentAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
        guard let url = URL(string: "https://gist.githubusercontent.com/Nekozzz/bba3f2392f31003c047585b1797478dd/raw") else {
//            completion(false)
            self.isUpdateAvailable = false
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
//                completion(false)
                self.isUpdateAvailable = false
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String],
                   let latestVersion = json["currentVersion"],
                   let currentVersion = currentAppVersion,
                   latestVersion > currentVersion {
                    print("Доступна новая версия!")
//                    completion(true)
                    self.isUpdateAvailable = true
                } else {
//                    completion(false)
                    self.isUpdateAvailable = false
                }
            } catch {
                print("Ошибка при разборе JSON: \(error)")
//                completion(false)
                self.isUpdateAvailable = false
            }
        }
        
        task.resume()
    }
    
}
