//
//  CardListTest.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 24.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct CardListTest: View {
    
    @StateObject var store3 = RateTippDataStore()
    
    @State var unfilteredTipps: [Tipp] = []
    @State var filteredTipps: [Tipp] = []
    
    var body: some View {
        VStack {
            ScrollView {
                LazyHStack {
                    VStack {
                        TabView {
                            ForEach(0..<10) { index in
                                ZStack {
                                    TippCard(isChecked: .constant(false), isBookmarked: .constant(false), tipp: Tipp(id: "123", title: "Titel", source: "", level: "", category: "Transport", score: 0))
                                        .shadow(color: Color("black").opacity(0.05), radius: 5, x: 4, y: 4)
                                        .padding(.vertical, 10)
//                                    TippCard(isChecked: $store3.rateTipps[index].isChecked, isBookmarked: $store3.rateTipps[index].isBookmarked, tipp: store3.rateTipps[index])
                                }
                                .frame(width: UIScreen.main.bounds.width, height: 700)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width, height: 500)
                        .tabViewStyle(PageTabViewStyle())
                    }
                    .onAppear{
                        Api().fetchTipps { (filteredTipps) in
                            self.filteredTipps = self.filteredTipps
                        }
                    }
                }
            }
            Text("Hallo")
            Spacer()
        }
    }
}

struct CardListTest_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            if #available(iOS 14.0, *) {
                CardListTest()
            } else {
                Text("Hello")
            }
        }
    }
}
