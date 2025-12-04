import SwiftUI
import PhotosUI   // 👈 for PhotosPickerItem + PhotosPicker
import UIKit      // 👈 for UIImage

// MARK: - Header (bilde + navn)

struct ProfileHeader: View {
    @EnvironmentObject var authService: AuthService
    
    let profile: UserInfo?
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var isUploadingImage: Bool = false
    @State private var localProfileImage: UIImage? = nil
    
    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            ZStack(alignment: .bottomTrailing) {
                // 1) Lokalt valgt bilde
                if let uiImage = localProfileImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 72, height: 72)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.black, lineWidth: 1)
                        )
                        .shadow(radius: 3)
                }
                // 2) Bilde fra URL
                else if let urlString = profile?.profileImageURL,
                        let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 72, height: 72)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 72, height: 72)
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(Color.black, lineWidth: 1)
                                )
                                .shadow(radius: 3)
                        case .failure:
                            placeholderAvatar
                        @unknown default:
                            placeholderAvatar
                        }
                    }
                }
                // 3) Placeholder hvis ingen bilde
                else {
                    placeholderAvatar
                }
                
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Circle()
                        .fill(Color("SvippAccent"))
                        .frame(width: 24, height: 24)
                        .overlay(
                            Group {
                                if isUploadingImage {
                                    ProgressView()
                                        .scaleEffect(0.5)
                                } else {
                                    Image(systemName: "plus")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(Color("SvippTextColor"))
                                }
                            }
                        )
                        .offset(x: 3, y: 3)
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(profile?.name ?? "Ukjent bruker")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color("SvippTextColor"))
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                // Kort sekundær linje
                let cityLine: String? = {
                    var parts: [String] = []
                    if let city = profile?.city, !city.isEmpty {
                        parts.append(city)
                    }
                    if let carMake = profile?.carMake,
                       let carModel = profile?.carModel,
                       let year = profile?.carYear,
                       !carMake.isEmpty, !carModel.isEmpty, !year.isEmpty {
                        parts.append("\(carMake) \(carModel) \(year)")
                    }
                    return parts.isEmpty ? nil : parts.joined(separator: " · ")
                }()
                
                if let cityLine {
                    Text(cityLine)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                        .truncationMode(.tail)
                } else if let email = profile?.email {
                    Text(email)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 4)
        .onChange(of: selectedItem) { newItem in
            guard let newItem = newItem else { return }
            
            isUploadingImage = true
            
            Task {
                do {
                    if let data = try await newItem.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        
                        await MainActor.run {
                            self.localProfileImage = uiImage
                        }
                        
                        authService.uploadProfileImage(uiImage) { _ in
                            DispatchQueue.main.async {
                                isUploadingImage = false
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            isUploadingImage = false
                        }
                    }
                } catch {
                    print("Feil ved lesing av bilde:", error)
                    DispatchQueue.main.async {
                        isUploadingImage = false
                    }
                }
            }
        }
    }
    
    private var placeholderAvatar: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .frame(width: 72, height: 72)
            .foregroundColor(Color("SvippMainColor"))
            .overlay(
                Circle().stroke(Color.black, lineWidth: 1)
            )
            .shadow(radius: 3)
    }
}
