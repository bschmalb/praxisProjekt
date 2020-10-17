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
    
    @Environment(\.horizontalSizeClass) var horizontalSize
    
    @EnvironmentObject var myUrl: ApiUrl
    @State var id = UserDefaults.standard.string(forKey: "id")
    
    @State var filteredFacts: [Fact] = []
    @State var offlineFacts: [Fact] = []
    
    @State var loading: Bool = false
    @State var dataLoading: Bool = true
    @ObservedObject var filter: FilterDataFacts
    
    @State var redrawUIScrollView = true
    
    @State var showOfflineTipps = true
    
    @State var filterCategory2: [String] = ["Ernährung", "Transport", "Haushalt", "Ressourcen"]
    @State var filterLevel2: [String] = ["Leicht", "Mittel", "Schwer"]
    @State var filterPoster: [String] = ["Offiziell", "Community"]
    
    @State var notCategory: [String] = UserDefaults.standard.stringArray(forKey: "notCategory") ?? []
    @State var notDifficulty: [String] = UserDefaults.standard.stringArray(forKey: "notDifficulty") ?? []
    
    @EnvironmentObject var user: UserObserv
    
    @State var userObject: User = User(_id: "", phoneId: "", level: 0, checkedTipps: [], savedTipps: [], savedFacts: [], log: [])
    
    @EnvironmentObject var changeFilter: ChangeFilter
    @EnvironmentObject var filterString: FilterString
    
    @State var showFacts: Bool = false
    
    var screen = UIScreen.main.bounds.width
    
    var cardColors: [String]  = [
        "cardgreen2", "cardblue2", "cardyellow2", "cardpurple2", "cardorange2", "cardred2", "cardturqouise2", "cardyelgre2", "cardpink2"
    ]
    
    var body: some View {
        VStack (spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack (spacing: 20) {
                    Text("Filter:")
                        .font(.system(size: screen < 500 ? screen * 0.050 : 20, weight: .medium))
                        .padding(.leading, 20)
                    ForEach(filter.filter.indices, id: \.self) { index in
                        HStack {
                            FilterView(isSelected: self.$filter.filter[index].isSelected, filter: self.filter.filter[index])
                                .onTapGesture {
                                    self.redrawUIScrollView = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        self.redrawUIScrollView = true
                                    }
                                    
                                    self.filterTipps2(index: index)
                                    
                                    impact(style: .heavy)
                                    self.loading = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        self.loading = false
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
                .padding(.vertical, UIScreen.main.bounds.height / 81)
                .padding(.trailing, 20)
            }.accentColor(Color("black"))
            
            ZStack {
                //                Text("Wähle mehr Kategorien aus")
                //                    .padding()
                VStack {
                    if (dataLoading || changeFilter.changeFilter) {
                        VStack {
                            LottieView(filename: "loadingCircle", loop: true)
                                .shadow(color: Color(.white), radius: 1, x: 0, y: 0)
                                .frame(width: 100, height: 100)
                        }
//                        .onAppear(){
//                            if changeFilter.changeFilter {
//                                FactApi().fetchApproved { (filteredFacts) in
//                                    self.filteredFacts = filteredFacts
//
//                                    if (self.filteredFacts.count > 0) {
//                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
//                                            self.changeFilter.changeFilter = false
//                                        }
//                                    }
//                                }
//                            }
//                        }
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2.1 + 20)
                    }
                    else {
                        if #available(iOS 14.0, *) {
                            if (self.filteredFacts.count > 0) {
                                if (showOfflineTipps) {
                                    ExtractedFactList(loading: loading, filteredFacts: filteredFacts, cardColors: cardColors, filterString: filterString)
                                        .environmentObject(ApiUrl())
                                } else {
                                    ExtractedFactList(loading: loading, filteredFacts: filteredFacts, cardColors: cardColors, filterString: filterString)
                                        .environmentObject(ApiUrl())
                                }
                            }
                            else {
                                CustomCard(image: "ServerError", text: "Stelle sicher, dass du mit dem Internet verbunden bist", color: "buttonWhite")
                                    .padding(.horizontal, 15)
                                    .padding(.bottom, 5)
                            }
                        } else {
                            if (self.filteredFacts.count > 0) {
                                if (redrawUIScrollView){
                                    if (showOfflineTipps) {
                                        ExtractedFactList(loading: loading, filteredFacts: filteredFacts, cardColors: cardColors, filterString: filterString)
                                            .environmentObject(ApiUrl())
                                    } else {
                                        ExtractedFactList(loading: loading, filteredFacts: filteredFacts, cardColors: cardColors, filterString: filterString)
                                            .environmentObject(ApiUrl())
                                    }
                                } else {
                                    VStack {
                                        LottieView(filename: "loadingCircle", loop: true)
                                            .shadow(color: Color(.white), radius: 1, x: 0, y: 0)
                                            .frame(width: 100, height: 100)
                                    }
                                    .frame(height: UIScreen.main.bounds.height / 2.1 + 20)
                                }
                            }
                            else {
                                CustomCard(image: "ServerError", text: "Stelle sicher, dass du mit dem Internet verbunden bist", color: "buttonWhite")
                                    .padding(.horizontal, 15)
                                    .padding(.bottom, 5)
                            }
                        }
                    }
                }
                .animation(.spring())
                if (loading) {
                    LottieView(filename: "loadingCircle", loop: true)
                        .shadow(color: Color(.white), radius: 1, x: 0, y: 0)
                        .frame(width: 100, height: 100)
                }
            }
            .offset(y: -3)
        }
        .onAppear(){
            
            getUser()
            
            do {
                let storedObjTipp = UserDefaults.standard.object(forKey: "offlineFacts")
                if storedObjTipp != nil {
                    self.filteredFacts = try JSONDecoder().decode([Fact].self, from: storedObjTipp as! Data)
                    self.dataLoading = false
                    print("Retrieved Facts: filteredFacts")
                }
            } catch let err {
                print(err)
            }
            
            FactApi().fetchApproved { (filteredFacts) in
                self.filteredFacts = []
                self.filteredFacts = filteredFacts
                self.dataLoading = false
                self.showOfflineTipps = false
                
                for (i, _) in filteredFacts.enumerated() {
                    if i < 10 && filteredFacts.count > i {
                        offlineFacts.append(filteredFacts[i])
                    }
                    else {
                        break
                    }
                }
                
                if let encoded = try? JSONEncoder().encode(offlineFacts) {
                    UserDefaults.standard.set(encoded, forKey: "offlineFacts")
                    print("Facts saved")
                }
            }
        }
    }
    
    func getUser() {
        guard let url = URL(string: myUrl.users + (id ?? "")) else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            if let decodedResponse = try? JSONDecoder().decode(User.self, from: data) {
                userObject = decodedResponse
            }
        }.resume()
    }
    
    func filterTipps2(index: Int){
        if (filterString.filterString.contains(filter.filter[index].name)){
            filterString.filterString.removeAll(where: {$0 == filter.filter[index].name})
            self.filter.filter[index].isSelected = false
        } else {
            filterString.filterString.append(filter.filter[index].name)
            self.filter.filter[index].isSelected = true
        }
        changeFilter.changeFilterProfile = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            changeFilter.changeFilterProfile = false
        }
        print(filterString.filterString)
    }
}

struct ExtractedFactList: View {
    
    @EnvironmentObject var myUrl: ApiUrl
    @State var id = UserDefaults.standard.string(forKey: "id")
    
    var loading: Bool
    @State var filteredFacts: [Fact]
    var cardColors: [String]
    var filterString: FilterString
    @State var user: User = User(_id: "", phoneId: "", checkedTipps: [], savedTipps: [], savedFacts: [], log: [])
    @State var userLoaded = true
    
    var body: some View {
        GeometryReader { proxy in
            if (userLoaded) {
                UIScrollViewWrapper {
                    HStack (spacing: 0) {
                        ForEach(self.filteredFacts.indices, id: \.self) { index in
                            HStack {
                                if ([self.filteredFacts[index].category, self.filteredFacts[index].official].allSatisfy(self.filterString.filterString.contains)){
                                    GeometryReader { geometry in
                                        HStack {
                                            Spacer()
                                            FactCard(
                                                isBookmarked: self.$filteredFacts[index].isBookmarked,
                                                fact: self.filteredFacts[index],
                                                color: cardColors[index % 9],
                                                user: user
                                            )
                                            .rotation3DEffect(Angle(degrees: (Double(geometry.frame(in: .global).minX < UIScreen.main.bounds.width*2 && geometry.frame(in: .global).minX > -UIScreen.main.bounds.width*2  ? (geometry.frame(in: .global).minX - 5 ) / -10 : 0))), axis: (x: 0, y: 10.0, z:0))
                                            .shadow(color: Color("black").opacity(0.05), radius: 5, x: 4, y: 4)
                                            .opacity(Double(geometry.frame(in: .global).minX < UIScreen.main.bounds.width && geometry.frame(in: .global).minX > -UIScreen.main.bounds.width ? 1 : 0))
                                            .padding(.vertical, 10)
                                            .environmentObject(ApiUrl())
                                            Spacer()
                                        }
                                    }
                                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2.1 + 20)
                                }
                            }
                        }
                    }
                    .frame(height: UIScreen.main.bounds.height/2.1 + 20)
                    .background(Color("background"))
                    .animation(.spring())
                }
            }
        }
        .frame(height: UIScreen.main.bounds.height/2.1 + 20)
        .offset(x: loading ? 300 : 0)
        .animation(.spring())
        .onAppear(){
            getUser()
        }
    }
    
    func getUser() {
        guard let url = URL(string: myUrl.users + (id ?? "")) else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            if let decodedResponse = try? JSONDecoder().decode(User.self, from: data) {
                userLoaded = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    userLoaded = true
                })
                user = decodedResponse
            }
        }.resume()
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
