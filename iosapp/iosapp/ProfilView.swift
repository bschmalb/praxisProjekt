//
//  ProfilView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 03.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct ProfilView: View {
    
    @State var tcSelected = false
    @State var tippsSelected = false
    @State var challengesSelected = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ZStack {
                    Color("background")
                        .edgesIgnoringSafeArea(.all)
                }
                
                VStack {
                    HStack {
                        Spacer()
                        LevelView(frameWidth: 60, frameHeight: 60)
                            .padding(30)
                            .offset(y: -5)
                    }
                    Spacer()
                }
                
                VStack {
                    HStack {
                        VStack (alignment: .leading){
                            Text("Hallo Basti")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.leading, 20)
                                .padding(.bottom, 5)
                            Text("Wilkommen in deinem Profil")
                                .font(.callout)
                                .padding(.leading, 20)
                        }
                        Spacer()
                    }
                    .padding(.top, 10.0)
                    .offset(y: 10)
                    
                    
                    Image("ProfileImage")
                            .resizable()
                            .scaledToFit()
                            .padding(tcSelected ? 0 : 40)
                            .padding(.top, 20)
                    
                    if (!challengesSelected) {
                        Button(action: {
                            self.tippsSelected.toggle()
                            self.tcSelected.toggle()
                        }) {
                            HStack (spacing: 20){
                                Image(systemName: "lightbulb")
                                    .font(.system(size: 22))
                                    .padding(.leading, 20)
                                    .frame(width: 70, height: 20)
                                Text("Deine Tipps")
                                    .font(.system(size: 22))
                                    .fontWeight(.medium)
                                Spacer()
                                Image(systemName: "chevron.up")
                                    .rotationEffect(Angle(degrees: tippsSelected ? 180 : 0))
                                    .font(.system(size: 20))
                                    .padding(.trailing, 28)
                            }.padding(10)
                        }
                        .opacity(challengesSelected ? 0 : 1)
                    }
                    
                    if (!tippsSelected) {
                        Button(action: {
                            self.challengesSelected.toggle()
                            self.tcSelected.toggle()
                        }) {
                            HStack (spacing: 20){
                                Image(systemName: "person.3")
                                    .font(.system(size: 22))
                                    .padding(.leading, 20)
                                    .frame(width: 70, height: 20)
                                Text("Deine Challenges")
                                    .font(.system(size: 22))
                                    .fontWeight(.medium)
                                Spacer()
                                Image(systemName: "chevron.up")
                                    .rotationEffect(Angle(degrees: challengesSelected ? 180 : 0))
                                    .font(.system(size: 20))
                                    .padding(.trailing, 28)
                            }
                            .padding(10)
                        }
                        .opacity(tippsSelected ? 0 : 1)
                    }
                    
                    if (!tcSelected) {
                        Button(action: {
                            
                        }) {
                            HStack (spacing: 20){
                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 22))
                                    .padding(.leading, 20)
                                    .frame(width: 70, height: 20)
                                Text("Deine Entwicklung")
                                    .font(.system(size: 22))
                                    .fontWeight(.medium)
                                Spacer()
                            }.padding(10)
                        }
                    }
                    
                    if (!tcSelected) {
                        Button(action: {
                            
                        }) {
                            HStack (spacing: 20){
                                Image(systemName: "gear")
                                    .font(.system(size: 22))
                                    .padding(.leading, 20)
                                    .frame(width: 70, height: 20)
                                Text("Einstellungen")
                                    .font(.system(size: 22))
                                    .fontWeight(.medium)
                                Spacer()
                            }.padding(10)
                        }
                    }
                    
//                    if (tippsSelected) {
//                        TippCard(tipp: Tipp(id: "123", title: "Tipp", source: "Google.com", level: "Leicht", category: "Ernährung", score: 20, isChecked: false, isBookmarked: false))
//                    }
//                    if (challengesSelected) {
//                        TippCard(tipp: Tipp(id: "123", title: "Challenge", source: "Google.com", level: "Leicht", category: "Ernährung", score: 20, isChecked: false, isBookmarked: false))
//                    }
                    Spacer()
                }
                .animation(.spring())
                .accentColor(.primary)
                .navigationBarTitle("")
                .navigationBarHidden(true)
            }
        }
    }
}

struct ProfilView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilView()
    }
}
