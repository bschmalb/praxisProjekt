//
//  TippCardList.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 09.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct TippCardList: View {
    
    @ObservedObject var store = TippDataStore()
    
    var cardColors: [String]  = [
        "cardgreen", "cardblue", "cardyellow", "cardpurple", "cardorange"
    ]
    
    var body: some View {
        VStack {
            if !store.tipps.isEmpty {
                ScrollView (.horizontal, showsIndicators: false) {
                    HStack (spacing: -5){
                        ForEach(store.tipps) { tipps in
                            GeometryReader { geometry in
                                TippCard(tipp: tipps)
                                    .shadow(radius: 5)
                                    .padding(10)
                                    .rotation3DEffect(Angle(degrees: (Double(geometry.frame(in: .global).minX) - 20 ) / -20), axis: (x: 0, y: 10.0, z:0))
                                    .shadow(color: Color(.black).opacity(0.1), radius: 5, x: 4, y: 3)
                            }.frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height/2.1 + 20)
                            
                        }
                    }.padding(.leading, 20)
                    .padding(.trailing, 20)
                }
            }
            else {
                ZStack {
                    VStack{
                        Spacer()
                        Image("Fix website (man)")
                            .resizable()
                            .scaledToFit()
                        Text("Stelle sicher, dass du mit dem Internet verbunden bist")
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        Button(action: {
                            // What to perform
                        }) {
                            Text("Quelle")
                                .foregroundColor(.secondary)
                                .font(.footnote)
                                .multilineTextAlignment(.center)
                                .padding(5)
                        }
                        Spacer()
                        HStack {
                            Button(action: {
                                
                            }) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 25))
                                    .foregroundColor(Color("black"))
                                    .padding(30)
                                    .padding(.leading, 30)
                                
                            }
                            Spacer()
                            Button(action: {
                                
                            }) {
                                Image(systemName: "bookmark")
                                    .font(.system(size: 25))
                                    .foregroundColor(Color("black"))
                                    .padding(40)
                                    .padding(.trailing, 30)
                            }
                        }
                        
                    }
                    .background(Color("white"))
                    .cornerRadius(15)
                    .shadow(color: Color(.black).opacity(0.1), radius: 10, x: 8, y: 6)
                }.frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height/2.1)
                .padding(.vertical, 10)
            }
        }
    }
}

//if !tipps.isEmpty  {
//                        ScrollView(.horizontal, showsIndicators: false) {
//                            HStack (spacing: -10) {
//                                ForEach(tipps) { tipp in
//                                    GeometryReader { geometry in
//                                        ZStack {
//                                            VStack{
//                                                Spacer()
//                                                Image(uiImage: #imageLiteral(resourceName: "Navigating"))
//                                                    .resizable()
//                                                    .scaledToFit()
//                                                Text(tipp.title)
//                                                    .font(.title)
//                                                    .multilineTextAlignment(.center)
//                                                    .padding(.horizontal)
//                                                Button(action: {
//                                                    // What to perform
//                                                }) {
//                                                    Text("Quelle")
//                                                        .font(.footnote)
//                                                        .multilineTextAlignment(.center)
//                                                        .padding(5)
//                                                }
//                                                Spacer()
//                                                HStack {
//                                                    Spacer()
//
//                                                    Button(action: {
//                                                        self.isChecked.toggle()
//                                                    }) {
//                                                        Image(systemName: self.isChecked ? "checkmark" : "checkmark")
//                                                            .font(.system(size: 25))
//                                                            .foregroundColor(self.isChecked ? Color("white") : Color("black"))
//                                                            .padding(30)
//                                                            .padding(.trailing, 20)
//
//                                                    }
//                                                    Spacer()
//                                                    Button(action: {
//                                                        self.isBookmarked.toggle()
//                                                    }) {
//                                                        Image(systemName: self.isBookmarked ? "bookmark.fill" : "bookmark")
//                                                            .font(.system(size: 25))
//                                                            .foregroundColor(self.isBookmarked ? Color("white") : Color("black"))
//                                                            .padding(30)
//                                                            .padding(.leading, 20)
//                                                    }
//                                                    Spacer()
//                                                }                                       }
//                                                .frame(width: UIScreen.main.bounds.width - 40, height:
//                                                    375)
//                                                .background(Color("cardgreen"))
//                                                .cornerRadius(15)
//                                                .rotation3DEffect(Angle(degrees:
//                                                    (Double(geometry.frame(in: .global).minX) - 20 ) / -20), axis: (x: 0, y: 10.0, z:0))
//                                                .shadow(radius: 5)
//                                        }
//                                    }.frame(width: UIScreen.main.bounds.width - 40, height: 375)
//                                }
//                            }.padding(10)
//                            .padding(.horizontal, 10)
//                        }
//                    }

struct TippCardList_Previews: PreviewProvider {
    static var previews: some View {
        TippCardList()
    }
}
