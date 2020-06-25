//
//  ProfilHomeView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 19.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct ProfilHomeView: View {
    
    @State var tcSelected = false
    @State var tippsSelected = false
    @State var challengesSelected = false
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color("background")
                .edgesIgnoringSafeArea(.all)
                VStack {
                    if !tcSelected {
                        Image("ProfileImage")
                            .resizable()
                            .scaledToFit()
                            .padding(40)
                            .padding(.top, 20)
                    }
                    
                    if (!challengesSelected) {
                        NavigationLink(destination: ProfilTippView()
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                            .navigationBarBackButtonHidden(true)
                        ) {
                            HStack (spacing: 20){
                                Image(systemName: "lightbulb")
                                    .font(.system(size: 22))
                                    .padding(.leading, 20)
                                    .frame(width: 70, height: 20)
                                Text("Deine Tipps")
                                    .font(.system(size: 22))
                                    .fontWeight(.medium)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .rotationEffect(Angle(degrees: tippsSelected ? 180 : 0))
                                    .font(.system(size: 20))
                                    .padding(.trailing, 28)
                            }.padding(10)
                        }.navigationBarTitle("Navigation")
                    }
                    
                    if (!tippsSelected) {
                        NavigationLink(destination: ProfilTippView()
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                            .navigationBarBackButtonHidden(true)
                        ) {
                            HStack (spacing: 20){
                                Image(systemName: "person.3")
                                    .font(.system(size: 22))
                                    .padding(.leading, 20)
                                    .frame(width: 70, height: 20)
                                Text("Deine Challenges")
                                    .font(.system(size: 22))
                                    .fontWeight(.medium)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .rotationEffect(Angle(degrees: challengesSelected ? 180 : 0))
                                    .font(.system(size: 20))
                                    .padding(.trailing, 28)
                            }
                            .padding(10)
                        }.navigationBarTitle("Navigation")
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
                    if tippsSelected {
                        ProfilTippView()
                    }
                    if (challengesSelected) {
                        TippCard(isChecked: .constant(false), isBookmarked: .constant(false), tipp: Tipp(id: "123", title: "Challenge", source: "Google.com", level: "Leicht", category: "Ernährung", score: 20))
                    }
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
        ProfilHomeView()
    }
}
