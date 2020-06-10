//
//  TippView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 10.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct TippView: View {
    
    @State var isChecked = false
    @State var isBookmarked = false
    @State var tipps: [Tipp] = []
    @State private var showAddTipps = false
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
                        Text("Tipps für Dich")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.leading, 20)

                        Spacer()
                        Button(action: {
                            self.model.isDark.toggle()
                            haptic(type: .success)
                        }) {
                            Image(systemName: "moon.circle")
                                .font(.title)
                                .padding(10)
                        }
                        Button(action: {
                            self.showAddTipps.toggle()
                        }) {
                            Image(systemName: "plus.circle")
                                .font(.title)
                                .padding(10)
                                .padding(.trailing, 15)
                        }.sheet(isPresented: $showAddTipps, content: { AddTippView()})
                    }
                    .padding(.top, 10.0)
                    .offset(y: 10)
                    
                    FilterView()
                    
                    TippCardList()
                    
                    VStack {
                        HStack {
                            Button(action: {
                                self.showAddTipps.toggle()
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
                                }.frame(width: UIScreen.main.bounds.width - 40)
                            }
                            .sheet(isPresented: $showAddTipps, content: { AddTippView() })
                            .background(Color("buttonWhite"))
                            .cornerRadius(15)
                            .shadow(color: Color(.black).opacity(0.1), radius: 10, x: 8, y: 6)
                        }
                        HStack {
                            NavigationLink (destination: RateTippView()
                                .navigationBarBackButtonHidden(false)
                                .navigationBarTitle("")
                                .navigationBarHidden(true)){
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
                            }.frame(width: UIScreen.main.bounds.width - 40)
                                .background(Color("buttonWhite"))
                                .cornerRadius(15)
                                .shadow(color: Color(.black).opacity(0.1), radius: 10, x: 8, y: 6)
                        }
                    }
                    Spacer()
                }
            }.accentColor(.primary)
            .navigationBarTitle("")
            .navigationBarHidden(true)
//                .navigationBarItems(trailing:
//                    HStack {
//                        Button(action: {
//                            self.model.isDark.toggle()
//                            haptic(type: .success)
//                        }) {
//                            Image(systemName: "moon.circle")
//                                .font(.title)
//                        }
//                        Button(action: {
//                            self.showAddTipps.toggle()
//                        }) {
//                            Image(systemName: "plus.circle")
//                                .font(.title)
//                        }.sheet(isPresented: $showAddTipps, content: { AddTippView()})
//                })
        }
    }
}

struct TippView_Previews: PreviewProvider {
    var model = ToggleModel()
    static var previews: some View {
        TippView()
    }
}
