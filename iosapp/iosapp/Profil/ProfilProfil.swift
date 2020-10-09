//
//  ProfilProfil.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 08.10.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct ProfilProfil: View {
    @State var logDate = ""
    
    @Binding var selection: Int?
    
    @EnvironmentObject var levelEnv: UserLevel
    @EnvironmentObject var overlay: Overlay
    
    @Binding var isDark: Bool
    @Binding var appearenceDark: Bool
    @Binding var offsetChangeName: CGFloat
    @Binding var offsetLevel: CGFloat
    
    @State var userLevelLocal: NSNumber = 13452
    
    @ObservedObject var filter: FilterData2
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var screenWidth = UIScreen.main.bounds.width
    
    @Binding var isChanged: Bool
    
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
                        Text("Einstellungen")
                            .font(.system(size: screenWidth < 500 ? screenWidth * 0.040 : 18, weight: .medium))
                            .foregroundColor(Color("black"))
                        Spacer()
                    }
                    .padding(.leading, 20)
                    .padding(.vertical, 10)
                }
                VStack (spacing: screenWidth < 350 ? 5 : 15) {
                    
                    NavigationLink(destination: ProfilData(isChanged: $isChanged)
                                    .navigationBarTitle("")
                                    .navigationBarHidden(true)
                                    .navigationBarBackButtonHidden(true), tag: 1, selection: $selection) {
                        Button(action: {
                            impact(style: .medium)
                            self.selection = 1
                        }) {
                            ProfilLink(image: "person", name: "Deine Daten")
                        }
                                    }.navigationBarTitle("Navigation")
                    
                    NavigationLink(destination: ProfilFilter(filter: filter)
                                    .navigationBarTitle("")
                                    .navigationBarHidden(true)
                                    .navigationBarBackButtonHidden(true), tag: 2, selection: $selection) {
                        Button(action: {
                            impact(style: .medium)
                            self.selection = 2
                        }) {
                            HStack (spacing: 5){
                                Image(systemName: "arrow.merge")
                                    .font(.system(size: screenWidth < 500 ? screenWidth * 0.055 : 20))
                                    .padding(.leading, 10)
                                    .rotationEffect(.degrees(90))
                                    .offset(x: 4, y: -4)
                                    .frame(width: screenWidth < 500 ? screenWidth * 0.16 : 50, height: 20)
                                Text("Deine Filter")
                                    .font(.system(size: screenWidth < 500 ? screenWidth * 0.050 : 20, weight: .medium))
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: screenWidth < 500 ? screenWidth * 0.055 : 20))
                                    .padding(.trailing, 28)
                            }.padding(10)
                        }
                    }.navigationBarTitle("Navigation")
                    Spacer()
                }
                .padding(.bottom, 20)
                .padding(.top, screenWidth < 350 ? 0 : 20)
                
                
                Spacer()
            }
        }
        .accentColor(Color("black"))
        .gesture(DragGesture()
                    .onChanged({ (value) in
                        if value.translation.width > 40 {
                            self.mode.wrappedValue.dismiss()
                        }
                    })
        )
    }
}

struct ProfilProfil_Previews: PreviewProvider {
    static var previews: some View {
        ProfilProfil(selection: .constant(1), isDark: .constant(false), appearenceDark: .constant(false), offsetChangeName: .constant(-1000), offsetLevel: .constant(-1000), filter: FilterData2(), isChanged: .constant(false)).environmentObject(UserLevel())
    }
}
