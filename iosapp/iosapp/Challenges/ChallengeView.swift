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
    
    @EnvironmentObject var levelEnv: UserLevel
    @EnvironmentObject var overlay: Overlay
    
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
                                    impact(style: .medium)
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
                            
                            ChallengeCardList()
                            
                            VStack {
                                HStack {
                                    Button(action: {
                                        self.showAddChallenge.toggle()
                                        impact(style: .medium)
                                    }) {
                                        HStack {
                                            HStack {
                                                Image(systemName: "plus.circle")
                                                    .font(.system(size: 22))
                                                Text("Eigenen Tipp hinzufügen")
                                                    .font(.headline)
                                                    .fontWeight(.medium)
                                            }
                                            .padding(13)
                                            .padding(.leading, 10)
                                            Spacer()
                                        }.frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height / 16)
                                    }
                                    .sheet(isPresented: $showAddChallenge, content: { AddTippView(showAddTipps: self.$showAddChallenge).environmentObject(self.levelEnv).environmentObject(self.overlay) })
                                    .background(Color("buttonWhite"))
                                    .cornerRadius(15)
                                    .shadow(color: Color("black").opacity(0.05), radius: 5, x: 4, y: 4)
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
                                                Text("Tipps von Nutzern bewerten")
                                                    .font(.headline)
                                                    .fontWeight(.medium)
                                            }
                                            .padding(13)
                                            .padding(.leading, 10)
                                            Spacer()
                                    }.frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height / 16)
                                        .background(Color("buttonWhite"))
                                        .cornerRadius(15)
                                        .shadow(color: Color("black").opacity(0.05), radius: 5, x: 4, y: 4)
                                }
                            }.offset(y: -UIScreen.main.bounds.height / 81)
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
