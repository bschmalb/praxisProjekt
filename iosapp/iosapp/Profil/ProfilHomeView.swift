//
//  ProfilHomeView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 19.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI
import Combine

struct ProfilHomeView: View {
    
    @Binding var isDark: Bool
    @Binding var appearenceDark: Bool
    @Binding var offsetChangeName: CGFloat
    @Binding var offsetLevel: CGFloat
    
    @State var offsetTipps = UIScreen.main.bounds.width
    @Binding var selection: Int?
    @Binding var selectionProfil: Int?
    
    @ObservedObject var filter: FilterData2
    
    @EnvironmentObject var model: Model
    
    var screenWidth = UIScreen.main.bounds.width
    
    @Binding var isChanged: Bool
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color("background")
                    .edgesIgnoringSafeArea(.all)
                VStack (spacing: screenWidth < 350 ? 3 : 10) {
                    Image("ProfileImage")
                            .resizable()
                            .scaledToFit()
                            .padding(screenWidth * 0.07)
                            .padding(.top, screenWidth < 350 ? 0 : screenWidth * 0.05)
                    NavigationLink(destination: ProfilTippView()
                                    .navigationBarTitle("")
                                    .navigationBarHidden(true)
                                    .navigationBarBackButtonHidden(true)
                                   , tag: 1, selection: $selection) {
                        Button(action: {
                            impact(style: .medium)
                            self.selection = 1
                        }) {
                            ProfilLink(image: "lightbulb", name: "Deine Gewohnheiten")
                        }
                    }.navigationBarTitle("Navigation")
                    
                    NavigationLink(destination: ProfilFactView()
                                        .navigationBarTitle("")
                                        .navigationBarHidden(true)
                                        .navigationBarBackButtonHidden(true)
                                   , tag: 2, selection: $selection) {
                        Button(action: {
                            impact(style: .medium)
                            self.selection = 2
                        }) {
                            ProfilLink(image: "doc.plaintext", name: "Deine Fakten")
                        }
                        }.navigationBarTitle("Navigation")
                    
                    NavigationLink(destination: ProfilEntwicklung()
                                        .navigationBarTitle("")
                                        .navigationBarHidden(true)
                                        .navigationBarBackButtonHidden(true)
                                   , tag: 3, selection: $selection) {
                        Button(action: {
                            impact(style: .medium)
                            self.selection = 3
                        }) {
                            ProfilLink(image: "arrow.up.right", name: "Deine Entwicklung")
                        }
                        }.navigationBarTitle("Navigation")
                    
                    NavigationLink(destination: ProfilProfil(selection: $selectionProfil, isDark: $isDark, appearenceDark: $appearenceDark, offsetChangeName: $offsetChangeName, offsetLevel: $offsetLevel, filter: filter, isChanged: $isChanged)
                                    .navigationBarTitle("")
                                    .navigationBarHidden(true)
                                    .navigationBarBackButtonHidden(true)
                                   , tag: 4, selection: $selection) {
                        Button(action: {
                            impact(style: .medium)
                            self.selection = 4
                        }) {
                            ProfilLink(image: "person", name: "Profil")
                        }
                    }.navigationBarTitle("Navigation")
                    
                    NavigationLink(destination: ProfilEinstellungen(isDark: $isDark, appearenceDark: $appearenceDark, offsetChangeName: $offsetChangeName, offsetLevel: $offsetLevel, filter: filter, isChanged: $isChanged)
                                    .navigationBarTitle("")
                                    .navigationBarHidden(true)
                                    .navigationBarBackButtonHidden(true)
                                   , tag: 5, selection: $selection) {
                        Button(action: {
                            impact(style: .medium)
                            self.selection = 5
                        }) {
                            ProfilLink(image: "gear", name: "Einstellungen")
                        }
                    }.navigationBarTitle("Navigation")
                    Spacer()
                }.padding(.top, 30)
                .padding(.bottom, 20)
            }
            .animation(.spring())
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }.accentColor(Color("black"))
        .onTapGesture(perform: {
            self.hideKeyboard()
        })
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ProfilHomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProfilHomeView(isDark: .constant(false), appearenceDark: .constant(false), offsetChangeName: .constant(-1000), offsetLevel: .constant(-1000), selection: .constant(0), selectionProfil: .constant(1), filter: FilterData2(), isChanged: .constant(false))
            ProfilHomeView(isDark: .constant(false), appearenceDark: .constant(false), offsetChangeName: .constant(-1000), offsetLevel: .constant(-1000), selection: .constant(0), selectionProfil: .constant(1), filter: FilterData2(), isChanged: .constant(false))
                .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
                .previewDisplayName("iPhone 11")
        }
    }
}

struct ProfilLink: View {
    
    var image: String
    var name: String
    
    var screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        HStack (spacing: 5){
            Image(systemName: image)
                .font(.system(size: screenWidth < 500 ? screenWidth * 0.055 : 20))
                .padding(.leading, 10)
                .frame(width: screenWidth < 500 ? screenWidth * 0.16 : 50, height: 20)
            Text(name)
                .font(.system(size: screenWidth < 500 ? screenWidth * 0.050 : 20, weight: .medium))
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: screenWidth < 500 ? screenWidth * 0.055 : 20))
                .padding(.trailing, 28)
        }.padding(10)
    }
}
