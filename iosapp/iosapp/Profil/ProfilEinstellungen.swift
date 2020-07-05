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
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            Color("background")
                .edgesIgnoringSafeArea(.all)
            VStack {
                Button(action: {
                    self.mode.wrappedValue.dismiss()
                    impact(style: .medium)
                }) {
                    HStack (spacing: 20){
                        Image(systemName: "arrow.left.circle")
                            .font(.system(size: 24))
                            .foregroundColor(Color("black"))
                        Text("Einstellungen")
                            .font(.system(size: 22))
                            .fontWeight(.medium)
                            .foregroundColor(Color("black"))
                        Spacer()
                    }
                    .padding(20)
                    .padding(.top, UIScreen.main.bounds.height / 40)
                }
                
                VStack {
                    Button(action: {
                        impact(style: .rigid)
                    }) {
                        HStack (spacing: 20){
                            Image(systemName: "arrow.merge")
                                .rotationEffect(.degrees(180), anchor: .center)
                                .font(.system(size: 22))
                                .padding(.leading, 20)
                                .frame(width: 60, height: 20)
                            Text("Filter")
                                .font(.system(size: 22))
                                .fontWeight(.medium)
                            Spacer()
                        }.padding(10)
                    }
                    Button(action: {
                        self.overlay.overlay = true
                        self.offsetChangeName = -UIScreen.main.bounds.height / 20
                        impact(style: .rigid)
                    }) {
                        HStack (spacing: 20){
                            Image(systemName: "text.cursor")
                                .font(.system(size: 22))
                                .padding(.leading, 20)
                                .frame(width: 60, height: 20)
                            Text("Dein Name")
                                .font(.system(size: 22))
                                .fontWeight(.medium)
                            Spacer()
                        }.padding(10)
                    }
                    Button(action: {
                        self.isDark.toggle()
                        self.appearenceDark.toggle()
                        UserDefaults.standard.set(self.appearenceDark, forKey: "appearenceDark")
                        impact(style: .rigid)
                    }) {
                        HStack (spacing: 20){
                            Image(systemName: "moon.circle")
                                .font(.system(size: 22))
                                .padding(.leading, 20)
                                .frame(width: 60, height: 20)
                            Text("Nachtmodus")
                                .font(.system(size: 22))
                                .fontWeight(.medium)
                            Spacer()
                        }.padding(10)
                    }
                    
                    Button(action: {
                        self.levelEnv.level += 5
                        UserDefaults.standard.set(self.levelEnv.level, forKey: "userLevel")
                    }) {
                        HStack (spacing: 20){
                            Image(systemName: "arrow.up")
                                .font(.system(size: 22))
                                .padding(.leading, 20)
                                .frame(width: 60, height: 20)
                            Text("Level Up")
                                .font(.system(size: 22))
                                .fontWeight(.medium)
                            Spacer()
                        }.padding(10)
                    }
                    
                    Spacer()
                    Button(action: {
                        UserDefaults.standard.set(self.logDate, forKey: "logDate")
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
        ProfilEinstellungen(isDark: .constant(false), appearenceDark: .constant(false), offsetChangeName: .constant(-1000), offsetLevel: .constant(-1000)).environmentObject(UserLevel())
    }
}
