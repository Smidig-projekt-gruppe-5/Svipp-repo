import SwiftUI

struct FavoritesModalView: View {
    @Binding var isPresented: Bool
    let favoriteDrivers: [DriverInfo]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Favorittsjåfører")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color("SvippTextColor"))
                    
                    Spacer()
                    
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .padding(8)
                            .foregroundColor(Color("SvippTextColor"))
                    }
                }
                .padding(.top, 8)
                
                if favoriteDrivers.isEmpty {
                    Spacer()
                    Text("Du har ingen favorittsjåfører enda.")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(favoriteDrivers) { driver in
                                FavoriteDriverRow(driver: driver)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
    }
}

struct FavoriteDriverRow: View {
    let driver: DriverInfo
    
    var body: some View {
        HStack(spacing: 12) {
            Image(driver.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 44, height: 44)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(driver.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color("SvippTextColor"))
                
                if let expText = expText {
                    Text(expText)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .font(.system(size: 13))
                    .foregroundColor(.yellow)
                Text(driver.rating)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color("SvippTextColor"))
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(red: 0.98, green: 0.96, blue: 0.90))
        .cornerRadius(18)
        .shadow(radius: 2, y: 1)
    }
    
    private var expText: String? {
        driver.experienceDisplay.isEmpty ? nil : driver.experienceDisplay
    }
}
