//
//  TippView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 10.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct TippView: View {
    
    
    @State var show: Bool = false
    @State var tipps: [Tipp] = []
    @State var showAddTipps = false
    @State var showRateTipps = false
    @ObservedObject var filter: FilterData2
    
    @ObservedObject var storeTipps = TippDataStore()
    
    @EnvironmentObject var levelEnv: UserLevel
    @EnvironmentObject var overlay: Overlay
    @EnvironmentObject var myUrl: ApiUrl
    
    @State var firstUseTipp = UserDefaults.standard.bool(forKey: "firstUseTipp")
    
    var body: some View {
        ZStack {
                ZStack {
                    Color("background")
                        .edgesIgnoringSafeArea(.all)
                }
                
                VStack (spacing: UIScreen.main.bounds.height < 700 ? 5 : 10) {
                    HStack {
                        Text("Tipps für Dich")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.leading, 20)
                        Spacer()
                        Button(action: {
                            self.showAddTipps.toggle()
                            impact(style: .medium)
                        }) {
                            Image(systemName: "plus.circle")
                                .font(.title)
                                .padding(10)
                                .padding(.trailing, 15)
                        }.sheet(isPresented: $showAddTipps, content: { AddTippView(showAddTipps: self.$showAddTipps).environmentObject(self.levelEnv).environmentObject(self.overlay).environmentObject(self.myUrl)})
                    }
                    .padding(.top, UIScreen.main.bounds.height / 81)
                    .offset(y: 10)
                    
                    TippCardList(filter: filter).environmentObject(UserObserv()).environmentObject(FilterData2())
                    
                    VStack (spacing: 10) {
                        HStack {
                            Button(action: {
                                self.showAddTipps.toggle()
                                impact(style: .medium)
                            }) {
                                HStack {
                                    HStack {
                                        Image(systemName: "plus.circle")
                                            .font(.system(size: UIScreen.main.bounds.width < 500 ? UIScreen.main.bounds.width * 0.05 : 20, weight: Font.Weight.medium))
                                        Text("Eigenen Tipp hinzufügen")
                                            .font(.system(size: UIScreen.main.bounds.width < 500 ? UIScreen.main.bounds.width * 0.045 : 20))
                                            .fontWeight(.medium)
                                    }
                                    .padding(13)
                                    .padding(.leading, 10)
                                    Spacer()
                                }.frame(width: UIScreen.main.bounds.width - 30, height: 20 + UIScreen.main.bounds.height / 30)
                            }
                            .sheet(isPresented: $showAddTipps, content: { AddTippView(showAddTipps: self.$showAddTipps).environmentObject(self.levelEnv).environmentObject(self.overlay).environmentObject(self.myUrl) })
                            .background(Color("buttonWhite"))
                            .cornerRadius(15)
                            .shadow(color: Color("black").opacity(0.05), radius: 5, x: 4, y: 4)
                        }
                        HStack {
                            Button(action: {
                                self.showRateTipps.toggle()
                                impact(style: .medium)
                            }) {
                                HStack {
                                    Image(systemName: "hand.thumbsup")
                                        .font(.system(size: UIScreen.main.bounds.width < 500 ? UIScreen.main.bounds.width * 0.05 : 20, weight: Font.Weight.medium))
                                    Text("Tipps von Nutzern bewerten")
                                        .font(.system(size: UIScreen.main.bounds.width < 500 ? UIScreen.main.bounds.width * 0.045 : 20))
                                        .fontWeight(.medium)
                                }
                                .padding(13)
                                .padding(.leading, 10)
                                Spacer()
                            }
                            .frame(width: UIScreen.main.bounds.width - 30, height: 20 + UIScreen.main.bounds.height / 30)
                            .background(Color("buttonWhite"))
                            .cornerRadius(15)
                            .shadow(color: Color("black").opacity(0.05), radius: 5, x: 4, y: 4)
                        .sheet(isPresented: $showRateTipps, content: { RateTippView(showRateTipps: self.$showRateTipps).environmentObject(self.levelEnv).environmentObject(self.overlay).environmentObject(self.myUrl)})
                        }
                    }.offset(y: -UIScreen.main.bounds.height / 81)
                    Spacer()
                }
                if (!firstUseTipp) {
                    ZStack {
                        LottieView(filename: "swipe", loop: true)
                            .offset(y: -20)
                        Text("Okay!")
                                .foregroundColor(.black)
                                .font(.system(size: 22, weight: Font.Weight.medium))
                                .padding(8)
                                .offset(y: 73)
                    }
                        .frame(width: 200, height: 220)
                        .background(Color("background"))
                        .cornerRadius(40)
                        .shadow(radius: 20)
                        .opacity(show ? 1 : 0)
                        .scaleEffect(show ? 1 : 0.8)
                        .onTapGesture {
                            withAnimation { self.show = false }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                                UserDefaults.standard.set(true, forKey: "firstUseTipp")
                                firstUseTipp = true
                            })}
                        .animation(.spring())
                }
            }.accentColor(.primary)
                .gesture(DragGesture()
                    .onChanged({ (value) in
                        if (value.translation.width < 30) {
                            self.show = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                UserDefaults.standard.set(true, forKey: "firstUseTipp")
                                firstUseTipp = true
                            })
                        }
                    }))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                        self.show = true
                    })
            }
    }
}

struct TippView_Previews: PreviewProvider {
    var model = ToggleModel()
    static var previews: some View {
        TippView(filter: FilterData2())
    }
}
