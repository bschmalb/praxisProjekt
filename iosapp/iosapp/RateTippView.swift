//
//  RateTippView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 09.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct RateTippView: View {
    
    //    @ObservedObject var store2 = RateTippDataStore()
    @State var rateTipps: [Tipp] = []
    @State var rateTipps2: [Tipp] = []
    @State var alreadyRated: [String] = UserDefaults.standard.stringArray(forKey: "alreadyRated") ?? []
    
    @Binding var showRateTipps: Bool
    
    @State private var showAddTipps2 = false
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var levelEnv: UserLevel
    
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
                    
                    if (!endReached && rateTipps.count > 0) {
                        TippCard2(isChecked: self.$rateTipps[counter].isChecked, isBookmarked: self.$rateTipps[counter].isBookmarked, tipp: rateTipps[counter], color: cardColors[counter % 9])
                            .animation(.spring())
                        HStack {
                            Button(action: {
                                
                            }) {
                                Image(systemName: "hand.thumbsup")
                                    .font(.system(size: UIScreen.main.bounds.width < 500 ? UIScreen.main.bounds.width * 0.06 : 24, weight: Font.Weight.medium))
                                    .accentColor(Color("black"))
                                    .padding(10)
                                    .frame(width: UIScreen.main.bounds.width > 600 ? 275 : UIScreen.main.bounds.width / 2 - 20, height: screenHeight > 700 ? 50 : screenHeight * 0.075)
                                    .background(Color("buttonWhite"))
                                    .cornerRadius(15)
                                    .shadow(color: Color("black").opacity(0.05), radius: 5, x: 4, y: 4)
//                                    .shadow(color: Color(.green).opacity(thumbUp ? 0.5 : 0.1), radius: 5, x: 4, y: 3)
                                    .scaleEffect(thumbUp ? 1.1 : 1)
                                    .gesture(
                                        LongPressGesture().onChanged{ value in
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
                                    )
                            }
                            Button(action: {
                                
                            }) {
                                Image(systemName: "hand.thumbsdown")
                                    .font(.system(size: UIScreen.main.bounds.width < 500 ? UIScreen.main.bounds.width * 0.06 : 24, weight: Font.Weight.medium))
                                    .accentColor(Color("black"))
                                    .padding(10)
                                    .frame(width: UIScreen.main.bounds.width > 600 ? 275 : UIScreen.main.bounds.width / 2 - 20, height: screenHeight > 700 ? 50 : screenHeight * 0.075)
                                    .background(Color("buttonWhite"))
                                    .cornerRadius(15)
                                    .shadow(color: Color("black").opacity(0.05), radius: 5, x: 4, y: 4)
//                                    .shadow(color: Color(.red).opacity(thumbDown ? 0.3 : 0.05), radius: 5, x: 4, y: 3)
                                    .scaleEffect(thumbDown ? 1.1 : 1)
                                    .gesture(
                                        LongPressGesture().onChanged(){ value in
                                            self.levelEnv.level += 35
                                            UserDefaults.standard.set(self.levelEnv.level, forKey: "userLevel")
                                            
                                            self.alreadyRated.append(self.rateTipps[counter]._id)
                                            UserDefaults.standard.set(self.alreadyRated, forKey: "alreadyRated")
                                            
                                            patchScore(id: self.rateTipps[self.counter]._id, thumb: "down")
                                            if (self.counter < self.rateTipps.count - 1){
                                                withAnimation(){self.counter += 1}
                                            }
                                            else {
                                                withAnimation(){self.endReached = true}
                                            }
                                            self.thumbDown = true
                                            impact(style: .medium)
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                                self.thumbDown = false
                                            }
                                        }
                                    )
                            }
                        }.padding(.top, 10)
                        .animation(.spring())
                    }
//                    else if (self.rateTipps2.count < 1) {
//                        CustomCard(image: "Fix website (man)", text: "Stelle sicher, dass du mit dem Internet verbunden bist", color: "buttonWhite")
//                            .animation(.spring())
//                    }
                    else {
                        CustomCard(image: "PersonSofa", text: "Vorerst keine weiteren Tipps mehr zum bewerten verfügbar", color: "cardgreen2")
                            .animation(.spring())
                    }
                    Spacer()
                    Button(action: {
                        self.showRateTipps = false
                        impact(style: .medium)
                    }) {
                        Text("Fertig")
                            .font(.system(size: UIScreen.main.bounds.width * 0.035, weight: .medium))
                            .padding(25)
                            .opacity(0.8)
                    }
                    Spacer(minLength: 5)
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
            }
        }
        .accentColor(.primary)
        .onAppear(){
            impact(style: .medium)
            RateApi().fetchRateTipps { (rateTipps2) in
                self.rateTipps2 = rateTipps2
                self.rateTipps = rateTipps2.filter({!alreadyRated.contains($0._id)})
                print(rateTipps.count)
                if (self.counter > self.rateTipps.count - 1){
                    self.endReached = true
                }
                if (self.rateTipps.count > 0) {
                    self.loading = false
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
    
    guard let url = URL(string: "http://bastianschmalbach.ddns.net/tipps/" + id) else { return }
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "PATCH"
    request.httpBody = encoded
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        
    }.resume()
}

struct Rate : Encodable, Decodable{
    var thumb: String
}

struct RateTippView_Previews: PreviewProvider {
    static var previews: some View {
        RateTippView(showRateTipps: .constant(false))
    }
}
