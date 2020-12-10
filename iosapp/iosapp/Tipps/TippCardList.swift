//
//  TippCardList.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 09.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct TippCardList: View {
    
    @EnvironmentObject var changeFilter: ChangeFilter
    @EnvironmentObject var filterString: FilterString
    @EnvironmentObject var myUrl: ApiUrl
    
    @State var id = UserDefaults.standard.string(forKey: "id")
    
    @State var loading: Bool = false
    @State var listOpacity: Bool = false
    @ObservedObject var filter: FilterData2
    
    @State var filterCategory2: [String] = ["Ernährung", "Transport", "Haushalt", "Ressourcen"]
    @State var filterLevel2: [String] = ["Leicht", "Mittel", "Schwer"]
    @State var filterPoster: [String] = ["Offiziell", "Community"]
    
    @State var user: User = User(_id: "", phoneId: "", level: 0, checkedTipps: [], savedTipps: [], savedFacts: [], log: [])
    
    var screen = UIScreen.main.bounds.width
    
    var body: some View {
        VStack (spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack (spacing: 20) {
                    Text("Filter:")
                        .font(.system(size: screen < 500 ? screen * 0.050 : 20, weight: .medium))
                        .padding(.leading, 20)
                    if (!changeFilter.changeFilter){
                        ForEach(filter.filter.indices, id: \.self) { index in
                            HStack {
                                FilterView(
                                    isSelected: self.$filter.filter[index].isSelected,
                                    filter: self.filter.filter[index])
                                    .onTapGesture {
                                        self.filterTipps(index: index)
                                        impact(style: .heavy)
                                        
                                        self.loading = true
                                        self.listOpacity = true
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                            self.listOpacity = false
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                self.loading = false
                                            }
                                        }
                                    }
                                    .onAppear(){
                                        if (!self.filterString.filterString.contains(self.filter.filter[index].name)) {
                                            self.filter.filter[index].isSelected = false
                                        }
                                    }
                            }
                        }
                    }
                }
                .padding(.vertical, UIScreen.main.bounds.height / 81)
                .padding(.trailing, 20)
            }.accentColor(Color("black"))
            
            ZStack {
                if (loading) {
                    LottieView(filename: "loadingCircle", loop: true)
                        .shadow(color: Color(.white), radius: 1, x: 0, y: 0)
                        .frame(width: 100, height: 100)
                        .frame(height: UIScreen.main.bounds.height/2.1 + 20)
                }
                if !(!filterString.filterString.contains(where: filterCategory2.contains) || !filterString.filterString.contains(where: filterLevel2.contains) || !filterString.filterString.contains(where: filterPoster.contains)) && !listOpacity {
                    TippUICollectionViewWrapper {}
                        .environmentObject(FilterString())
                        .environmentObject(ApiUrl())
                        .animation(.spring())
                        .opacity(loading ? 0 : 1)
                } else {
                    SelectMoreFilter(filterString: filterString.filterString, categories: filterCategory2, levels: filterLevel2, posters: filterPoster)
                        .opacity(loading ? 0 : 1)
                }
            }.frame(height: UIScreen.main.bounds.height/2.1 + 20)
            .offset(y: -3)
        }
    }
    
    func filterTipps(index: Int){
        if (filterString.filterString.contains(filter.filter[index].name)){
            filterString.filterString.removeAll(where: {$0 == filter.filter[index].name})
            self.filter.filter[index].isSelected = false
        } else {
            filterString.filterString.append(filter.filter[index].name)
            self.filter.filter[index].isSelected = true
        }
    }
}

struct SelectMoreFilter: View {
    
    var filterString: [String]
    var categories: [String]
    var levels: [String]?
    var posters: [String]
    
    var body: some View {
        VStack {
            if (!filterString.contains(where: categories.contains) || !filterString.contains(where: levels?.contains ??  "false".contains) || !filterString.contains(where: posters.contains)){
                Text("Filter:")
            }
            if (!filterString.contains(where: categories.contains)){
                VStack (spacing: 5){
                    Text("Wähle mindestens eine Kategorie aus")
                    Text("(Ernährung, Transport, Haushalt oder Ressourcen)")
                }
                .font(.system(size: 12))
                .padding()
            }
            if (!filterString.contains(where: levels?.contains ?? "false".contains)){
                VStack (spacing: 5){
                    Text("Wähle mindestens einen Schwierigkeitsgrad aus")
                    Text("(Leicht, Mittel oder Schwer)")
                }
                .font(.system(size: 12))
                .padding()
            }
            if (!filterString.contains(where: posters.contains)){
                VStack (spacing: 5){
                    Text("Wähle mindestens eine Art der Poster aus.")
                    Text("(Offiziell oder Community)")
                }
                .font(.system(size: 12))
                .padding()
            }
        }
    }
}

struct FilterView: View {
    @Binding var isSelected: Bool
    var filter: Filter
    var screen = UIScreen.main.bounds.width
    
    var body: some View {
        HStack {
            HStack {
                Image("\(filter.icon)")
                    .resizable()
                    .scaledToFit()
                    .font(.title)
                    .frame(width: screen < 400 ? screen * 0.05 : 25, height: screen < 400 ? screen * 0.05 : 25)
                    .opacity(isSelected ? 1 : 0.3)
                    .padding(5)
                Text(filter.name)
                    .font(.system(size: screen < 500 ? screen * 0.045 : 20))
                    .fontWeight(.medium)
                    .accentColor(Color("black"))
                    .fixedSize(horizontal: true, vertical: false)
                    .opacity(isSelected ? 1 : 0.3)
            }.padding(.horizontal, 10)
            .padding(.vertical, 6)
        }
        .background(Color(isSelected ? "buttonWhite" : "transparent"))
        .cornerRadius(15)
        .shadow(color: isSelected ?Color("black").opacity(0.1) : Color("transparent"), radius: 3, x: 2, y: 2)
    }
}

class Filter: Identifiable, ObservableObject {
    var id: UUID
    var icon: String
    var name: String
    @Published var isSelected: Bool
    
    init(id: UUID, icon: String, name: String, isSelected: Bool) {
        self.id = id
        self.icon = icon
        self.name = name
        self.isSelected = isSelected
    }
}

class FilterData2: ObservableObject {
    @Published var filter = [Filter]()
    private var cancellables = Set<AnyCancellable>()
    
    func addItem(_ item: Filter) {
        filter.append(item)
        // this subscribes us to listen for objectWillChange messages from each
        // of the items in the array, and we emit our own objectWillChange message
        item.objectWillChange
            .sink(receiveValue: { self.objectWillChange.send() })
            .store(in: &cancellables)
    }
}

var filterData = [
    Filter(id: UUID(), icon: "blackFruits", name: "Ernährung", isSelected: true),
    Filter(id: UUID(), icon: "blackTransport", name: "Transport", isSelected: true),
    Filter(id: UUID(), icon: "Haushalt", name: "Haushalt", isSelected: true),
    Filter(id: UUID(), icon: "blackRessourcen", name: "Ressourcen", isSelected: true),
    Filter(id: UUID(), icon: "blackStar", name: "Leicht", isSelected: true),
    Filter(id: UUID(), icon: "blackHalfStar", name: "Mittel", isSelected: true),
    Filter(id: UUID(), icon: "blackStarFilled", name: "Schwer", isSelected: true),
    Filter(id: UUID(), icon: "blackVerified", name: "Offiziell", isSelected: true),
    Filter(id: UUID(), icon: "blackCommunity", name: "Community", isSelected: true)
]

struct TippCardList_Previews: PreviewProvider {
    static var previews: some View {
        TippCardList(filter: FilterData2()).environmentObject(ChangeFilter()).environmentObject(UserObserv()).environmentObject(FilterString())
    }
}

struct CustomCard: View {
    
    var image: String
    var text: String
    var color: String
    
    var body: some View {
        ZStack {
            VStack{
                Spacer()
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(minHeight: 100, idealHeight: 200, maxHeight: 300)
                    .padding(20)
                Text(text)
                    .font(.system(size: UIScreen.main.bounds.width < 500 ? UIScreen.main.bounds.width * 0.045 : 22))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding()
                Spacer()
            }
            .background(Color(color))
            .cornerRadius(15)
            .shadow(color: Color(.black).opacity(0.1), radius: 10, x: 8, y: 6)
        }.frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height/2.1)
        .padding(.vertical, 10)
    }
}


//struct ExtractedCardList: View {
//    @EnvironmentObject var myUrl: ApiUrl
//    @State var id = UserDefaults.standard.string(forKey: "id")
//    @State var filteredTipps: [Tipp]
//    var cardColors: [String]
//    @State var user: User
//    @EnvironmentObject var filterString: FilterString
//    var loading: Bool
//
//    var body: some View {
//            HStack (spacing: 0) {
//                ForEach(self.filteredTipps.indices, id: \.self) { index in
//                    HStack {
//                        GeometryReader { geometry in
//                            HStack {
//                                Spacer()
//                                TippCard2(
//                                    user: user,
//                                    isChecked: self.$filteredTipps[index].isChecked,
//                                    isBookmarked: self.$filteredTipps[index].isBookmarked,
//                                    tipp: self.filteredTipps[index],
//                                    color: cardColors[index % 9])
//                                    .environmentObject(ApiUrl())
//                                    .rotation3DEffect(Angle(degrees: (Double(geometry.frame(in: .global).minX < UIScreen.main.bounds.width*2 && geometry.frame(in: .global).minX > -UIScreen.main.bounds.width*2  ? (geometry.frame(in: .global).minX - 5 ) / -10 : 0))), axis: (x: 0, y: 10.0, z:0))
//                                    .shadow(color: Color("black").opacity(0.05), radius: 5, x: 4, y: 4)
//                                    .opacity(Double(geometry.frame(in: .global).minX < UIScreen.main.bounds.width && geometry.frame(in: .global).minX > -UIScreen.main.bounds.width ? 1 : 0))
//                                    .padding(.vertical, 10)
//                                    .environmentObject(ApiUrl())
//                                    .environmentObject(UserLevel())
//                                Spacer()
//                            }
//                        }
//                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2.1 + 20)
//                    }
//                }
//            }
//            .frame(height: UIScreen.main.bounds.height/2.1 + 20)
//            .background(Color("background"))
//            .animation(.spring())
//        }
//        .frame(height: UIScreen.main.bounds.height/2.1 + 20)
//        .offset(x: loading ? 300 : 0)
//        .animation(.spring())
//    }
//}
