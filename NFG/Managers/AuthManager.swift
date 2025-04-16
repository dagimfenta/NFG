import Foundation
import SwiftUI

class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    @Published var isAuthenticated = false
    @Published var isAdmin = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentDriver: Driver?
    
    private init() {}
    
    func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        isLoading = true
        errorMessage = nil
        
        // Admin credentials
        if email == "dagimmfenta@gmail.com" && password == "m" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.isLoading = false
                self?.isAuthenticated = true
                self?.isAdmin = true
                completion(.success(()))
            }
            return
        }
        
        // Check driver credentials
        if let driver = DriverStorageManager.shared.getDriverByEmail(email) {
            if driver.password == password {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    self?.isLoading = false
                    self?.isAuthenticated = true
                    self?.isAdmin = false
                    self?.currentDriver = driver
                    completion(.success(()))
                }
                return
            }
        }
        
        // Invalid credentials
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.isLoading = false
            self?.errorMessage = "Invalid email or password"
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid email or password"])))
        }
    }
    
    func logout() {
        isAuthenticated = false
        isAdmin = false
        currentDriver = nil
    }
    
    func createDriverAccount(email: String, password: String, name: String, phone: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard isAdmin else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Only admins can create driver accounts"])))
            return
        }
        
        // Check if email already exists
        if DriverStorageManager.shared.getDriverByEmail(email) != nil {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "An account with this email already exists"])))
            return
        }
        
        // Create driver object
        let nameComponents = name.components(separatedBy: " ")
        let firstName = nameComponents.first ?? ""
        let lastName = nameComponents.dropFirst().joined(separator: " ")
        
        let driver = Driver(
            id: generateDriverID(),
            firstName: firstName,
            lastName: lastName,
            email: email,
            phoneNumber: phone,
            password: password,
            createdAt: Date()
        )
        
        // Save driver
        DriverStorageManager.shared.saveDriver(driver)
        completion(.success(()))
    }
    
    private func generateDriverID() -> String {
        // Generate a random 5-digit number
        let randomID = Int.random(in: 10000...99999)
        return String(randomID)
    }
} 