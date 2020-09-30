//
//  ProfilFilter.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 29.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct ProfilFilter: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var changeFilter: ChangeFilter
    
    @State var categories: [String] = UserDefaults.standard.stringArray(forKey: "notCategory") ?? []
    @State var difficulties: [String] = UserDefaults.standard.stringArray(forKey: "notDifficulty") ?? []
    @State var postedBy = ["Offiziell", "Community"]
    
//    @State var filter = filterData
    
    @ObservedObject var filter: FilterData2
    
    @State var optionSelected: Int = 0
    
    @State var isSelected = true
    
    var screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        ZStack {
            Color("background")
                .edgesIgnoringSafeArea(.all)
            VStack {
                Button(action: {
                    self.mode.wrappedValue.dismiss()
                    impact(style: .medium)
                }) {
                    HStack (spacing: 10){
                        Image(systemName: "arrow.left")
                            .font(.system(size: screenWidth < 500 ? screenWidth * 0.040 : 18, weight: .medium))
                            .foregroundColor(Color("black"))
                        Text("Deine Filter")
                            .font(.system(size: screenWidth < 500 ? screenWidth * 0.040 : 18, weight: .medium))
                            .foregroundColor(Color("black"))
                        Spacer()
                    }
                    .padding(.leading, 20)
                    .padding(.top, 10)
                }
                if (!changeFilter.changeFilterProfile) {
                    ScrollView(.vertical, showsIndicators: false) {
                        Text("Kategorien")
                            .multilineTextAlignment(.center)
                            .font(.system(size: UIScreen.main.bounds.width < 500 ? UIScreen.main.bounds.width * 0.055 : 22, weight: .semibold))
                            .padding()
                        VStack (spacing: 10) {
                            HStack (spacing: 0) {
                                ProfilFilterView(filter: filter, index: 0, category: "Ernährung", categories: $categories, isSelected: true, optionSelected: $optionSelected)
                                Spacer()
                                ProfilFilterView(filter: filter, index: 1, category: "Transport", categories: $categories, isSelected: true, optionSelected: $optionSelected)
                            }
                            HStack (spacing: 0){
                                ProfilFilterView(filter: filter, index: 2, category: "Recycling", categories: $categories, isSelected: true, optionSelected: $optionSelected)
                                Spacer()
                                ProfilFilterView(filter: filter, index: 3, category: "Ressourcen", categories: $categories, isSelected: true, optionSelected: $optionSelected)
                            }
                        }
                        .padding(.bottom, 10)
                        .padding(.horizontal)
                        Text("Schwierigkeitsstufen")
                            .multilineTextAlignment(.center)
                            .font(.system(size: UIScreen.main.bounds.width < 500 ? UIScreen.main.bounds.width * 0.055 : 22, weight: .semibold))
                            .padding()
                        VStack (spacing: 10) {
                            HStack (spacing: 0) {
                                ProfilFilterView(filter: filter, index: 4, category: "Leicht", categories: $difficulties, isSelected: true, optionSelected: $optionSelected)
                                Spacer()
                                ProfilFilterView(filter: filter, index: 5, category: "Mittel", categories: $difficulties, isSelected: true, optionSelected: $optionSelected)
                            }
                            HStack (spacing: 0){
                                ProfilFilterView(filter: filter, index: 6, category: "Schwer", categories: $difficulties, isSelected: true, optionSelected: $optionSelected)
                                Spacer()
                            }
                            .padding(.bottom, 10)
                        }.padding(.horizontal)
                        Text("Von wem gepostet")
                            .multilineTextAlignment(.center)
                            .font(.system(size: UIScreen.main.bounds.width < 500 ? UIScreen.main.bounds.width * 0.055 : 22, weight: .semibold))
                            .padding()
                        VStack (spacing: 10) {
                            HStack (spacing: 0) {
                                ProfilFilterView(filter: filter, index: 7, category: "Offiziell", categories: $postedBy, isSelected: true, optionSelected: $optionSelected)
                                Spacer()
                                ProfilFilterView(filter: filter, index: 8, category: "Community", categories: $difficulties, isSelected: true, optionSelected: $optionSelected)
                            }
                            .padding(.bottom, 10)
                        }.padding(.horizontal)
                        .padding(.bottom, 30)
                    }.accentColor(Color("black"))
                }
            }
        }
        .gesture(DragGesture()
                    .onChanged({ (value) in
                        if value.translation.width > 40 {
                            self.mode.wrappedValue.dismiss()
                        }
                    })
        )
    }
}

struct ProfilFilter_Previews: PreviewProvider {
    static var previews: some View {
        ProfilFilter(filter: FilterData2()).environmentObject(ChangeFilter())
    }
}
