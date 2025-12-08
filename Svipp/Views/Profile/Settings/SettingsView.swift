import SwiftUI

struct SettingsView: View {
    @AppStorage("darkmode") private var darkmode: Bool = false
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Tema
                Section {
                    Toggle(isOn: $darkmode) {
                        Label {
                            Text("Aktiver mørk modus")
                        } icon: {
                            Image(systemName: darkmode ? "moon.zzz" : "moon.circle")
                        }
                    }
                    .tint(Color("SvippMainColor"))
                    .foregroundColor(Color("SvippTextColor"))
                } header: {
                    Text("Mørk eller lys modus")
                        .foregroundColor(Color("SvippTextColor"))
                }
                .listRowBackground(Color("SvippAccent"))
                
                // MARK: - Sjåfører
                Section {
                    NavigationLink {
                        CreateDriverView()
                            .environmentObject(authService)
                    } label: {
                        Label("Legg til ny sjåfør", systemImage: "person.crop.circle.badge.plus")
                    }
                    
                    NavigationLink {
                        DriverManagementView()
                            .environmentObject(authService)
                    } label: {
                        Label("Administrer sjåfører", systemImage: "list.bullet")
                    }
                } header: {
                    Text("Sjåfører")
                        .foregroundColor(Color("SvippTextColor"))
                }
                .listRowBackground(Color("SvippAccent"))
                
                // MARK: - App-info
                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Utviklet av Gruppe 5")
                            .fontWeight(.bold)
                        Text("Alle rettigheter © tilhører Gruppe 5")
                        Text("Versjon 01-10.28")
                    }
                    .foregroundColor(Color("SvippTextColor"))
                } header: {
                    Text("Om appen")
                        .foregroundColor(Color("SvippTextColor"))
                }
                .listRowBackground(Color("SvippAccent"))
                
                // MARK: - SVIPP-tekst
                Section {
                    Text(svippInfo)   // 👈 denne må være definert ett sted i prosjektet ditt
                        .font(.footnote)
                        .foregroundColor(Color("SvippTextColor"))
                        .multilineTextAlignment(.leading)
                } header: {
                    Text("SVIPP")
                        .foregroundColor(Color("SvippTextColor"))
                }
                .listRowBackground(Color("SvippAccent"))
            }
            .scrollContentBackground(.hidden)
            .background(Color.white)
            .navigationTitle("Innstillinger")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AuthService.shared)
}
