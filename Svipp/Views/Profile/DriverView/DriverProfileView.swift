import SwiftUI

struct DriverProfileView: View {
    let driver: DriverInfo
    
    private var titleText: String {
        if let age = driver.age {
            return "\(driver.name), \(age) år"
        } else {
            return driver.name
        }
    }
    
    private var cityText: String {
        driver.address.components(separatedBy: ",").first ?? driver.address
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                // MARK: - Toppkort (bilde + navn + rating)
                HStack(alignment: .top, spacing: 16) {
                    Image(driver.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 72, height: 72)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(titleText)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color("SvippTextColor"))
                        
                        Text(cityText)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        if !driver.experienceDisplay.isEmpty {
                            Text(driver.experienceDisplay)
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 14))
                        Text(driver.rating)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color("SvippTextColor"))
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 2, y: 1)
                
                // MARK: - Info-seksjon
                VStack(spacing: 12) {
                    Text("Informasjon")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Color("SvippTextColor"))
                    
                    VStack(spacing: 4) {
                        if let employmentDate = driver.employmentDate {
                            Text("\(driver.name) har vært ansatt hos Svipp siden")
                            Text(employmentDate)
                                .fontWeight(.semibold)
                        }
                        
                        if let tripCount = driver.tripCount {
                            Text("\(driver.name) har gjennomført \(tripCount) turer.")
                        }
                    }
                    .font(.system(size: 14))
                    .foregroundColor(Color("SvippTextColor"))
                    
                    if let about = driver.about, !about.isEmpty {
                        Spacer().frame(height: 4)
                        Text(about)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.leading)
                            .padding(.top, 8)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(20)
                .shadow(radius: 2, y: 1)
                
                // MARK: - Anmeldelser
                if let reviews = driver.reviews, !reviews.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Anmeldelser")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color("SvippTextColor"))
                            .padding(.top, 8)
                        
                        ForEach(reviews.prefix(3)) { review in
                            ReviewCard(review: review)
                        }
                    }
                }
                
                // "Les flere"-knapp hvis det finnes flere enn 3
                if let reviews = driver.reviews, reviews.count > 3 {
                    HStack {
                        Spacer()
                        Button {
                            // TODO: Naviger til full anmeldelsesliste
                        } label: {
                            HStack(spacing: 6) {
                                Text("Les Flere")
                                    .font(.system(size: 15, weight: .semibold))
                                
                                Image(systemName: "chevron.down.double")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundColor(Color("SvippTextColor"))
                        }
                        Spacer()
                    }
                    .padding(.top, 8)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
        .background(Color.white.ignoresSafeArea())
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ReviewCard: View {
    let review: DriverReview
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(review.reviewerName), \(review.reviewerAge) år")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color("SvippTextColor"))
                
                if let comment = review.comment, !review.comment!.isEmpty {
                    Text(comment)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .font(.system(size: 13))
                    .foregroundColor(.yellow)
                Text(String(format: "%.1f", review.rating))
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color("SvippTextColor"))
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(red: 0.98, green: 0.96, blue: 0.90))
        .cornerRadius(16)
        .shadow(radius: 1, y: 1)
    }
}

struct DriverProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DriverProfileView(driver: DriverInfoData.all[1])
        }
    }
}
