//
//  FactView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 09.09.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct FactView: View {
    
    
    @State var show: Bool = false
    @State var facts: [Fact] = []
    @State var showAddFacts = false
    @State var showRateFacts = false
    @ObservedObject var filter: FilterDataFacts
    
    @EnvironmentObject var levelEnv: UserLevel
    @EnvironmentObject var overlay: Overlay
    @EnvironmentObject var myUrl: ApiUrl
    
    var screen = UIScreen.main.bounds
    
    var body: some View {
        NavigationView {
            ZStack {
                ZStack {
                    Color("background")
                        .edgesIgnoringSafeArea(.all)
                }
                
                VStack (spacing: screen.height < 700 ? 5 : 10) {
                    HStack {
                        Text("Fakten über die Natur")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.leading, 20)
                        Spacer()
                        Button(action: {
                            self.showAddFacts.toggle()
                            impact(style: .medium)
                        }) {
                            Image(systemName: "plus.circle")
                                .font(.title)
                                .padding(10)
                                .padding(.trailing, 15)
                        }.sheet(isPresented: $showAddFacts, content: { AddFactView(showAddFacts: self.$showAddFacts).environmentObject(self.levelEnv).environmentObject(self.overlay).environmentObject(self.myUrl)})
                    }
                    .padding(.top, screen.height / 81)
                    .offset(y: 10)
                    
                    FactCardList(filter: filter).environmentObject(UserObserv()).environmentObject(FilterDataFacts())
                    
                    VStack (spacing: 10) {
                        HStack {
                            Button(action: {
                                self.showAddFacts.toggle()
                                impact(style: .medium)
                            }) {
                                HStack {
                                    HStack {
                                        Image(systemName: "plus.circle")
                                            .font(.system(size: screen.width < 500 ? screen.width * 0.05 : 20, weight: Font.Weight.medium))
                                        Text("Selbst Fakten hinzufügen")
                                            .font(.system(size: screen.width < 500 ? screen.width * 0.045 : 20))
                                            .fontWeight(.medium)
                                    }
                                    .padding(13)
                                    .padding(.leading, 10)
                                    Spacer()
                                }.frame(width: screen.width - 30, height: 20 + screen.height / 30)
                            }
                            .sheet(isPresented: $showAddFacts, content: { AddFactView(showAddFacts: self.$showAddFacts).environmentObject(self.levelEnv).environmentObject(self.overlay).environmentObject(self.myUrl) })
                            .background(Color("buttonWhite"))
                            .cornerRadius(15)
                            .shadow(color: Color("black").opacity(0.05), radius: 5, x: 4, y: 4)
                        }
                        HStack {
                            Button(action: {
                                self.showRateFacts.toggle()
                                impact(style: .medium)
                            }) {
                                HStack {
                                    Image(systemName: "hand.thumbsup")
                                        .font(.system(size: screen.width < 500 ? screen.width * 0.05 : 20, weight: Font.Weight.medium))
                                    Text("Fakten von Nutzern bewerten")
                                        .font(.system(size: screen.width < 500 ? screen.width * 0.045 : 20))
                                        .fontWeight(.medium)
                                }
                                .padding(13)
                                .padding(.leading, 10)
                                Spacer()
                            }
                            .frame(width: screen.width - 30, height: 20 + screen.height / 30)
                            .background(Color("buttonWhite"))
                            .cornerRadius(15)
                            .shadow(color: Color("black").opacity(0.05), radius: 5, x: 4, y: 4)
                        .sheet(isPresented: $showRateFacts, content: { RateFactView(showRateFacts: self.$showRateFacts).environmentObject(self.levelEnv).environmentObject(self.overlay).environmentObject(self.myUrl)})
                        }
                    }.offset(y: -screen.height / 81)
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
        FactView(filter: FilterDataFacts())
    }
}
