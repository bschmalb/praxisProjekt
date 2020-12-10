//
//  ProfilTippView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 19.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct ProfilTippView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var myUrl: ApiUrl
    
    @ObservedObject var store = AllTippDataStore()
    @EnvironmentObject var changeFilter: ChangeFilter
    
    let uuid = UIDevice.current.identifierForVendor?.uuidString
    
    @State var id = UserDefaults.standard.string(forKey: "id")
    
    @State var loading = true
    @State var showSliderView = false
    
    @State var allTipps: [Tipp] = []
    @State var ownTipps: [Tipp] = []
    
    @State var userObject: User = User(_id: "", phoneId: "", level: 0, checkedTipps: [], savedTipps: [], log: [])
    
    @State var tabSelected = 0
    
    @State var geoMidChecked: CGFloat = 0
    @State var geoMidSaved: CGFloat = 0
    @State var geoMidOwn: CGFloat = 0
    
    @State var tippOffset: CGFloat = -UIScreen.main.bounds.width
    @State var selectWidth: CGFloat = 90
    @State var slidingText: String = "Abgehakte"
    
    var cardColor: [String]  = [
        "cardgreen2", "cardyellow2", "cardpurple2", "cardorange2", "cardred2", "cardturqouise2", "cardblue2", "cardpink2"
    ]
    
    var screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        ZStack {
            Color("background")
                .edgesIgnoringSafeArea(.all)
            VStack {
                Button(action: {
                    self.mode.wrappedValue.dismiss()
                    impact(style: .medium)
                }) {
                    HStack (spacing: 10){
                        Image(systemName: "arrow.left")
                            .font(.system(size: screenWidth < 500 ? screenWidth * 0.040 : 18, weight: .medium))
                            .foregroundColor(Color("black"))
                        Text("Deine Gewohnheiten")
                            .font(.system(size: screenWidth < 500 ? screenWidth * 0.040 : 18, weight: .medium))
                            .foregroundColor(Color("black"))
                        Spacer()
                    }
                    .padding(.leading, 20)
                    .padding(.top, 10)
                }
                VStack{
                    SliderView(slidingText: $slidingText, selectWidth: $selectWidth, tippOffset: $tippOffset, tabSelected: $tabSelected, geoMidChecked: $geoMidChecked, geoMidSaved: $geoMidSaved, geoMidOwn: $geoMidOwn)
                        .offset(y: -10)
                        .opacity(showSliderView ? 1 : 0)
                        .animation(.spring())
                    if (!loading){
                        ZStack {
                            VStack {
                                if (!self.allTipps.isEmpty) {
                                    ScrollView(.vertical, showsIndicators: false) {
                                        ForEach(self.allTipps.indices, id: \.self) { index in
                                            VStack (spacing: 0) {
                                                if(self.allTipps[index].isChecked) {
                                                    SmallTippCard(
                                                        isChecked: self.$allTipps[index].isChecked,
                                                        isBookmarked: self.$allTipps[index].isBookmarked,
                                                        tipp: self.allTipps[index],
                                                        color: self.cardColor[index % 8])
                                                        .frame(minHeight: 140, idealHeight: 150, maxHeight: 160)
                                                        .padding(.vertical, 5)
                                                }
                                            }
                                        }
                                        .padding(.bottom, 10)
                                    }
                                }
                            }
                            .gesture(DragGesture()
                                        .onEnded({ (value) in
                                            if (value.translation.width < -60) {
                                                self.tabSelected = 1
                                                self.tippOffset = UIScreen.main.bounds.width / 2
                                                self.selectWidth = 120
                                                
                                                self.slidingText = "Gespeicherte"
                                            } else if (value.translation.width > 60) {
                                                self.mode.wrappedValue.dismiss()
                                            }
                                        }))
                            .offset(x: self.tabSelected == 0 ? 0 : -UIScreen.main.bounds.width)
                            .frame(maxWidth: UIScreen.main.bounds.width)
                            VStack {
                                if (!self.allTipps.isEmpty) {
                                    ScrollView(.vertical, showsIndicators: false) {
                                        ForEach(self.allTipps.indices, id: \.self) { index in
                                            VStack (spacing: 0) {
                                                if(self.allTipps[index].isBookmarked) {
                                                    SmallTippCard(
                                                        isChecked: self.$allTipps[index].isChecked,
                                                        isBookmarked: self.$allTipps[index].isBookmarked,
                                                        tipp: self.allTipps[index],
                                                        color: self.cardColor[index % 8])
                                                        .frame(minHeight: 140, idealHeight: 150, maxHeight: 160)
                                                        .padding(.vertical, 5)
                                                }
                                            }
                                        }
                                        .padding(.bottom, 10)
                                    }
                                }
                            }
                            .gesture(DragGesture()
                                        .onEnded({ (value) in
                                            if value.translation.width < -60 {
                                                
                                                self.tabSelected = 2
                                                self.tippOffset = geoMidOwn
                                                self.selectWidth = 80
                                                
                                                self.slidingText = "Eigene"
                                            } else if (value.translation.width > 60) {
                                                self.tabSelected = 0
                                                self.tippOffset = geoMidChecked
                                                self.selectWidth = 90
                                                
                                                self.slidingText = "Abgehakte"
                                            }
                                        }))
                            .frame(maxWidth: UIScreen.main.bounds.width)
                            .offset(x: self.tabSelected == 0 ? UIScreen.main.bounds.width : 0)
                            .offset(x: self.tabSelected == 2 ? -UIScreen.main.bounds.width : 0)
                            VStack {
                                if (!self.ownTipps.isEmpty) {
                                    ScrollView(.vertical, showsIndicators: false) {
                                        ForEach(self.ownTipps.indices, id: \.self) { index in
                                            VStack (spacing: 0) {
                                                SmallTippCard(
                                                    isChecked: self.$allTipps[index].isChecked,
                                                    isBookmarked: self.$allTipps[index].isBookmarked,
                                                    tipp: self.allTipps[index],
                                                    color: self.cardColor[index % 8])
                                                    .frame(minHeight: 140, idealHeight: 150, maxHeight: 160)
                                                    .padding(.vertical, 5)
                                            }
                                        }
                                        .padding(.bottom, 10)
                                    }
                                } else {
                                    VStack {
                                        Image("I")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(minHeight: 40, idealHeight: 200, maxHeight: 300)
                                            .padding(.horizontal, 30)
                                        Text("Lade eigene Tipps hoch um diese hier wieder zu finden!")
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal)
                                        Spacer()
                                    }
                                }
                            }
                            .gesture(DragGesture()
                                        .onEnded({ (value) in
                                            if value.translation.width > 60 {
                                                self.tabSelected = 1
                                                self.tippOffset = UIScreen.main.bounds.width / 2
                                                self.selectWidth = 120
                                                
                                                self.slidingText = "Gespeicherte"
                                            }
                                        }))
                            .frame(maxWidth: UIScreen.main.bounds.width)
                            .offset(x: self.tabSelected == 2 ? 0 : UIScreen.main.bounds.width)
                        }
                        .animation(.spring())
                    } else {
                        VStack{
                            LottieView(filename: "loadingCircle", loop: true)
                                .frame(width: 50, height: 50)
                        }.frame(maxHeight: UIScreen.main.bounds.height * 0.8)
                    }
                    Spacer()
                }
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.showSliderView = true
                }
                loadUser()
            }
        }
        .accentColor(.black)
        .gesture(DragGesture()
                    .onChanged({ (value) in
                        if value.translation.width > 40 {
                            self.mode.wrappedValue.dismiss()
                        }
                    }))
    }
    
    func loadUser() {
        guard let url = URL(string: myUrl.users + (id ?? "")) else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            if let decodedResponse = try? JSONDecoder().decode(User.self, from: data) {
                userObject = decodedResponse
                loadOwnTipps()
                loadAllTipps()
            }
        }.resume()
    }
    
    func loadOwnTipps() {
        let ownUrl = myUrl.tipps + "postedBy=" + (id ?? "")
        guard let url = URL(string: ownUrl) else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            if let tipps = try? JSONDecoder().decode([Tipp].self, from: data) {
                self.ownTipps = tipps
                if (self.ownTipps.count > 0) {
                    for (index, test) in self.ownTipps.enumerated() {
                        if (userObject.checkedTipps.contains(test._id)){
                            self.ownTipps[index].isChecked = true
                        }
                        if (userObject.savedTipps.contains(test._id)){
                            self.ownTipps[index].isBookmarked = true
                        }
                    }
                }
            }
        }.resume()
    }
    
    func loadAllTipps() {
        TippApi().fetchAll { (allTipps) in
            self.allTipps = allTipps
            if (self.allTipps.count > 0) {
                for (index, test) in self.allTipps.enumerated() {
                    if (userObject.checkedTipps.contains(test._id)){
                        self.allTipps[index].isChecked = true
                    }
                    if (userObject.savedTipps.contains(test._id)){
                        self.allTipps[index].isBookmarked = true
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.loading = false
                }
            }
        }
    }
}


struct ProfilTippView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilTippView()
    }
}

struct SliderView: View {
    
    @Binding var slidingText: String
    @Binding var selectWidth: CGFloat
    @Binding var tippOffset: CGFloat
    @Binding var tabSelected: Int
    @Binding var geoMidChecked: CGFloat
    @Binding var geoMidSaved: CGFloat
    @Binding var geoMidOwn: CGFloat
    
    var screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        ZStack {
            Text(slidingText)
                .font(.system(size: screenWidth < 500 ? screenWidth * 0.03 : 20))
                .foregroundColor(Color("black"))
                .frame(width: selectWidth, height: 2)
                .offset(x: tippOffset - (UIScreen.main.bounds.width/2), y: 25)
                .animation(.spring())
            HStack (spacing: 0){
                Spacer()
                    .frame(maxWidth: screenWidth / 25)
                GeometryReader { g in
                    Button(action: {
                        self.tabSelected = 0
                        self.tippOffset = g.frame(in: .global).midX
                        self.selectWidth = 90
                        
                        self.slidingText = "Abgehakte"
                        
                        impact(style: .medium)
                    }){
                        Image(systemName: "checkmark")
                            .multilineTextAlignment(.center)
                            .font(.system(size: screenWidth < 500 ? screenWidth * 0.06 : 25))
                            .foregroundColor(self.tabSelected == 0 ? Color("black") : .secondary)
                            .offset(y: self.tabSelected == 0 ? 0 : 5)
//                            .frame(width: screenWidth < 500 ? screenWidth * 0.16 : 50, height: 20)
                            .frame(width: 60, height: 40)
                    }
                    .onAppear(){
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.tippOffset = g.frame(in: .global).midX
                            self.geoMidChecked = g.frame(in: .global).midX
                        }
                    }
                }
                .animation(.spring())
                .frame(width: 60, height: 40)
                Spacer()
                GeometryReader { g in
                    Button(action: {
                        self.tabSelected = 1
                        self.tippOffset = g.frame(in: .global).midX
                        self.selectWidth = 120
                        
                        self.slidingText = "Gespeicherte"
                        
                        impact(style: .medium)
                    }){
                        Image(systemName: "bookmark")
                            .multilineTextAlignment(.center)
                            .font(.system(size: screenWidth < 500 ? screenWidth * 0.06 : 25))
                            .foregroundColor(self.tabSelected == 1 ? Color("black") : .secondary)
                            .offset(y: self.tabSelected == 1 ? 0 : 5)
                            .frame(width: 60, height: 40)
                    }
                    .onAppear(){
                        self.geoMidSaved = g.frame(in: .global).midX
                    }
                }.animation(.spring())
                .frame(width: 60, height: 40)
                Spacer()
                GeometryReader { g in
                    Button(action: {
                        self.tabSelected = 2
                        self.tippOffset = g.frame(in: .global).midX
                        self.selectWidth = 80
                        
                        self.slidingText = "Eigene"
                        
                        impact(style: .medium)
                    }){
                        Image(systemName: "plus.circle")
                            .multilineTextAlignment(.center)
                            .font(.system(size: screenWidth < 500 ? screenWidth * 0.06 : 25))
                            .foregroundColor(self.tabSelected == 2 ? Color("black") : .secondary)
                            .offset(y: self.tabSelected == 2 ? 0 : 5)
                            .frame(width: 60, height: 40)
                    }
                    .onAppear(){
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.geoMidOwn = g.frame(in: .global).midX
                        }
                    }
                }.animation(.spring())
                .frame(width: 60, height: 40)
                Spacer()
                    .frame(maxWidth: screenWidth / 25)
            }.padding(.horizontal, 10)
        }
    }
}
