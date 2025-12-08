import SwiftUI


struct ProfileInfoSection: View {
    let profile: UserInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Profilinfo")
                    .font(.headline)
                    .foregroundColor(Color("SvippTextColor"))
                
                Spacer()
                
                NavigationLink {
                    EditProfileView()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "pencil")
                            .font(.system(size: 12, weight: .semibold))
                        Text("Rediger")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundColor(Color("SvippTextColor"))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("SvippTextColor").opacity(0.25), lineWidth: 1)
                    )
                }
            }
            
            ProfileInfoRow(
                icon: "envelope",
                label: "E-post",
                value: profile.email
            )
            
            if let phone = profile.phoneNumber, !phone.isEmpty {
                ProfileInfoRow(
                    icon: "phone",
                    label: "Telefon",
                    value: phone
                )
            }
            
            ProfileInfoRow(
                icon: "calendar",
                label: "Fødselsdato",
                value: profile.birthdate
            )
            
            if let address = profile.addressLine,
               let postal = profile.postalCode,
               let city = profile.city,
               !address.isEmpty, !postal.isEmpty, !city.isEmpty {
                ProfileInfoRow(
                    icon: "house",
                    label: "Adresse",
                    value: "\(address), \(postal) \(city)"
                )
            }
            
            if let make = profile.carMake,
               let model = profile.carModel,
               let year = profile.carYear,
               !make.isEmpty, !model.isEmpty, !year.isEmpty {
                ProfileInfoRow(
                    icon: "car.fill",
                    label: "Bil",
                    value: "\(make) \(model) \(year)"
                )
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
        .padding(.horizontal)
    }
}


struct ProfileInfoRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .frame(width: 18)
                .foregroundColor(.gray)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
                Text(value)
                    .font(.system(size: 14))
                    .foregroundColor(Color("SvippTextColor"))
                    .lineLimit(2)
                    .truncationMode(.tail)
            }
            
            Spacer()
        }
    }
}
