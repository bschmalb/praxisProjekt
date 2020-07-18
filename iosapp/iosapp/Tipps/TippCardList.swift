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
    
    @State var filteredTipps: [Tipp] = []
    
    @State var filterString: String = ""
    
    @State var filterCategory2: [String] = ["Ernährung", "Transport", "Recycling", "Ressourcen"]
    @State var filterLevel2: [String] = ["Leicht", "Mittel", "Schwer"]
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
                            FilterView(isSelected: self.$filter[index].isSelected, filter: self.filter[index])
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
                if (!self.filteredTipps.isEmpty) {
                    GeometryReader { proxy in
                        UIScrollViewWrapper {
                            HStack {
                                ForEach(self.filteredTipps.indices, id: \.self) { index in
                                    HStack {
                                        if(self.filterCategory2.contains(self.filteredTipps[index].category) && self.filterLevel2.contains(self.filteredTipps[index].level) && self.filterPoster.contains(self.filteredTipps[index].official)) {
                                            GeometryReader { geometry in
                                                TippCard(isChecked: self.$filteredTipps[index].isChecked, isBookmarked: self.$filteredTipps[index].isBookmarked, tipp: self.filteredTipps[index])
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
                    .animation(.spring())
                    
                    //                    ScrollView (.horizontal, showsIndicators: false) {
                    //                        HStack (spacing: -2){
                    //                            ForEach(filteredTipps.indices, id: \.self) { index in
                    //                                VStack {
                    //                                    if(self.filterCategory2.contains(self.filteredTipps[index].category) && self.filterLevel2.contains(self.filteredTipps[index].level)) {
                    //                                        GeometryReader { geometry in
                    //                                            TippCard(isChecked: self.$filteredTipps[index].isChecked, isBookmarked: self.$filteredTipps[index].isBookmarked, tipp: self.filteredTipps[index])
                    //                                                .rotation3DEffect(Angle(degrees: (Double(geometry.frame(in: .global).minX) - 20 ) / -20), axis: (x: 0, y: 10.0, z:0))
                    //                                                .shadow(color: Color("black").opacity(0.05), radius: 5, x: 4, y: 4)
                    //                                        }
                    //                                        .frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height/2.1 + 20)
                    //                                    }
                    //                                }
                    //                                .padding(.leading, 15)
                    //                                .padding(.trailing, 15)
                    //                            }
                    //                        }
                    //                    }
                    //                    .animation(.spring())
                    
//                    ScrollView (.horizontal, showsIndicators: false) {
//                        if #available(iOS 14.0, *) {
//                            ScrollViewReader { value2 in
//                                ZStack {
//                                    HStack (spacing: -2){
//                                        ForEach(filteredTipps.indices, id: \.self) { index in
//                                            VStack {
//                                                if(self.filterCategory2.contains(self.filteredTipps[index].category) && self.filterLevel2.contains(self.filteredTipps[index].level)) {
//                                                    GeometryReader { geometry in
//                                                        TippCard(isChecked: self.$filteredTipps[index].isChecked, isBookmarked: self.$filteredTipps[index].isBookmarked, tipp: self.filteredTipps[index])
//                                                            .rotation3DEffect(Angle(degrees: (Double(geometry.frame(in: .global).minX) - 20 ) / -20), axis: (x: 0, y: 10.0, z:0))
//                                                            .shadow(color: Color("black").opacity(0.05), radius: 5, x: 4, y: 4)
//                                                    }
//                                                    .frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height/2.1 + 20)
//                                                }
//                                            }
//                                            .gesture(DragGesture()
//                                                        .onChanged({ value in
//                                                            print("drag")
//                                                        }))
//                                            .padding(.leading, 15)
//                                            .padding(.trailing, 15)
//                                        }
//                                    }
//                                }
//                            }
//                        } else {
//                            // Fallback on earlier versions
//                        }
//                    }
                    .animation(.spring())
                }
                else {
                    CustomCard(image: "Fix website (man)", text: "Stelle sicher, dass du mit dem Internet verbunden bist", color: "buttonWhite")
                        .padding(.horizontal, 15)
                        .padding(.vertical, 5)
                        .padding(.bottom, 5)
                }
            }
            .offset(y: -UIScreen.main.bounds.height / 81)
            .animation(.spring())
        }.onAppear{
            Api().fetchTipps { (filteredTipps) in
                self.filteredTipps = filteredTipps
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
        
        //        if (filterCategory.count > 0) {
        //            print("remove Category")
        //            for name in filterCategory {
        //                filteredTipps.removeAll {
        //                    $0.category == name
        //                }
        //            }
        //        }
        //        if (filterLevel.count > 0) {
        //            print("remove Level")
        //            for name in filterLevel {
        //                filteredTipps.removeAll {
        //                    $0.level == name
        //                }
        //            }
        //        }
    }
}

class UIScrollViewViewController: UIViewController {
    
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
        
        self.hostingController.willMove(toParent: self)
        self.scrollView.addSubview(self.hostingController.view)
        self.pinEdges(of: self.hostingController.view, to: self.scrollView)
        self.hostingController.didMove(toParent: self)
    }
    
    func pinEdges(of viewA: UIView, to viewB: UIView) {
        viewA.translatesAutoresizingMaskIntoConstraints = false
        viewB.addConstraints([
            viewA.leadingAnchor.constraint(equalTo: viewB.leadingAnchor),
            viewA.trailingAnchor.constraint(equalTo: viewB.trailingAnchor),
            viewA.topAnchor.constraint(equalTo: viewB.topAnchor),
            viewA.bottomAnchor.constraint(equalTo: viewB.bottomAnchor),
        ])
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
        .shadow(color: isSelected ?Color("black").opacity(0.1) : Color("transparent"), radius: 5, x: 4, y: 4)
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
    Filter(id: UUID(), icon: "blackStar", name: "Leicht", isSelected: true),
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
                Text(text)
                    .font(.system(size: 20, weight: Font.Weight.medium))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Spacer()
            }
            .background(Color(color))
            .cornerRadius(15)
            .shadow(color: Color(.black).opacity(0.1), radius: 10, x: 8, y: 6)
        }.frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height/2.1)
        .padding(.vertical, 10)
    }
}
