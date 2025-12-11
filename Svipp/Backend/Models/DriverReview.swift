import Foundation


// data for reviews 
struct DriverReview: Identifiable, Codable, Equatable {
    let id: String
    let reviewerName: String
    let reviewerAge: Int
    let rating: Double
    let comment: String?
    let createdAt: Date?
    
    init(
        id: String = UUID().uuidString,
        reviewerName: String,
        reviewerAge: Int,
        rating: Double,
        comment: String?,
        createdAt: Date? = nil
    ) {
        self.id = id
        self.reviewerName = reviewerName
        self.reviewerAge = reviewerAge
        self.rating = rating
        self.comment = comment
        self.createdAt = createdAt
    }
}
