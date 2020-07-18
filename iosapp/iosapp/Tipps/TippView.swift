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
    @Binding var isDark: Bool
    @Binding var appearenceDark: Bool
    
    @ObservedObject var storeTipps = TippDataStore()
    
    @EnvironmentObject var levelEnv: UserLevel
    @EnvironmentObject var overlay: Overlay
    
    @State var firstUseTipp = UserDefaults.standard.bool(forKey: "firstUseTipp")
    
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
//                        Button(action: {
//                            self.isDark.toggle()
//                            self.appearenceDark.toggle()
//                            UserDefaults.standard.set(self.appearenceDark, forKey: "appearenceDark")
//                            impact(style: .medium)
//                        }) {
//                            Image(systemName: "moon.circle")
//                                .font(.title)
//                                .padding(10)
//                        }
                        Button(action: {
                            self.showAddTipps.toggle()
                            impact(style: .medium)
                        }) {
                            Image(systemName: "plus.circle")
                                .font(.title)
                                .padding(10)
                                .padding(.trailing, 15)
                        }.sheet(isPresented: $showAddTipps, content: { AddTippView(showAddTipps: self.$showAddTipps).environmentObject(self.levelEnv).environmentObject(self.overlay)})
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
                            .sheet(isPresented: $showAddTipps, content: { AddTippView(showAddTipps: self.$showAddTipps).environmentObject(self.levelEnv).environmentObject(self.overlay) })
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
                if (!firstUseTipp) {
                    VStack {
                        LottieView(filename: "swipe", loop: true)
                            .frame(width: 200, height: 200)
                            .background(Color("background"))
                            .cornerRadius(20)
                            .shadow(radius: 20)
                            .offset(x: show ? 0 : -UIScreen.main.bounds.width, y: -50)
                            .opacity(show ? 1 : 0)
                            .scaleEffect(show ? 1 : 0)
                            .onTapGesture {
                                withAnimation { self.show = false }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                                    UserDefaults.standard.set(true, forKey: "firstUseTipp")
                                })
                        }
                        .animation(.spring())
                    }
                }
            }.accentColor(.primary)
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .gesture(DragGesture()
                    .onChanged({ (value) in
                        if (value.translation.width < 30) {
                            self.show = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                                UserDefaults.standard.set(true, forKey: "firstUseTipp")
                            })
                        }
                    }))
                .onAppear {
                    if self.appearenceDark {
                    self.isDark = false
                }else{
                    self.isDark = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                     self.show = true
                })
            }
        }
    }
}

struct TippView_Previews: PreviewProvider {
    var model = ToggleModel()
    static var previews: some View {
        TippView(isDark: .constant(false), appearenceDark: .constant(false))
    }
}
