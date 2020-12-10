//
//  RateTippView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 09.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct RateTippView: View {
    
    @State var user: User = User(_id: "", phoneId: "", level: 0, checkedTipps: [], savedTipps: [], savedFacts: [], log: [])
    @State var id = UserDefaults.standard.string(forKey: "id")
    
    //    @ObservedObject var store2 = RateTippDataStore()
    @State var rateTipps: [Tipp] = []
    @State var rateTipps2: [Tipp] = []
    @State var alreadyRated: [String] = UserDefaults.standard.stringArray(forKey: "alreadyRated") ?? []
    
    @Binding var showRateTipps: Bool
    
    @State private var showAddTipps2 = false
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var levelEnv: UserLevel
    @EnvironmentObject var myUrl: ApiUrl
    
    @State var counter: Int = 0
    @State var thumbUp = false
    @State var thumbDown = false
    @State var endReached = false
    @State var loading = true
    
    @State var userLevelLocal = 0
    
    var screenHeight = UIScreen.main.bounds.height
    
    var cardColors: [String]  = [
        "cardgreen2", "cardblue2", "cardyellow2", "cardpurple2", "cardorange2", "cardred2", "cardturqouise2", "cardyelgre2", "cardpink2"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("background").edgesIgnoringSafeArea(.all)
                
                VStack (spacing: 0){
                    
                    HStack {
                        Text("Tipps bewerten")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.leading, 20)
                        
                        Spacer()
                        Button(action: {
                            self.showRateTipps = false
                            impact(style: .medium)
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 24, weight: Font.Weight.medium))
                                .padding(25)
                        }
                    }
                    .padding(.top, 20)
                    
                    Text("Wenn ein Tipp von der Community gutes Feedback bekommt, wird dieser für alle Nutzer angezeigt")
                        .font(.system(size: 14))
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 15)
                        .padding(.bottom, 15)
                    
                    if (!loading) {
                        if (rateTipps.count > 0) {
                            ZStack {
                                VStack{
                                    ZStack {
                                        ForEach(rateTipps.indices, id: \.self) { index in
                                            TippCard2(
                                                user: user,
                                                tipp: rateTipps[index],
                                                color: cardColors[counter % 9])
                                                .animation(.spring())
                                                .offset(x: counter < index ? 500 : 0)
                                                .offset(x: counter > index ? -500 : 0)
                                                .opacity(counter == index ? 1 : 0)
                                        }
                                    }
                                    HStack {
                                        Image(systemName: "hand.thumbsup")
                                            .font(.system(size: UIScreen.main.bounds.width < 500 ? UIScreen.main.bounds.width * 0.06 : 24, weight: Font.Weight.medium))
                                            .accentColor(Color("black"))
                                            .padding(10)
                                            .frame(width: UIScreen.main.bounds.width > 600 ? 275 : UIScreen.main.bounds.width / 2 - 20, height: screenHeight > 700 ? 50 : screenHeight * 0.075)
                                            .background(Color("buttonWhite"))
                                            .cornerRadius(15)
                                            .shadow(color: Color("black").opacity(0.05), radius: 5, x: 4, y: 4)
                                            .scaleEffect(thumbUp ? 1.1 : 1)
                                            .onTapGesture(){
                                                self.levelEnv.level += 35
                                                UserDefaults.standard.set(self.levelEnv.level, forKey: "userLevel")

                                                self.alreadyRated.append(self.rateTipps[counter]._id)
                                                UserDefaults.standard.set(self.alreadyRated, forKey: "alreadyRated")

                                                patchScore(id: self.rateTipps[self.counter]._id, thumb: "up")
                                                if (self.counter < self.rateTipps.count - 1){
                                                    withAnimation(){self.counter += 1}
                                                }
                                                else {
                                                    withAnimation(){self.endReached = true}
                                                }
                                                self.thumbUp = true
                                                impact(style: .medium)
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                                    self.thumbUp = false
                                                }
                                            }
                                        Image(systemName: "hand.thumbsdown")
                                            .font(.system(size: UIScreen.main.bounds.width < 500 ? UIScreen.main.bounds.width * 0.06 : 24, weight: Font.Weight.medium))
                                            .accentColor(Color("black"))
                                            .padding(10)
                                            .frame(width: UIScreen.main.bounds.width > 600 ? 275 : UIScreen.main.bounds.width / 2 - 20, height: screenHeight > 700 ? 50 : screenHeight * 0.075)
                                            .background(Color("buttonWhite"))
                                            .cornerRadius(15)
                                            .shadow(color: Color("black").opacity(0.05), radius: 5, x: 4, y: 4)
                                            .scaleEffect(thumbDown ? 1.1 : 1)
                                            .onTapGesture(){
                                                self.levelEnv.level += 35
                                                UserDefaults.standard.set(self.levelEnv.level, forKey: "userLevel")

                                                self.alreadyRated.append(self.rateTipps[counter]._id)
                                                UserDefaults.standard.set(self.alreadyRated, forKey: "alreadyRated")

                                                patchScore(id: self.rateTipps[self.counter]._id, thumb: "down")
                                                if (self.counter < self.rateTipps.count - 1){
                                                    withAnimation(){self.counter += 1}
                                                    print(rateTipps[counter].title)
                                                }
                                                else {
                                                    withAnimation(){self.endReached = true}
                                                    print("endReached")
                                                }
                                                self.thumbDown = true
                                                impact(style: .medium)
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                                    self.thumbDown = false
                                                }
                                            }
                                    }.padding(.top, 10)
                                    .animation(.spring())
                                }
                                .offset(x: endReached ? -UIScreen.main.bounds.width : 0)
                                CustomCard(image: "SofaChill", text: "Vorerst keine weiteren Fakten mehr zum bewerten verfügbar", color: "cardgreen2")
                                    .offset(x: endReached ? 0 : UIScreen.main.bounds.width)
                            }
                            .animation(.spring())
                        } else {
                            CustomCard(image: "SofaChill", text: "Vorerst keine weiteren Fakten mehr zum bewerten verfügbar", color: "cardgreen2")
                        }
                    } else {
                        VStack {
                            Spacer()
                            LottieView(filename: "loadingCircle", loop: true)
                                .frame(width: 80, height: 80)
                                .background(Color("background"))
                                .cornerRadius(50)
                            Spacer()
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: UIScreen.main.bounds.height / 2)
                    }
                    Spacer()
                    Button(action: {
                        self.showRateTipps = false
                        impact(style: .medium)
                    }) {
                        Text("Fertig")
                            .font(.system(size: UIScreen.main.bounds.width * 0.04))
                            .padding(25)
                            .opacity(0.8)
                    }
                    Spacer(minLength: 5)
                }
                .animation(.spring())
                .navigationBarTitle("")
                .navigationBarHidden(true)
            }
            .animation(.spring())
        }
        .accentColor(.primary)
        .onAppear(){
            getUser()
            impact(style: .medium)
            TippApi().fetchRate { (rateTipps2) in
                self.rateTipps2 = rateTipps2
                self.rateTipps = rateTipps2.filter({!alreadyRated.contains($0._id)})
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.loading = false
                    if (self.rateTipps.count < 1) {
                        self.endReached = true
                    }
                }
            }
        }
    }
    func patchScore(id: String, thumb: String) {
        
        let rating = Rate(thumb: thumb)
        
        guard let encoded = try? JSONEncoder().encode(rating) else {
            print("Failed to encode order")
            return
        }
        
        guard let url = URL(string: myUrl.tipps + id) else { return }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PATCH"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
        }.resume()
    }
    
    func getUser() {
        guard let url = URL(string: myUrl.users + (id ?? "")) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            if let data = data {
                if let user = try? JSONDecoder().decode(User.self, from: data) {
                    DispatchQueue.main.async {
                        self.user = user
                    }
                    return
                }
            }
        }
        .resume()
    }
}

struct Rate : Encodable, Decodable{
    var thumb: String
}

struct RateTippView_Previews: PreviewProvider {
    static var previews: some View {
        RateTippView(showRateTipps: .constant(false))
    }
}
