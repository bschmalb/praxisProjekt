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
    
    @State var selection: Int? = nil
    
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
                    NavigationLink(destination: FeedbackView()
                                    .navigationBarTitle("")
                                    .navigationBarHidden(true)
                                    .navigationBarBackButtonHidden(true), tag: 3, selection: $selection) {
                        Button(action: {
                            impact(style: .medium)
                            self.selection = 3
                        }) {
                            HStack (spacing: 5){
                                Image(systemName: "plus.bubble")
                                    .font(.system(size: screenWidth < 500 ? screenWidth * 0.055 : 20))
                                    .padding(.leading, 10)
                                    .frame(width: screenWidth < 500 ? screenWidth * 0.16 : 50, height: 20)
                                Text("Feedback geben")
                                    .font(.system(size: screenWidth < 500 ? screenWidth * 0.050 : 20, weight: .medium))
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: screenWidth < 500 ? screenWidth * 0.055 : 20))
                                    .padding(.trailing, 28)
                            }.padding(10)
                        }
                                    }.navigationBarTitle("Navigation")
                    NavigationLink(destination: ProfilSpende()
                                    .navigationBarTitle("")
                                    .navigationBarHidden(true)
                                    .navigationBarBackButtonHidden(true), tag: 4, selection: $selection) {
                        Button(action: {
                            impact(style: .medium)
                            self.selection = 4
                        }) {
                            HStack (spacing: 5){
                                Image(systemName: "eurosign.circle")
                                    .font(.system(size: screenWidth < 500 ? screenWidth * 0.055 : 20))
                                    .padding(.leading, 10)
                                    .frame(width: screenWidth < 500 ? screenWidth * 0.16 : 50, height: 20)
                                Text("Spenden")
                                    .font(.system(size: screenWidth < 500 ? screenWidth * 0.050 : 20, weight: .medium))
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: screenWidth < 500 ? screenWidth * 0.055 : 20))
                                    .padding(.trailing, 28)
                            }.padding(10)
                        }
                    }.navigationBarTitle("Navigation")
                    
                    Button(action: {
                        self.isDark.toggle()
                        self.appearenceDark.toggle()
                        UserDefaults.standard.set(self.appearenceDark, forKey: "appearenceDark")
                        impact(style: .rigid)
                    }) {
                        HStack (spacing: 5){
                            Image(systemName: "moon.circle")
                                .font(.system(size: screenWidth < 500 ? screenWidth * 0.055 : 20))
                                .padding(.leading, 10)
                                .frame(width: screenWidth < 500 ? screenWidth * 0.16 : 50, height: 20)
                            Text("Nachtmodus")
                                .font(.system(size: screenWidth < 500 ? screenWidth * 0.050 : 20, weight: .medium))
                            Spacer()
                        }.padding(10)
                    }
                    Spacer()
                    Button(action: {
                        UserDefaults.standard.set(self.logDate, forKey: "logDate")
                        UserDefaults.standard.set(false, forKey: "firstUseTipp")
                        UserDefaults.standard.set(false, forKey: "firstUseLog")
                        impact(style: .rigid)
                    }) {
                        HStack (spacing: 5){
                            Image(systemName: "delete.left")
                                .font(.system(size: screenWidth < 500 ? screenWidth * 0.035 : 14))
                                .padding(.leading, 10)
                                .frame(width: screenWidth < 500 ? screenWidth * 0.16 : 50, height: 20)
                            Text("Reset to First App Use")
                                .font(.system(size: screenWidth < 500 ? screenWidth * 0.030 : 14, weight: .medium))
                            Spacer()
                        }.padding(10)
                    }
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

struct ProfilEinstellungen_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProfilEinstellungen(isDark: .constant(false), appearenceDark: .constant(false), offsetChangeName: .constant(-1000), offsetLevel: .constant(-1000), filter: FilterData2(), isChanged: .constant(false)).environmentObject(UserLevel())
//            ProfilEinstellungen(isDark: .constant(false), appearenceDark: .constant(false), offsetChangeName: .constant(-1000), offsetLevel: .constant(-1000), filter: FilterData2(), isChanged: .constant(false)).environmentObject(UserLevel())
//                .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
//                .previewDisplayName("iPhone 11")
        }
    }
}
