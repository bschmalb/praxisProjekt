//
//  ProfilHomeView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 19.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct ProfilHomeView: View {
    
    @Binding var isDark: Bool
    @Binding var appearenceDark: Bool
    @Binding var offsetChangeName: CGFloat
    @Binding var offsetLevel: CGFloat
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color("background")
                    .edgesIgnoringSafeArea(.all)
                VStack (spacing: 15) {
                    Image("ProfileImage")
                            .resizable()
                            .scaledToFit()
                            .padding(40)
                            .padding(.top, 20)
                    
                    NavigationLink(destination: ProfilTippView()
                                        .navigationBarTitle("")
                                        .navigationBarHidden(true)
                                        .navigationBarBackButtonHidden(true)
                        ) {
                            HStack (spacing: 20){
                                Image(systemName: "lightbulb")
                                    .font(.system(size: 22))
                                    .padding(.leading, 20)
                                    .frame(width: 40, height: 20)
                                Text("Deine Gewohnheiten")
                                    .font(.system(size: 20))
                                    .fontWeight(.medium)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 20))
                                    .padding(.trailing, 28)
                            }.padding(10)
                        }.navigationBarTitle("Navigation")
                    
                    NavigationLink(destination: ProfilChallengeView()
                                        .navigationBarTitle("")
                                        .navigationBarHidden(true)
                                        .navigationBarBackButtonHidden(true)
                        ) {
                            HStack (spacing: 20){
                                Image(systemName: "doc.plaintext")
                                    .font(.system(size: 22))
                                    .padding(.leading, 20)
                                    .frame(width: 40, height: 20)
                                Text("Deine Fakten")
                                    .font(.system(size: 20))
                                    .fontWeight(.medium)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 20))
                                    .padding(.trailing, 28)
                            }
                            .padding(10)
                        }.navigationBarTitle("Navigation")
                    
                    NavigationLink(destination: ProfilEntwicklung()
                                        .navigationBarTitle("")
                                        .navigationBarHidden(true)
                                        .navigationBarBackButtonHidden(true)
                        ) {
                            HStack (spacing: 20){
                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 22))
                                    .padding(.leading, 20)
                                    .frame(width: 40, height: 20)
                                Text("Deine Entwicklung")
                                    .font(.system(size: 20))
                                    .fontWeight(.medium)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 20))
                                    .padding(.trailing, 28)
                            }
                            .padding(10)
                        }.navigationBarTitle("Navigation")
                        
                    NavigationLink(destination: ProfilEinstellungen(isDark: $isDark, appearenceDark: $appearenceDark, offsetChangeName: $offsetChangeName, offsetLevel: $offsetLevel)
                                    .navigationBarTitle("")
                                    .navigationBarHidden(true)
                                    .navigationBarBackButtonHidden(true)
                    ) {
                        HStack (spacing: 20){
                            Image(systemName: "gear")
                                .font(.system(size: 22))
                                .padding(.leading, 20)
                                .frame(width: 40, height: 20)
                            Text("Einstellungen")
                                .font(.system(size: 20))
                                .fontWeight(.medium)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 20))
                                .padding(.trailing, 28)
                        }
                        .padding(10)
                    }.navigationBarTitle("Navigation")
                    Spacer()
                }.padding(.top, 30)
                .padding(.bottom, 20)
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }.accentColor(Color("black"))
    }
}

struct ProfilHomeView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilHomeView(isDark: .constant(false), appearenceDark: .constant(false), offsetChangeName: .constant(-1000), offsetLevel: .constant(-1000))
    }
}
