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

struct FactCardList: View {
    
    @EnvironmentObject var changeFilter: ChangeFilter
    @EnvironmentObject var filterStringFacts: FilterStringFacts
    @EnvironmentObject var myUrl: ApiUrl
    
    @State var id = UserDefaults.standard.string(forKey: "id")
    
    @State var loading: Bool = false
    @State var listOpacity: Bool = false
    @ObservedObject var filter: FilterDataFacts
    
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
                                    if (!self.filterStringFacts.filterString.contains(self.filter.filter[index].name)) {
                                        self.filter.filter[index].isSelected = false
                                    }
                                }
                        }
                    }
                }
                .padding(.vertical, UIScreen.main.bounds.height / 81)
                .padding(.trailing, 20)
            }.accentColor(Color("black"))
            
            ZStack {
                if !listOpacity {
                    FactUICollectionViewWrapper {}
                        .environmentObject(FilterStringFacts())
                        .environmentObject(ApiUrl())
                        .animation(.spring())
                        .opacity(loading ? 0 : 1)
                }
                if (loading) {
                    LottieView(filename: "loadingCircle", loop: true)
                        .shadow(color: Color(.white), radius: 1, x: 0, y: 0)
                        .frame(width: 100, height: 100)
                        .frame(height: UIScreen.main.bounds.height/2.1 + 20)
                }
                if (!filterStringFacts.filterString.contains(where: filterCategory2.contains) || !filterStringFacts.filterString.contains(where: filterPoster.contains)){
                    SelectMoreFilter(filterString: filterStringFacts.filterString, categories: filterCategory2, posters: filterPoster)
                        .opacity(loading ? 0 : 1)
                }
            }.frame(height: UIScreen.main.bounds.height/2.1 + 20)
            .offset(y: -3)
        }
    }
    
    func filterTipps(index: Int){
        if (filterStringFacts.filterString.contains(filter.filter[index].name)){
            filterStringFacts.filterString.removeAll(where: {$0 == filter.filter[index].name})
            self.filter.filter[index].isSelected = false
        } else {
            filterStringFacts.filterString.append(filter.filter[index].name)
            self.filter.filter[index].isSelected = true
        }
    }
}

class FilterDataFacts: ObservableObject {
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


struct FactCardList_Previews: PreviewProvider {
    static var previews: some View {
        FactCardList(filter: FilterDataFacts()).environmentObject(ChangeFilter()).environmentObject(UserObserv()).environmentObject(FilterString())
    }
}
