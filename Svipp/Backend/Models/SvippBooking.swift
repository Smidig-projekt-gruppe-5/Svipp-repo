import Foundation

// data vi bruker for booking
struct SvippBooking: Identifiable, Codable {
    let id: String
    let userId: String
    let fromAddress: String
    let toAddress: String
    let pickupTime: Date
    let createdAt: Date
    let note: String?

}
