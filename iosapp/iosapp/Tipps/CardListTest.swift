//
//  CardListTest.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 24.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct CardListTest: View {
    
    @State var unfilteredTipps: [Tipp] = []
    @State var filteredTipps: [Tipp] = []
    @State var rateTipps: [Tipp] = []
    
    @ObservedObject var store2 = RateTippDataStore()
    
    var body: some View {
        VStack {
            GeometryReader { proxy in
                UIScrollViewWrapper {
                    HStack {
                        ForEach(self.store2.rateTipps.indices, id: \.self) { index in
                            HStack {
                                GeometryReader { geometry in
                                    TippCard(isChecked: self.$store2.rateTipps[index].isChecked, isBookmarked: self.$store2.rateTipps[index].isBookmarked, tipp: self.store2.rateTipps[index])
                                        .rotation3DEffect(Angle(degrees: (Double(geometry.frame(in: .global).minX) - 20 ) / -20), axis: (x: 0, y: 10.0, z:0))
                                        .shadow(color: Color("black").opacity(0.05), radius: 5, x: 4, y: 4)
                                }
                                .frame(width: UIScreen.main.bounds.width - 7.5, height: UIScreen.main.bounds.height/2.1 + 20)
                            }
                        }
                    }.padding(.horizontal, 15)
                    .frame(height: proxy.size.height) // This ensures the content uses the available width, otherwise it will be pinned to the left
                }
            }
        }.onAppear{
            Api().fetchTipps { (unfilteredTipps) in
                self.unfilteredTipps = unfilteredTipps
                self.filteredTipps = self.unfilteredTipps
            }
        }
    }
}

struct CardListTest_Previews: PreviewProvider {
    static var previews: some View {
        CardListTest()
    }
}
