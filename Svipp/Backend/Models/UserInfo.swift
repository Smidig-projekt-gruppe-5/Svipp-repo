import Foundation
// data for userinfo
struct UserInfo: Codable, Identifiable {
    let id: String
    
    // bruker info
    var name: String
    var birthdate: String
    var email: String
    var profileImageURL: String?
    var phoneNumber: String?
    
    // adresse
    var addressLine: String?
    var postalCode: String?
    var city: String?
    
    // bil info
    var carMake: String?
    var carModel: String?
    var carYear: String?
}
