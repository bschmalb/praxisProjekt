//
//  TippCards.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 04.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI
import SwiftUIPager

struct TippCardsPager: View {
    @State var page1: Int = 0
    @State var page2: Int = 0
    
    @State var tipps: [Tipp] = []
    
    var data = Array(0..<10)
    
    var body: some View {
        GeometryReader { proxy in
            Pager(page: self.$page1,
                  data: self.data,
                  id: \.self) {
                    self.pageView($0)
            }
            .itemSpacing(-5)
            .interactive(0.8)
            .preferredItemSize(CGSize(width:  UIScreen.main.bounds.width - 40, height:  UIScreen.main.bounds.height / 2))
            .rotation3D()
        }
    }
    
    func pageView(_ page: Int) -> some View {
        VStack{
            Spacer()
            Image(uiImage: #imageLiteral(resourceName: "Navigating"))
                .resizable()
                .scaledToFit()
            Text("Benutze waschbare Gemüsenetzte anstatt Plastiktüten")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button(action: {
                // What to perform
            }) {
                Text("Quelle")
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding(5)
            }
            Spacer()
            HStack {
                Spacer()
                
                Button(action: {
                    
                }) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 25))
                        .foregroundColor(Color("black"))
                        .padding(30)
                        .padding(.trailing, 20)
                    
                }
                Spacer()
                Button(action: {
                    
                }) {
                    Image(systemName: "bookmark")
                        .font(.system(size: 25))
                        .foregroundColor(Color("black"))
                        .padding(30)
                        .padding(.leading, 20)
                }
                Spacer()
            }                                       }
            .background(Color("cardgreen"))
            .cornerRadius(15)
            .shadow(radius: 5)
    }
}

struct TippCardsPager_Previews: PreviewProvider {
    static var previews: some View {
        TippCardsPager()
    }
}
