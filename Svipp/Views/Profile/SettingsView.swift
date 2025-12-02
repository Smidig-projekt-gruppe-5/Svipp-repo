//
//  SettingsView.swift
//  Svipp
//
//  Created by Kasper Espenes on 02/12/2025.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("darkmode") private var darkmode: Bool = false
    
    var body: some View {
        NavigationStack
        {
            Form
            {
                Section("Mørk eller lys modus")
                {
                    Toggle("Aktiver mørk modus", systemImage: darkmode ? "moon.zzz" : "moon.circle", isOn: $darkmode)
                }
                .foregroundColor(Color("SvippTextColor"))
                .listRowBackground(Color("SvippAccent"))
                Section
                {
                    VStack(alignment: .leading)
                    {
                        Text("Utviklet av Gruppe 5").fontWeight(.bold)
                        Text("Alle rettigheter © tilhører Gruppe 5")
                        Text("Versjon 01-10.28")
                    }
                    .foregroundColor(Color("SvippTextColor"))
                    .listRowBackground(Color("SvippAccent"))
                    
                }
                Section("SVIPP")
                {
                    Text(svippInfo)
                        .listRowBackground(Color("SvippAccent"))
                }
                .foregroundColor(Color("SvippTextColor"))
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
}
