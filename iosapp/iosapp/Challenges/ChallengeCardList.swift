//
//  TippCardList.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 09.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct ChallengeCardList: View {
    
    @ObservedObject var store = ChallengeDataStore()
    
    @State var filter = filterData
    
    @State var unfilteredChallenges: [Challenge] = []
    @State var filteredChallenges: [Challenge] = []
    
    @State var filterString: String = ""
    
    @State var filterCategory2: [String] = ["Ernährung", "Transport", "Recycling", "Ressourcen"]
    @State var filterLevel2: [String] = ["Einfach", "Mittel", "Schwer"]
    @State var filterPoster: [String] = ["Offiziell", "Community"]
    
    //    var cardColors: [String]  = [
    //        "cardgreen", "cardblue", "cardyellow", "cardpurple", "cardorange"
    //    ]
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack (spacing: 20) {
                    Text("Filter:")
                        .font(.system(size: 20, weight: .medium))
                        .padding(.leading, 20)
                    ForEach(filter.indices, id: \.self) { index in
                        HStack {
                            ChallengeFilterView(isSelected: self.$filter[index].isSelected, filter: self.filter[index])
                                .onTapGesture {
                                    self.filter[index].isSelected.toggle()
                                    self.filterTipps(filterName: self.filter[index].name)
                                    impact(style: .heavy)
                                }
                        }
                    }
                }
                .padding(.vertical, UIScreen.main.bounds.height / 81)
            }.accentColor(Color("black"))
            
            VStack {
                if (!self.filteredChallenges.isEmpty) {
                    GeometryReader { proxy in
                        UIScrollViewWrapper {
                            HStack {
                                ForEach(self.filteredChallenges.indices, id: \.self) { index in
                                    HStack {
                                        if(self.filterCategory2.contains(self.filteredChallenges[index].category) && self.filterLevel2.contains(self.filteredChallenges[index].level) && self.filterPoster.contains(self.filteredChallenges[index].official ?? "Community")) {
                                            GeometryReader { geometry in
                                                ChallengeCard(isChecked: self.$filteredChallenges[index].isChecked, isBookmarked: self.$filteredChallenges[index].isBookmarked, challenge: self.filteredChallenges[index])
                                                    .rotation3DEffect(Angle(degrees: (Double(geometry.frame(in: .global).minX) - 5 ) / -10), axis: (x: 0, y: 10.0, z:0))
                                                    .shadow(color: Color("black").opacity(0.05), radius: 5, x: 4, y: 4)
                                                    .padding(.vertical, 10)
                                            }
                                            .frame(width: UIScreen.main.bounds.width - 7.5, height: UIScreen.main.bounds.height/2.3 + 20)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 5)
                            .frame(height: UIScreen.main.bounds.height/2.3 + 20)
                            .background(Color("background"))
                            .animation(.spring())
                        }
                    }
                    .frame(height: UIScreen.main.bounds.height/2.3 + 20)
                    .animation(.spring())
                }
                else {
                    NoConnectionCard()
                        .padding(15)
                }
            }
            .offset(y: -UIScreen.main.bounds.height / 81)
            .animation(.spring())
        }
        .onAppear{
            ChallengeApi().fetchChallenges { (unfilteredChallenges) in
                self.unfilteredChallenges = unfilteredChallenges
                self.filteredChallenges = self.unfilteredChallenges
            }
        }
    }
    
    func filterTipps(filterName: String){
        if (filterName == "Ernährung" || filterName == "Transport" || filterName == "Recycling" || filterName == "Ressourcen") {
            if (!filterCategory2.contains(filterName)){
                filterCategory2.append(filterName)
            } else {
                filterCategory2.removeAll(where: {$0 == filterName})
            }
        }
        if (filterName == "Einfach" || filterName == "Mittel" || filterName == "Schwer") {
            if (!filterLevel2.contains(filterName)){
                filterLevel2.append(filterName)
            } else {
                filterLevel2.removeAll(where: {$0 == filterName})
            }
        }
        if (filterName == "Offiziell" || filterName == "Community") {
            if (!filterPoster.contains(filterName)){
                filterPoster.append(filterName)
            } else {
                filterPoster.removeAll(where: {$0 == filterName})
            }
        }
    }
}


struct ChallengeFilterView: View {
    @Binding var isSelected: Bool
    var filter: Filter
    
    var body: some View {
        HStack {
            HStack {
                Image("\(filter.icon)")
                    .resizable()
                    .scaledToFit()
                    .font(.title)
                    .frame(width: 30, height: 30)
                Text(filter.name)
                    .font(.headline)
                    .fontWeight(.medium)
                    .accentColor(Color("black"))
            }.padding(.horizontal, 10)
            .padding(.vertical, 6)
        }
        .background(Color(isSelected ? "buttonWhite" : "transparent"))
        .cornerRadius(15)
        .shadow(color: isSelected ?Color("black").opacity(0.1) : Color("transparent"), radius: 5, x: 4, y: 4)
    }
}


struct ChallengeCardList_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeCardList()
    }
}
