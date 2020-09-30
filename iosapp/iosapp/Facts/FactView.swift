//
//  FactView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 09.09.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct FactView: View {
    
    @State var showAddFact = false
    
    @State var showRateTipps: Bool = false
    
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
                        Text("Fakten über die Natur")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.leading, 20)
                        Spacer()
                        Button(action: {
                            self.showAddFact.toggle()
                        }) {
                            Image(systemName: "plus.circle")
                                .font(.title)
                                .padding(10)
                                .padding(.trailing, 15)
                        }.sheet(isPresented: $showAddFact, content: { AddTippView(showAddTipps: self.$showAddFact)})
                    }
                    .padding(.top, 10.0)
                    .offset(y: 10)
                    
                    FactCardList()
                    
                    VStack {
                        HStack {
                            Button(action: {
                                self.showAddFact.toggle()
                                impact(style: .medium)
                            }) {
                                HStack {
                                    HStack {
                                        Image(systemName: "plus.circle")
                                            .font(.system(size: 22))
                                        Text("Selbst Fakten hinzufügen")
                                            .font(.headline)
                                            .fontWeight(.medium)
                                    }
                                    .padding(13)
                                    .padding(.leading, 10)
                                    Spacer()
                                }.frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height / 16)
                            }
                            .sheet(isPresented: $showAddFact, content: { AddTippView(showAddTipps: self.$showAddFact).environmentObject(self.levelEnv).environmentObject(self.overlay) })
                            .background(Color("buttonWhite"))
                            .cornerRadius(15)
                            .shadow(color: Color("black").opacity(0.05), radius: 5, x: 4, y: 4)
                        }
                        HStack {
                            NavigationLink (destination: RateTippView(showRateTipps: $showRateTipps)
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
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct FactView_Previews: PreviewProvider {
    static var previews: some View {
        FactView()
    }
}
