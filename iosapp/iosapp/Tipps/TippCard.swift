//
//  TippCard.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 07.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct TippCard: View {
    
    //    @ObservedObject var store = TippDataStore()
    
    var tipp: Tipp
    //var cardColor: String
    
    var cardColors2: [String]  = [
        "cardgreen2", "cardblue2", "cardyellow2", "cardpurple2", "cardorange2", "cardred2", "cardturqouise2", "cardyelgre2", "cardpink2g"
    ]
    
    var body: some View {
        ZStack {
            VStack{
                Spacer()
                Image("I"+tipp.category)
                    .resizable()
                    .scaledToFit()
                    .frame(minHeight: 150, maxHeight: 200)
                Text(tipp.title)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(Color("alwaysblack"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Button(action: {
                    // What to perform
                }) {
                    Text("Quelle")
                        .foregroundColor(.gray)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                }
                HStack {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 25))
                            .foregroundColor(Color("alwaysblack"))
                            .padding(20)
                            .padding(.bottom, 10)
                            .padding(.leading, 50)
                        
                    }
                    Spacer()
                    Button(action: {
                        
                    }) {
                        Image(systemName: "bookmark")
                            .font(.system(size: 25))
                            .foregroundColor(Color("alwaysblack"))
                            .padding(20)
                            .padding(.bottom, 10)
                            .padding(.trailing, 50)
                    }
                }
                
            }
            .background(Color(cardColors2.randomElement() ?? cardColors2[0]))
                .cornerRadius(15)
            VStack {
                HStack(alignment: .top) {
                    Image(tipp.category)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .opacity(0.1)
                        .padding(.leading, 20)
                        .padding(.vertical)
                    Image(tipp.level)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .opacity(0.1)
                        .padding(.vertical)
                    Spacer()
                }
                Spacer()
            }.frame(width: UIScreen.main.bounds.width - 40, height:
                375)
        }.frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height/2.1)
    }
}

struct TippCard_Previews: PreviewProvider {
    static var previews: some View {
        TippCard(tipp: .init(id: "123", title: "Saisonale und Regionale Produkte sind umweltfreundlicher als Bio-Produkte", source: "www.google.com", level: "Leicht", category: "Ernährung", score: 25))
    }
}
