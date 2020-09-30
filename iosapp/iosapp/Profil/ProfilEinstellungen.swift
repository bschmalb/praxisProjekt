//
//  ProfilEinstellungen.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 28.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct ProfilEinstellungen: View {

    @State var logDate = ""
    
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
                
                VStack {
                    
                    NavigationLink(destination: ProfilData()
                                    .navigationBarTitle("")
                                    .navigationBarHidden(true)
                                    .navigationBarBackButtonHidden(true)) {
                        HStack (spacing: 20){
                            Image(systemName: "person")
                                .font(.system(size: screenWidth < 500 ? screenWidth * 0.05 : 22, weight: .medium))
                                .padding(.leading, 20)
                                .frame(width: 60, height: 20)
                            Text("Deine Daten")
                                .font(.system(size: screenWidth < 500 ? screenWidth * 0.05 : 22, weight: .medium))
                            Spacer()
                        }.padding(10)
                    }.navigationBarTitle("Navigation")
                    
                    NavigationLink(destination: ProfilFilter(filter: filter)
                                    .navigationBarTitle("")
                                    .navigationBarHidden(true)
                                    .navigationBarBackButtonHidden(true)) {
                        HStack (spacing: 20){
                            Image(systemName: "arrow.merge")
                                .rotationEffect(.degrees(180), anchor: .center)
                                .font(.system(size: screenWidth < 500 ? screenWidth * 0.05 : 22, weight: .medium))
                                .padding(.leading, 20)
                                .frame(width: 60, height: 20)
                            Text("Deine Filter")
                                .font(.system(size: screenWidth < 500 ? screenWidth * 0.05 : 22, weight: .medium))
                                .fontWeight(.medium)
                            Spacer()
                        }.padding(10)
                    }.navigationBarTitle("Navigation")
                    
                    Button(action: {
                        self.isDark.toggle()
                        self.appearenceDark.toggle()
                        UserDefaults.standard.set(self.appearenceDark, forKey: "appearenceDark")
                        impact(style: .rigid)
                    }) {
                        HStack (spacing: 20){
                            Image(systemName: "moon.circle")
                                .font(.system(size: screenWidth < 500 ? screenWidth * 0.05 : 22, weight: .medium))
                                .padding(.leading, 20)
                                .frame(width: 60, height: 20)
                            Text("Nachtmodus")
                                .font(.system(size: screenWidth < 500 ? screenWidth * 0.05 : 22, weight: .medium))
                                .fontWeight(.medium)
                            Spacer()
                        }.padding(10)
                    }
                    
                    Spacer()
//                    Button(action: {
//                        self.levelEnv.level += 5
//                        UserDefaults.standard.set(self.levelEnv.level, forKey: "userLevel")
//                    }) {
//                        HStack (spacing: 20){
//                            Image(systemName: "arrow.up")
//                                .font(.system(size: 16))
//                                .padding(.leading, 20)
//                                .frame(width: 60, height: 20)
//                            Text("Level Up")
//                            .font(.system(size: 16))
//                            Spacer()
//                        }.padding(10)
//                    }
                    Button(action: {
                        UserDefaults.standard.set(self.logDate, forKey: "logDate")
                        UserDefaults.standard.set(false, forKey: "firstUseTipp")
                        UserDefaults.standard.set(false, forKey: "firstUseLog")
                        impact(style: .rigid)
                    }) {
                        HStack (spacing: 20){
                            Image(systemName: "delete.left")
                                .font(.system(size: 16))
                                .padding(.leading, 20)
                                .frame(width: 60, height: 20)
                            Text("Reset to First App Use")
                                .font(.system(size: 16))
                            Spacer()
                        }.padding(10)
                        .padding(.bottom, 20)
                    }
                }
                .padding(.top, 10)
                .padding(.leading, 15)
                
                
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
        .onAppear {
            impact(style: .rigid)
        }
    }
}

struct ProfilEinstellungen_Previews: PreviewProvider {
    static var previews: some View {
        Group {
        ProfilEinstellungen(isDark: .constant(false), appearenceDark: .constant(false), offsetChangeName: .constant(-1000), offsetLevel: .constant(-1000), filter: FilterData2()).environmentObject(UserLevel())
            ProfilEinstellungen(isDark: .constant(false), appearenceDark: .constant(false), offsetChangeName: .constant(-1000), offsetLevel: .constant(-1000), filter: FilterData2()).environmentObject(UserLevel())
                .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
                .previewDisplayName("iPhone 11")
        }
    }
}
