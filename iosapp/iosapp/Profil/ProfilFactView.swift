//
//  ProfilTippView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 19.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct ProfilFactView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var myUrl: ApiUrl
    
    @ObservedObject var store = AllTippDataStore()
    @EnvironmentObject var changeFilter: ChangeFilter
    
    let uuid = UIDevice.current.identifierForVendor?.uuidString
    
    @State var id = UserDefaults.standard.string(forKey: "id")
    
    @State var loading = true
    @State var loading2 = true
    
    @State var allFacts: [Fact] = []
    
    @State var userObject: User = User(_id: "", phoneId: "", level: 0, checkedTipps: [], savedTipps: [], savedFacts: [], log: [])
    
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
                    SliderView2(slidingText: $slidingText, selectWidth: $selectWidth, tippOffset: $tippOffset, tabSelected: $tabSelected, geoMidSaved: $geoMidSaved, geoMidOwn: $geoMidOwn)
                        .offset(y: -10)
                        .opacity(loading ? 0 : 1)
                    if (!changeFilter.changeFilter){
                        ZStack {
                            VStack {
                                if (!self.allFacts.isEmpty) {
                                    ScrollView(.vertical, showsIndicators: false) {
                                        ForEach(self.allFacts.indices, id: \.self) { index in
                                            VStack (spacing: 0) {
                                                if(self.allFacts[index].isBookmarked) {
                                                    SmallFactCard(
                                                        isBookmarked: self.$allFacts[index].isBookmarked,
                                                        fact: self.allFacts[index],
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
                                                
                                                self.tabSelected = 1
                                                self.tippOffset = geoMidOwn
                                                self.selectWidth = 80
                                                
                                                self.slidingText = "Eigene"
                                            } else if (value.translation.width > 60) {
                                                self.mode.wrappedValue.dismiss()
                                            }
                                        }))
                            .frame(maxWidth: UIScreen.main.bounds.width)
                            .offset(x: self.tabSelected == 0 ? 0 : -UIScreen.main.bounds.width)
                            VStack {
                                if (!self.allFacts.isEmpty) {
                                    ScrollView(.vertical, showsIndicators: false) {
                                        ForEach(self.allFacts.indices, id: \.self) { index in
                                            VStack (spacing: 0) {
                                                if(self.id == self.allFacts[index].postedBy) {
                                                    SmallFactCard(
                                                        isBookmarked: self.$allFacts[index].isBookmarked,
                                                        fact: self.allFacts[index],
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
                                            if value.translation.width > 60 {
                                                self.tabSelected = 0
                                                self.tippOffset = geoMidSaved
                                                self.selectWidth = 120
                                                
                                                self.slidingText = "Gespeicherte"
                                            }
                                        }))
                            .frame(maxWidth: UIScreen.main.bounds.width)
                            .offset(x: self.tabSelected == 1 ? 0 : UIScreen.main.bounds.width)
                        }
                        .opacity(loading2 ? 0 : 1)
                        .animation(.spring())
                    } else {
                        VStack{
                            LottieView(filename: "loadingCircle", loop: true)
                                .frame(width: 50, height: 50)
                        }.frame(maxHeight: UIScreen.main.bounds.height * 0.8)
                        .onAppear(){
                            FactApi().fetchAll { (allFacts) in
                                self.allFacts = []
                                self.allFacts = allFacts
                                print(allFacts)
                                if (self.allFacts.count > 0) {
                                    for (index, test) in self.allFacts.enumerated() {
                                        if (userObject.savedFacts!.contains(test._id)){
                                            self.allFacts[index].isBookmarked = true
                                        }
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        self.changeFilter.changeFilter = false
                                    }
                                }
                            }
                        }
                    }
                    Spacer()
                }
            }
            VStack {
                if (loading || loading2) {
                    VStack{
                        LottieView(filename: "loadingCircle", loop: true)
                            .frame(width: 50, height: 50)
                    }
                }
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    self.loading = false
                }
                guard let url = URL(string: myUrl.users + (id ?? "")) else { return }
                    let request = URLRequest(url: url)
                    
                    URLSession.shared.dataTask(with: request) { data, response, error in
                        guard let data = data else {
                            print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                            return
                        }
                        if let decodedResponse = try? JSONDecoder().decode(User.self, from: data) {
                            userObject = decodedResponse
                            FactApi().fetchAll { (allFacts) in
                                self.allFacts = allFacts
                                if (self.allFacts.count > 0) {
                                    for (index, test) in self.allFacts.enumerated() {
                                        if (userObject.savedFacts!.contains(test._id)){
                                            self.allFacts[index].isBookmarked = true
                                        }
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                        self.loading2 = false
                                    }
                                }
                            }
                        }
                    }.resume()
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
}


struct ProfilFactView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilFactView()
    }
}

struct SliderView2: View {
    
    @Binding var slidingText: String
    @Binding var selectWidth: CGFloat
    @Binding var tippOffset: CGFloat
    @Binding var tabSelected: Int
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
                GeometryReader { g in
                    Button(action: {
                        self.tabSelected = 0
                        self.tippOffset = g.frame(in: .global).midX
                        self.selectWidth = 120
                        
                        self.slidingText = "Gespeicherte"
                        
                        impact(style: .medium)
                    }){
                        Image(systemName: "bookmark")
                            .multilineTextAlignment(.center)
                            .font(.system(size: screenWidth < 500 ? screenWidth * 0.06 : 25))
                            .foregroundColor(self.tabSelected == 0 ? Color("black") : .secondary)
                            .offset(y: self.tabSelected == 0 ? 0 : 5)
                            .frame(width: 60, height: 40)
                    }
                    .onAppear(){
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.tippOffset = g.frame(in: .global).midX
                            self.geoMidSaved = g.frame(in: .global).midX
                        }
                    }
                }.animation(.spring())
                .frame(width: 60, height: 40)
                Spacer()
                Spacer()
                GeometryReader { g in
                    Button(action: {
                        self.tabSelected = 1
                        self.tippOffset = g.frame(in: .global).midX
                        self.selectWidth = 80
                        
                        self.slidingText = "Eigene"
                        
                        impact(style: .medium)
                    }){
                        Image(systemName: "plus.circle")
                            .multilineTextAlignment(.center)
                            .font(.system(size: screenWidth < 500 ? screenWidth * 0.06 : 25))
                            .foregroundColor(self.tabSelected == 1 ? Color("black") : .secondary)
                            .offset(y: self.tabSelected == 1 ? 0 : 5)
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
            }.padding(.horizontal, 10)
        }
    }
}
