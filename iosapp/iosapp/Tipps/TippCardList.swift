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
    
    @State var filter = filterData
    
    @State var unfilteredTipps: [Tipp] = []
    @State var filteredTipps: [Tipp] = []
    
    @State var filterString: String = ""
    
    @State var filterCategory: [String] = []
    @State var filterLevel: [String] = []
    @State var filterPoster: [String] = []
    
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
                            FilterView(isSelected: self.$filter[index].isSelected, filter: self.filter[index])
                                .onTapGesture {
                                    self.filter[index].isSelected.toggle()
                                    self.filterTipps(filterName: self.filter[index].name)
                            }
                        }
                    }
                }
                .padding(.vertical, 10)
            }.accentColor(Color("black"))
            
            VStack {
                if !self.unfilteredTipps.isEmpty {
                    ScrollView (.horizontal, showsIndicators: false) {
                        HStack (spacing: -5){
                            ForEach(filteredTipps.indices, id: \.self) { index in
                                GeometryReader { geometry in
                                    TippCard(isChecked: self.$filteredTipps[index].isChecked, isBookmarked: self.$filteredTipps[index].isBookmarked, tipp: self.filteredTipps[index])
                                        .padding(10)
                                        .rotation3DEffect(Angle(degrees: (Double(geometry.frame(in: .global).minX) - 20 ) / -20), axis: (x: 0, y: 10.0, z:0))
                                        .shadow(color: Color(.black).opacity(0.1), radius: 5, x: 4, y: 3)
                                }
                                    .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height/2.1 + 20)
                            }
                        }
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                    }
                        .animation(.spring())
                }
                else {
                    NoConnectionCard()
                }
            }
        }.onAppear{
            Api().fetchTipps { (unfilteredTipps) in
                self.unfilteredTipps = unfilteredTipps
                self.filteredTipps = self.unfilteredTipps
            }
        }
    }
    
    func filterTipps(filterName: String){
        self.filteredTipps = []
        self.filteredTipps = unfilteredTipps
        if (filterName == "Ernährung" || filterName == "Transport" || filterName == "Recycling" || filterName == "Ressourcen") {
            if (!filterCategory.contains(filterName)){
                filterCategory.append(filterName)
            } else {
                filterCategory.removeAll(where: {$0 == filterName})
            }
        }
        if (filterName == "Einfach" || filterName == "Mittel" || filterName == "Schwer") {
            if (!filterLevel.contains(filterName)){
                filterLevel.append(filterName)
            } else {
                filterLevel.removeAll(where: {$0 == filterName})
            }
        }
        
        if (filterCategory.count > 0) {
            print("remove Category")
            for name in filterCategory {
                filteredTipps.removeAll {
                    $0.category == name
                }
            }
        }
        if (filterLevel.count > 0) {
            print("remove Level")
            for name in filterLevel {
                filteredTipps.removeAll {
                    $0.level == name
                }
            }
        }
        print(filterCategory)
        print(filterLevel)
    }
}

struct FilterView: View {
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
        .shadow(color: isSelected ? Color(.black).opacity(0.1) : Color("transparent"), radius: 4, x: 4, y: 2)
    }
}

struct Filter: Codable, Identifiable, Hashable {
    var id: UUID
    var icon: String
    var name: String
    var isSelected: Bool
}

var filterData = [
    Filter(id: UUID(), icon: "blackFruits", name: "Ernährung", isSelected: true),
    Filter(id: UUID(), icon: "blackTransport", name: "Transport", isSelected: true),
    Filter(id: UUID(), icon: "blackRecycle", name: "Recycling", isSelected: true),
    Filter(id: UUID(), icon: "blackRessourcen", name: "Ressourcen", isSelected: true),
    Filter(id: UUID(), icon: "blackStar", name: "Einfach", isSelected: true),
    Filter(id: UUID(), icon: "blackHalfStar", name: "Mittel", isSelected: true),
    Filter(id: UUID(), icon: "blackStarFilled", name: "Schwer", isSelected: true),
    Filter(id: UUID(), icon: "blackVerified", name: "Offiziell", isSelected: true),
    Filter(id: UUID(), icon: "blackCommunity", name: "Community", isSelected: true)
]

struct TippCardList_Previews: PreviewProvider {
    static var previews: some View {
        TippCardList()
    }
}

struct NoConnectionCard: View {
    var body: some View {
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
