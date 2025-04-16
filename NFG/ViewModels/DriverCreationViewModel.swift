import Foundation
import SwiftUI

class DriverCreationViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var phoneNumber = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var showingError = false
    @Published var errorMessage = ""
    @Published var isCreating = false
    
    func validateInputs() -> Bool {
        // Validate first name
        guard !firstName.isEmpty else {
            errorMessage = "Please enter first name"
            showingError = true
            return false
        }
        
        // Validate last name
        guard !lastName.isEmpty else {
            errorMessage = "Please enter last name"
            showingError = true
            return false
        }
        
        // Validate email
        guard !email.isEmpty else {
            errorMessage = "Please enter email"
            showingError = true
            return false
        }
        
        guard isValidEmail(email) else {
            errorMessage = "Please enter a valid email address"
            showingError = true
            return false
        }
        
        // Check if email is unique
        if DriverStorageManager.shared.getDriverByEmail(email) != nil {
            errorMessage = "An account with this email already exists"
            showingError = true
            return false
        }
        
        // Validate phone number
        guard !phoneNumber.isEmpty else {
            errorMessage = "Please enter phone number"
            showingError = true
            return false
        }
        
        guard isValidPhoneNumber(phoneNumber) else {
            errorMessage = "Please enter a valid phone number"
            showingError = true
            return false
        }
        
        // Validate password
        guard !password.isEmpty else {
            errorMessage = "Please enter password"
            showingError = true
            return false
        }
        
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters"
            showingError = true
            return false
        }
        
        // Validate confirm password
        guard !confirmPassword.isEmpty else {
            errorMessage = "Please confirm password"
            showingError = true
            return false
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            showingError = true
            return false
        }
        
        return true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func isValidPhoneNumber(_ phone: String) -> Bool {
        let numbers = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return numbers.count == 10
    }
    
    func createDriver(completion: @escaping (Result<Driver, Error>) -> Void) {
        guard validateInputs() else {
            return
        }
        
        isCreating = true
        
        // Format phone number
        let formattedPhone = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        // Create driver object
        let driver = Driver(
            id: generateDriverID(),
            firstName: firstName,
            lastName: lastName,
            email: email,
            phoneNumber: formattedPhone,
            password: password,
            createdAt: Date()
        )
        
        // Save driver
        DriverStorageManager.shared.saveDriver(driver)
        
        isCreating = false
        completion(.success(driver))
    }
    
    private func generateDriverID() -> String {
        // Generate a random 5-digit number
        let randomID = Int.random(in: 10000...99999)
        return String(randomID)
    }
} 