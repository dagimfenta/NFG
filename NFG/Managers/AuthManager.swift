import Foundation
import SwiftUI

class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    @Published var isAuthenticated = false
    @Published var isAdmin = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
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
        
        // Driver credentials
        if email == "adamcarlos08@gmail.com" && password == "g" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.isLoading = false
                self?.isAuthenticated = true
                self?.isAdmin = false
                completion(.success(()))
            }
            return
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
    }
    
    func createDriverAccount(email: String, password: String, name: String, phone: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard isAdmin else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Only admins can create driver accounts"])))
            return
        }
        
        // Mock account creation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion(.success(()))
        }
    }
} 