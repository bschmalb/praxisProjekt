//
//  ProfilEinstellungen.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 28.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct ProfilEinstellungen: View {

    @Binding var isDark: Bool
    @Binding var appearenceDark: Bool
    @Binding var offsetChangeName: CGFloat
    @Binding var offsetLevel: CGFloat
    
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
                        offsetChangeName = -UIScreen.main.bounds.height / 20
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
                        isDark.toggle()
                        appearenceDark.toggle()
                        UserDefaults.standard.set(appearenceDark, forKey: "appearenceDark")
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
//                    Button(action: {
//                        
//                        impact(style: .rigid)
//                    }) {
//                        HStack (spacing: 20){
//                            Image(systemName: "lightbulb")
//                                .font(.system(size: 22))
//                                .padding(.leading, 20)
//                                .frame(width: 60, height: 20)
//                            Text("Deine Tipps")
//                                .font(.system(size: 22))
//                                .fontWeight(.medium)
//                            Spacer()
//                        }.padding(10)
//                    }
                    Spacer()
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
        ProfilEinstellungen(isDark: .constant(false), appearenceDark: .constant(false), offsetChangeName: .constant(-1000), offsetLevel: .constant(-1000))
    }
}
