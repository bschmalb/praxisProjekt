//
//  FactsCardList.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 11.09.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct FactCardList: View {
    //    @ObservedObject var store = TippDataStore()
    
    @State var filter = filterData
    
    @State var filteredFacts: [Fact] = [Fact(id: "asdas", title: "asdsad", source: "https://www.google.com", level: "Leicht", category: "Ernährung", score: 0, postedBy: "", isChecked: true, isBookmarked: true, official: "Offiziell")]
    
    @State var filterString: String = ""
    
    @State var loading: Bool = false
    
    @State var filterCategory2: [String] = ["Ernährung", "Transport", "Haushalt", "Ressourcen"]
    @State var filterLevel2: [String] = ["Leicht", "Mittel", "Schwer"]
    @State var filterPoster: [String] = ["Offiziell", "Community"]
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack (spacing: 20) {
                    Text("Filter:")
                        .font(.system(size: 20, weight: .medium))
                        .padding(.leading, 20)
                    ForEach(filter.indices, id: \.self) { index in
                        HStack {
                            FilterView(isSelected: self.$filter[index].isSelected, filter: self.filter[index]).environmentObject(UserObserv())
                                .onTapGesture {
                                    self.filter[index].isSelected.toggle()
                                    self.filterTipps(filterName: self.filter[index].name)
                                    impact(style: .heavy)
                                    self.loading = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        self.loading = false
                                    }
                            }
                        }
                    }
                }
                .padding(.vertical, UIScreen.main.bounds.height / 81)
            }.accentColor(Color("black"))
            
            ZStack {
                VStack {
                    if (!self.filteredFacts.isEmpty) {
                        GeometryReader { proxy in
                            UIScrollViewWrapper {
                                HStack {
                                    ForEach(self.filteredFacts.indices, id: \.self) { index in
                                        HStack {
                                            if(self.filterCategory2.contains(self.filteredFacts[index].category) && self.filterLevel2.contains(self.filteredFacts[index].level) && self.filterPoster.contains(self.filteredFacts[index].official)) {
                                                GeometryReader { geometry in
                                                    FactCard(isChecked: self.$filteredFacts[index].isChecked, isBookmarked: self.$filteredFacts[index].isBookmarked, fact: self.filteredFacts[index])
                                                        .rotation3DEffect(Angle(degrees: (Double(geometry.frame(in: .global).minX) - 5 ) / -10), axis: (x: 0, y: 10.0, z:0))
                                                        .shadow(color: Color("black").opacity(0.05), radius: 5, x: 4, y: 4)
                                                        .padding(.vertical, 10)
                                                }
                                                .frame(width: UIScreen.main.bounds.width - 7.5, height: UIScreen.main.bounds.height/2.1 + 20)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, 5)
                                .frame(height: UIScreen.main.bounds.height/2.1 + 20)
                                .background(Color("background"))
                                .animation(.spring())
                            }
                        }
                        .frame(height: UIScreen.main.bounds.height/2.1 + 20)
                        .offset(x: loading ? 300 : 0)
                        .animation(.spring())
                    }
                    else {
                        CustomCard(image: "Fix website (man)", text: "Stelle sicher, dass du mit dem Internet verbunden bist", color: "buttonWhite")
                            .padding(.horizontal, 15)
                            .padding(.bottom, 5)
                    }
                }
                .offset(y: -UIScreen.main.bounds.height / 81)
                .animation(.spring())
                if (loading) {
                    LottieView(filename: "loadingCircle", loop: true)
                        .shadow(color: Color(.white), radius: 1, x: 0, y: 0)
                        .frame(width: 100, height: 100)
                }
            }
        }
        .onAppear{
            FactApi().fetchFacts { (filteredFacts) in
                self.filteredFacts = filteredFacts
            }
        }
    }
    
    func filterTipps(filterName: String){
        if (filterName == "Ernährung" || filterName == "Transport" || filterName == "Haushalt" || filterName == "Ressourcen") {
            if (!filterCategory2.contains(filterName)){
                filterCategory2.append(filterName)
            } else {
                filterCategory2.removeAll(where: {$0 == filterName})
            }
        }
        if (filterName == "Leicht" || filterName == "Mittel" || filterName == "Schwer") {
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

struct FactsCardList_Previews: PreviewProvider {
    static var previews: some View {
        FactCardList()
    }
}
