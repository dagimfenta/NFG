import Foundation

class DriverStorageManager {
    static let shared = DriverStorageManager()
    
    private let driversKey = "saved_drivers"
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    func saveDriver(_ driver: Driver) {
        var drivers = getAllDrivers()
        drivers.append(driver)
        saveDrivers(drivers)
    }
    
    func getAllDrivers() -> [Driver] {
        guard let data = userDefaults.data(forKey: driversKey) else {
            return []
        }
        
        do {
            let drivers = try JSONDecoder().decode([Driver].self, from: data)
            return drivers
        } catch {
            print("Error decoding drivers: \(error)")
            return []
        }
    }
    
    func getDriverByEmail(_ email: String) -> Driver? {
        let drivers = getAllDrivers()
        return drivers.first { $0.email.lowercased() == email.lowercased() }
    }
    
    private func saveDrivers(_ drivers: [Driver]) {
        do {
            let data = try JSONEncoder().encode(drivers)
            userDefaults.set(data, forKey: driversKey)
        } catch {
            print("Error encoding drivers: \(error)")
        }
    }
} 