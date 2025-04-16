import Foundation

struct Driver: Identifiable, Codable {
    let id: String // 5-digit driver ID
    let firstName: String
    let lastName: String
    let email: String
    let phoneNumber: String
    let password: String
    let createdAt: Date
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    var formattedPhoneNumber: String {
        // Format phone number to (XXX) XXX-XXXX
        let numbers = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        if numbers.count == 10 {
            let areaCode = String(numbers.prefix(3))
            let firstThree = String(numbers.dropFirst(3).prefix(3))
            let lastFour = String(numbers.suffix(4))
            return "(\(areaCode)) \(firstThree)-\(lastFour)"
        }
        return phoneNumber
    }
} 