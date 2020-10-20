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
    
    @EnvironmentObject var myUrl: ApiUrl
    @EnvironmentObject var redraw: RedrawScrollView
    @State var id = UserDefaults.standard.string(forKey: "id")
    
    @Environment(\.horizontalSizeClass) var horizontalSize
    
    @State var filteredTipps: [Tipp] = []
    @State var offlineTipps: [Tipp] = []
    
    @State var showOfflineTipps = true
    @State var showOnlineTipps = false
    
    @State var loading: Bool = false
    @State var dataLoading: Bool = true
    @ObservedObject var filter: FilterData2
    
    @State var filterCategory2: [String] = ["Ernährung", "Transport", "Haushalt", "Ressourcen"]
    @State var filterLevel2: [String] = ["Leicht", "Mittel", "Schwer"]
    @State var filterPoster: [String] = ["Offiziell", "Community"]
    
    @State var notCategory: [String] = UserDefaults.standard.stringArray(forKey: "notCategory") ?? []
    @State var notDifficulty: [String] = UserDefaults.standard.stringArray(forKey: "notDifficulty") ?? []
    
    @EnvironmentObject var user: UserObserv
    
    @State var userObject: User = User(_id: "", phoneId: "", level: 0, checkedTipps: [], savedTipps: [], savedFacts: [], log: [])
    
    @EnvironmentObject var changeFilter: ChangeFilter
    @EnvironmentObject var filterString: FilterString
    
    @State var showTipps: Bool = false
    
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
                    if (!changeFilter.changeFilter){
                        ForEach(filter.filter.indices, id: \.self) { index in
                            HStack {
                                FilterView(
                                    isSelected: self.$filter.filter[index].isSelected,
                                    filter: self.filter.filter[index])
                                    .onTapGesture {
                                        self.filterTipps2(index: index)
                                        impact(style: .heavy)
                                        
                                        self.loading = true
                                        self.redraw.redraw = false
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            self.redraw.redraw = true
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
                }
                .padding(.vertical, UIScreen.main.bounds.height / 81)
                .padding(.trailing, 20)
            }.accentColor(Color("black"))
            
            ZStack {
                VStack {
                    if (dataLoading || changeFilter.changeFilter) {
                        VStack {
                            LottieView(filename: "loadingCircle", loop: true)
                                .shadow(color: Color(.white), radius: 1, x: 0, y: 0)
                                .frame(width: 100, height: 100)
                        }.frame(height: UIScreen.main.bounds.height/2.1 + 20)
                        .onAppear(){
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
                            
                            Api().fetchTipps { (filteredTipps) in
                                self.filteredTipps = filteredTipps
                                self.dataLoading = false
                                
                                for (index, test) in self.filteredTipps.enumerated() {
                                    if (userObject.checkedTipps.contains(test._id)){
                                        self.filteredTipps[index].isChecked = true
                                    }
                                    if (userObject.savedTipps.contains(test._id)){
                                        self.filteredTipps[index].isBookmarked = true
                                    }
                                }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2.1 + 20)
                    }
                    else {
                        if #available(iOS 14.0, *) {
                            if (self.filteredTipps.count > 0) {
                                ZStack {
                                    if showOnlineTipps {
                                        ExtractedCardList(loading: loading, filteredTipps: filteredTipps, cardColors: cardColors)
                                            .environmentObject(ApiUrl())
                                            .opacity(showOfflineTipps ? 0 : 1)
                                    }
                                    if showOfflineTipps {
                                        ExtractedCardList(loading: loading, filteredTipps: filteredTipps, cardColors: cardColors)
                                            .environmentObject(ApiUrl())
                                    }
                                }
                            }
                            else {
                                CustomCard(image: "ServerError", text: "Stelle sicher, dass du mit dem Internet verbunden bist", color: "buttonWhite")
                                    .padding(.horizontal, 15)
                                    .padding(.bottom, 5)
                            }
                        } else {
                            if (self.filteredTipps.count > 0) {
                                if (redraw.redraw){
                                    ZStack {
                                        if showOnlineTipps {
                                            ExtractedCardList(loading: loading, filteredTipps: filteredTipps, cardColors: cardColors)
                                                .environmentObject(ApiUrl())
                                                .opacity(showOfflineTipps ? 0 : 1)
                                        }
                                        if showOfflineTipps {
                                            ExtractedCardList(loading: loading, filteredTipps: filteredTipps, cardColors: cardColors)
                                                .environmentObject(ApiUrl())
                                        }
                                    }
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
                        .frame(height: UIScreen.main.bounds.height/2.1 + 20)
                }
                if (!filterString.filterString.contains(where: filterCategory2.contains) || !filterString.filterString.contains(where: filterLevel2.contains) || !filterString.filterString.contains(where: filterPoster.contains)){
                    SelectMoreFilter(filterString: filterString.filterString, categories: filterCategory2, levels: filterLevel2, posters: filterPoster)
                        .opacity(loading ? 0 : 1)
                }
            }.frame(height: UIScreen.main.bounds.height/2.1 + 20)
            .offset(y: -3)
        }
        .onAppear(){
            
            do {
                let storedObjTipp = UserDefaults.standard.object(forKey: "offlineTipps")
                if storedObjTipp != nil {
                    self.filteredTipps = try JSONDecoder().decode([Tipp].self, from: storedObjTipp as! Data)
                    self.dataLoading = false
                    print("Retrieved Tipps: filteredTipps")
                }
            } catch let err {
                print(err)
            }
            
            Api().fetchTipps { (filteredTipps) in
                self.filteredTipps = []
                self.filteredTipps = filteredTipps
                self.dataLoading = false
                self.showOnlineTipps = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.showOfflineTipps = false
                }
                
                for (i, _) in filteredTipps.enumerated() {
                    if (i < 10 && (filteredTipps.count > i)) {
                        offlineTipps.append(filteredTipps[i])
                    }
                    else {
                        break
                    }
                }
                
                if let encoded = try? JSONEncoder().encode(offlineTipps) {
                    UserDefaults.standard.set(encoded, forKey: "offlineTipps")
                    print("Tipps saved")
                }
            }
        }
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
struct SelectMoreFilter: View {
    
    var filterString: [String]
    var categories: [String]
    var levels: [String]
    var posters: [String]
    
    var body: some View {
        VStack {
            if (!filterString.contains(where: categories.contains) || !filterString.contains(where: levels.contains) || !filterString.contains(where: posters.contains)){
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
            if (!filterString.contains(where: levels.contains)){
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

struct ExtractedCardList: View {
    
    @EnvironmentObject var myUrl: ApiUrl
    @EnvironmentObject var filterString: FilterString
    
    @State var id = UserDefaults.standard.string(forKey: "id")
    
    var loading: Bool
    @State var filteredTipps: [Tipp]
    var cardColors: [String]
    @State var user: User = User(_id: "", phoneId: "", checkedTipps: [], savedTipps: [], savedFacts: [], log: [])
    @State var userLoaded = true
    
    @State var load = 0
    @State var loadMax = 30
    
    @State var filterCategory2: [String] = ["Ernährung", "Transport", "Haushalt", "Ressourcen"]
    @State var filterLevel2: [String] = ["Leicht", "Mittel", "Schwer"]
    @State var filterPoster: [String] = ["Offiziell", "Community"]
    
    
    var body: some View {
        GeometryReader { proxy in
//            if (userLoaded) {
                UIScrollViewWrapper {
                    HStack (spacing: 0) {
                        ForEach(self.filteredTipps.indices, id: \.self) { index in
                            HStack {
                                if ([self.filteredTipps[index].category, self.filteredTipps[index].level, self.filteredTipps[index].official].allSatisfy(self.filterString.filterString.contains)){
                                    GeometryReader { geometry in
                                        HStack {
                                            Spacer()
                                            TippCard2(
                                                user: user,
                                                isChecked: self.$filteredTipps[index].isChecked,
                                                isBookmarked: self.$filteredTipps[index].isBookmarked,
                                                tipp: self.filteredTipps[index],
                                                color: cardColors[index % 9])
                                                .environmentObject(ApiUrl())
                                                .rotation3DEffect(Angle(degrees: (Double(geometry.frame(in: .global).minX < UIScreen.main.bounds.width*2 && geometry.frame(in: .global).minX > -UIScreen.main.bounds.width*2  ? (geometry.frame(in: .global).minX - 5 ) / -10 : 0))), axis: (x: 0, y: 10.0, z:0))
                                                .shadow(color: Color("black").opacity(0.05), radius: 5, x: 4, y: 4)
                                                .opacity(Double(geometry.frame(in: .global).minX < UIScreen.main.bounds.width && geometry.frame(in: .global).minX > -UIScreen.main.bounds.width ? 1 : 0))
                                                .padding(.vertical, 10)
                                                .environmentObject(ApiUrl())
                                                .environmentObject(UserLevel())
                                            Spacer()
                                        }
                                    }
                                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2.1 + 20)
                                }
//                                if index == loadMax {
//                                    if (filterString.filterString.contains(where: filterCategory2.contains) && filterString.filterString.contains(where: filterLevel2.contains) && filterString.filterString.contains(where: filterPoster.contains)){
//                                        VStack {
//                                            Image(systemName: "arrow.counterclockwise")
//                                                .font(.system(size: 24))
//                                            Text("Mehr Tipps anzeigen")
//                                                .onTapGesture(){
//                                                    self.loadMax += 10
//                                                }
//                                        }
//                                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2.1 + 20)
//                                    }
//                                }
                            }
                        }
                    }
                    .frame(height: UIScreen.main.bounds.height/2.1 + 20)
                    .background(Color("background"))
                    .animation(.spring())
                }
                .onAppear(){
                    print(filterString.filterString)
//                }
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

class UIScrollViewViewController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate {
    
    lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.isPagingEnabled = true
        v.showsHorizontalScrollIndicator = false
        return v
    }()
    
    var hostingController: UIHostingController<AnyView> = UIHostingController(rootView: AnyView(EmptyView()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.scrollView)
        self.pinEdges(of: self.scrollView, to: self.view)
        
        scrollView.delegate = self
        
        self.hostingController.willMove(toParent: self)
        self.scrollView.addSubview(self.hostingController.view)
        self.pinEdges(of: self.hostingController.view, to: self.scrollView)
        self.hostingController.didMove(toParent: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.addSubview(self.scrollView)
        self.pinEdges(of: self.scrollView, to: self.view)
        
        scrollView.delegate = self
        
        self.hostingController.willMove(toParent: self)
        self.scrollView.addSubview(self.hostingController.view)
        self.pinEdges(of: self.hostingController.view, to: self.scrollView)
        self.hostingController.didMove(toParent: self)
    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
//        let counter = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width)
//        scrollView.viewWithTag(counter)?.removeFromSuperview()
//    }
    
    func pinEdges(of viewA: UIView, to viewB: UIView) {
        viewA.translatesAutoresizingMaskIntoConstraints = false
        viewB.addConstraints([
            viewA.leadingAnchor.constraint(equalTo: viewB.leadingAnchor),
            viewA.trailingAnchor.constraint(equalTo: viewB.trailingAnchor),
            viewA.topAnchor.constraint(equalTo: viewB.topAnchor),
            viewA.bottomAnchor.constraint(equalTo: viewB.bottomAnchor),
        ])
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
    
}

struct UIScrollViewWrapper<Content: View>: UIViewControllerRepresentable {
    
    var content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    func makeUIViewController(context: Context) -> UIScrollViewViewController {
        let vc = UIScrollViewViewController()
        vc.hostingController.rootView = AnyView(self.content())
        return vc
    }
    
    func updateUIViewController(_ viewController: UIScrollViewViewController, context: Context) {
        viewController.hostingController.rootView = AnyView(self.content())
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
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

//struct FilterView_Previews: PreviewProvider {
//    static var previews: some View {
//        FilterView(isSelected: .constant(true), filter: Filter(id: UUID(), icon: "Ernährung", name: "Ernährung", isSelected: true))
//    }
//}

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

//class FilterData2: ObservableObject {
//    @Published var filter: [Filter]
//
//    init(){
//        self.filter = [
//            Filter(id: UUID(), icon: "blackFruits", name: "Ernährung", isSelected: true),
//            Filter(id: UUID(), icon: "blackTransport", name: "Transport", isSelected: true),
//            Filter(id: UUID(), icon: "blackRecycle", name: "Recycling", isSelected: true),
//            Filter(id: UUID(), icon: "blackRessourcen", name: "Ressourcen", isSelected: true),
//            Filter(id: UUID(), icon: "blackStar", name: "Leicht", isSelected: true),
//            Filter(id: UUID(), icon: "blackHalfStar", name: "Mittel", isSelected: true),
//            Filter(id: UUID(), icon: "blackStarFilled", name: "Schwer", isSelected: true),
//            Filter(id: UUID(), icon: "blackVerified", name: "Offiziell", isSelected: true),
//            Filter(id: UUID(), icon: "blackCommunity", name: "Community", isSelected: true)
//        ]
//    }
//
//}


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
