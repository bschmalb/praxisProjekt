//
//  ContentView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 25.03.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

func haptic(type: UINotificationFeedbackGenerator.FeedbackType) {
    UINotificationFeedbackGenerator().notificationOccurred(type)
}

struct ContentView: View {
    
    @State var isChecked = false
    @State var isBookmarked = false
    @State var tipps: [Tipp] = []
    
    var body: some View {
        TabView {
            ZStack {
                ZStack {
                    Color.green
                        .edgesIgnoringSafeArea(.all)
                    Image("Background")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                        .offset(y: 100)
                }
                
                VStack {
                    HStack {
                        
                        Button(action: {
                            // What to perform
                        }) {
                            Image(systemName: "person")
                                .padding()
                                .accentColor(Color.black)
                                .background(Color.white)
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                .mask(Circle())
                                .shadow(radius: 10  )
                        }.padding(.horizontal)
                        Spacer()
                    }
                    HStack {
                        Text("Tipps des Tages")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding(.horizontal)
                        Spacer()
                    }
                    
                    if !tipps.isEmpty  {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack (spacing: 1) {
                                ForEach(tipps, id:\.self) { tipp in
                                    GeometryReader { geometry in
                                        ZStack {
                                            VStack{
                                                Spacer()
                                                Text(tipp.title)
                                                    .font(.title)
                                                    .multilineTextAlignment(.center)
                                                    .padding(.all)
                                                Button(action: {
                                                    // What to perform
                                                }) {
                                                    Text("mehr Details")
                                                        .font(.footnote)
                                                        .multilineTextAlignment(.center)
                                                        .padding(.horizontal)
                                                        .accentColor(Color.black)
                                                        .offset(y: -10)
                                                }
                                                Spacer()
                                                HStack {
                                                    Spacer()
                                                    
                                                    Button(action: {
                                                        self.isChecked.toggle()
                                                    }) {
                                                        Image(systemName: self.isChecked ? "checkmark" : "checkmark")
                                                            .font(.system(size: 25))
                                                            .foregroundColor(self.isChecked ? Color.white : Color.black)
                                                            .frame(maxWidth: .infinity)
                                                            .frame(height: 40)
                                                            .background(self.isChecked ? Color.green : Color.white)
                                                            .cornerRadius(10)
                                                            .shadow(radius: self.isChecked ? 5 : 0)
                                                            .padding(.bottom, 8)
                                                        
                                                    }
                                                    Spacer()
                                                    Button(action: {
                                                        self.isBookmarked.toggle()
                                                    }) {
                                                        Image(systemName: self.isBookmarked ? "bookmark.fill" : "bookmark")
                                                            .font(.system(size: 25))
                                                            .foregroundColor(self.isBookmarked ? Color.white : Color.black)
                                                            .frame(maxWidth: .infinity)
                                                            .frame(height: 40)
                                                            .background(self.isBookmarked ? Color.yellow : Color.white)
                                                            .cornerRadius(10)
                                                            .padding(.bottom, 8)
                                                    }
                                                    Spacer()
                                                }                                       }
                                                .frame(width: UIScreen.main.bounds.width - 60, height:
                                                    350)
                                                .background(Color.white)
                                                .cornerRadius(15)
                                                .rotation3DEffect(Angle(degrees:
                                                    (Double(geometry.frame(in: .global).minX) - 20 ) / -20), axis: (x: 0, y: 10.0, z:0))
                                                .shadow(radius: 10)
                                        }
                                    }.frame(width: UIScreen.main.bounds.width - 60, height: 350)
                                }
                            }.padding()
                        }.offset(y: -25)
                    }
                    Spacer()
                }
            }.onAppear {
                Api().fetchTipps { (tipps) in
                    self.tipps = tipps
                }
            }.tabItem {
                Image(systemName: "lightbulb.fill")
                Text("Tipps")
            }
            VStack {
                Text("Hallo")
            }.tabItem {
                Image(systemName: "person.3")
                Text("Challenges")
            }
            VStack {
                Text("Hallo")
            }.tabItem {
                Image(systemName: "book")
                Text("Dein Log")
            }
        }.accentColor(Color.green)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
