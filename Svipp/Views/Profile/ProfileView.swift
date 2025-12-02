//
//  SettingsView.swift
//  Svipp
//
//  Created by Kasper Espenes on 02/12/2025.
//


import SwiftUI

struct ProfileView: View {
    var body: some View {
        
        VStack(spacing: 0) {
            HStack {
                
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gearshape")
                        .font(.system(size: 34, weight: .medium))
                        .foregroundStyle(Color("SvippTextColor"))
                        .padding(.leading, 12)
                        .padding(.vertical, 8)
                }
                
                Spacer()
                
                ZStack {
                    PrimaryButton(text: "Favoritter") { }
                }
                .padding(.trailing, 12)
                .padding(.vertical, 8)
            }
            .padding(.top, 6)
            
            HStack(alignment: .center, spacing: 16) {
                
                ZStack(alignment: .bottomTrailing) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 90, height: 90)
                        .foregroundColor(Color("SvippMainColor"))
                        .overlay(
                            Circle().stroke(Color.black, lineWidth: 1.5)
                        )
                        .shadow(radius: 5)
                    
                    Circle()
                        .fill(Color("SvippAccent"))
                        .frame(width: 26, height: 26)
                        .overlay(
                            Image(systemName: "plus")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color("SvippTextColor"))
                        )
                        .offset(x: 4, y: 4)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Ragnar Fjønstad")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color("SvippTextColor"))
                    
                    Text("Tøysesvingen 12, 0459 Oslo")
                        .foregroundColor(Color("SvippTextColor"))
                    
                    Text("Toyota Corolla 2018")
                        .foregroundColor(Color("SvippTextColor"))
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            Divider()
                .padding(.vertical, 16)
            
            VStack(alignment: .leading, spacing: 12) {
                
                Text("Tidligere turer")
                    .font(.headline)
                    .foregroundColor(Color("SvippTextColor"))
                    .padding(.horizontal)
                
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        
                        DriverCard(
                            name: "Natasha Brun",
                            rating: "4.6",
                            address: "Oslo sentrum",
                            yearsExperience: "3 år som sjåfør – 180 turer",
                            price: "",
                            imageName: "Tom"
                        )
                   
                        
                        DriverCard(
                            name: "Natasha Brun",
                            rating: "3.9",
                            address: "Majorstuen",
                            yearsExperience: "3 år som sjåfør – 180 turer",
                            price: "",
                            imageName: "Tom"
                        )
                        
                        DriverCard(
                            name: "Natasha Brun",
                            rating: "5.0",
                            address: "Frogner",
                            yearsExperience: "3 år som sjåfør – 180 turer",
                            price: "",
                            imageName: "Tom"
                        )
                        
                        DriverCard(
                            name: "Natasha Brun",
                            rating: "5.0",
                            address: "Frogner",
                            yearsExperience: "3 år som sjåfør – 180 turer",
                            price: "",
                            imageName: "Tom"
                        )
                        
                        DriverCard(
                            name: "Natasha Brun",
                            rating: "5.0",
                            address: "Frogner",
                            yearsExperience: "3 år som sjåfør – 180 turer",
                            price: "",
                            imageName: "Tom"
                        )
                                          
                    }
                    .padding(.horizontal)
                }
            }
            
        }
        .background(Color.white.ignoresSafeArea())
    }
}


#Preview {
    NavigationStack {
        ProfileView()
    }
}
