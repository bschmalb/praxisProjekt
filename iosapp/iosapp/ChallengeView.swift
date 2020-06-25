//
//  ChallengeView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 21.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct ChallengeView: View {
    
    @State var tipps: [Tipp] = []
    @State var showAddChallenge = false
    @State var model = ToggleModel()
    
    var body: some View {
        NavigationView {
                    ZStack {
                        ZStack {
                            Color("background")
                                .edgesIgnoringSafeArea(.all)
                        }
                        
                        VStack {
                            HStack {
                                Text("Challenges")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .padding(.leading, 20)

                                Spacer()
                                Button(action: {
                                    self.model.isDark.toggle()
                                    UserDefaults.standard.set(self.model.isDark, forKey: "isDark")
                                    haptic(type: .success)
                                }) {
                                    Image(systemName: "moon.circle")
                                        .font(.title)
                                        .padding(10)
                                }
                                Button(action: {
                                    self.showAddChallenge.toggle()
                                }) {
                                    Image(systemName: "plus.circle")
                                        .font(.title)
                                        .padding(10)
                                        .padding(.trailing, 15)
                                }.sheet(isPresented: $showAddChallenge, content: { AddTippView(showAddTipps: self.$showAddChallenge)})
                            }
                            .padding(.top, 10.0)
                            .offset(y: 10)
                            
                            TippCardList()
                            
                            VStack {
                                HStack {
                                    Button(action: {
                                        self.showAddChallenge.toggle()
                                    }) {
                                        HStack {
                                            HStack {
                                                Image(systemName: "plus.circle")
                                                    .font(.system(size: 22))
                                                Text("Eigene Challenge hinzufügen")
                                                    .font(.headline)
                                                    .fontWeight(.medium)
                                            }
                                            .padding(13)
                                            .padding(.leading, 10)
                                            Spacer()
                                        }.frame(width: UIScreen.main.bounds.width - 30, height: 50)
                                    }
                                    .sheet(isPresented: $showAddChallenge, content: { AddTippView(showAddTipps: self.$showAddChallenge) })
                                    .background(Color("buttonWhite"))
                                    .cornerRadius(15)
                                    .shadow(color: Color(.black).opacity(0.05), radius: 10, x: 8, y: 6)
                                }
                                HStack {
                                    NavigationLink (destination: RateTippView()
                                        .navigationBarBackButtonHidden(false)
                                        .navigationBarTitle("")
                                        .navigationBarHidden(true)
                                    ){
                                            HStack {
                                                Image(systemName: "hand.thumbsup")
                                                    .font(.system(size: 20, weight: .medium))
                                                Text("Challenges von Nutzern bewerten")
                                                    .font(.headline)
                                                    .fontWeight(.medium)
                                            }
                                            .padding(13)
                                            .padding(.leading, 10)
                                            Spacer()
                                    }.frame(width: UIScreen.main.bounds.width - 30, height: 50)
                                        .background(Color("buttonWhite"))
                                        .cornerRadius(15)
                                        .shadow(color: Color(.black).opacity(0.05), radius: 10, x: 8, y: 6)
                                }
                            }.padding(.top, 5)
                            Spacer()
                        }
                    }.accentColor(.primary)
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                }
    }
}

struct ChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeView()
    }
}
