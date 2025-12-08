import Foundation

struct UserInfo: Codable, Identifiable {
    let id: String
    
    // Bruker info
    var name: String
    var birthdate: String
    var email: String
    var profileImageURL: String?
    var phoneNumber: String?
    
    // Adresse
    var addressLine: String?
    var postalCode: String?
    var city: String?
    
    // Bil info
    var carMake: String?
    var carModel: String?
    var carYear: String?
}
