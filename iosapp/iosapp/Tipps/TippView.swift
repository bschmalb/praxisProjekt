//
//  TippView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 10.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct TippView: View {
    
    @State var tipps: [Tipp] = []
    @State var showAddTipps = false
    @State var model = ToggleModel()
//    @Binding var filter = []
    
    var body: some View {
        NavigationView {
            ZStack {
                ZStack {
                    Color("background")
                        .edgesIgnoringSafeArea(.all)
                }
                
                VStack {
                    HStack {
                        Text("Tipps für Dich")
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
                            self.showAddTipps.toggle()
                            impact(style: .medium)
                        }) {
                            Image(systemName: "plus.circle")
                                .font(.title)
                                .padding(10)
                                .padding(.trailing, 15)
                        }.sheet(isPresented: $showAddTipps, content: { AddTippView(showAddTipps: self.$showAddTipps)})
                    }
                    .padding(.top, UIScreen.main.bounds.height / 81)
                    .offset(y: 10)
                    
                    TippCardList()
                        
                    VStack {
                        HStack {
                            Button(action: {
                                self.showAddTipps.toggle()
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
                            .sheet(isPresented: $showAddTipps, content: { AddTippView(showAddTipps: self.$showAddTipps) })
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

struct TippView_Previews: PreviewProvider {
    var model = ToggleModel()
    static var previews: some View {
        TippView()
    }
}
