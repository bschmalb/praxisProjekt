//
//  ContentView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 25.03.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import CoreHaptics
//import SwiftUIPager
import SwiftUI

func haptic(type: UINotificationFeedbackGenerator.FeedbackType) {
    UINotificationFeedbackGenerator().notificationOccurred(type)
}

func impact (style: UIImpactFeedbackGenerator.FeedbackStyle) {
    UIImpactFeedbackGenerator(style: style).impactOccurred()
}

struct ToggleModel {
    var isDark: Bool = UserDefaults.standard.bool(forKey: "isDark") {
        didSet { SceneDelegate.shared?.window!.overrideUserInterfaceStyle = isDark ? .dark : .light }
    }
}

struct ContentView: View {
    
    @State var model = ToggleModel()
    
    @State private var isUser = UserDefaults.standard.bool(forKey: "isUser")
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State var tabTippSelected = true
    @State var tabChallSelected = false
    @State var tabLogSelected = false
    @State var tabProfileSelected = false
    @State var tabViewSelected = 0
    
    @State var tippOffset: CGFloat = 0
    @State var challengeOffset: CGFloat = UIScreen.main.bounds.width
    @State var logOffset: CGFloat = UIScreen.main.bounds.width
    @State var profileOffset: CGFloat = UIScreen.main.bounds.width
    
    @State var offsetCapsule: CGFloat = -UIScreen.main.bounds.width / 3.08
    @State var widthCapsule: CGFloat = 25
    
    var body: some View {
        ZStack {
            Color("background")
                .edgesIgnoringSafeArea(.all)
            VStack {
                ZStack {
                    TippView().offset(x: tippOffset).opacity(tabTippSelected ? 1 : 0)
                    ChallengeView().offset(x: challengeOffset).opacity(tabChallSelected ? 1 : 0)
                    TagebuchView().offset(x: logOffset).opacity(tabLogSelected ? 1 : 0)
                    ProfilView().offset(x: profileOffset).opacity(tabProfileSelected ? 1 : 0)
                }
            }
                .padding(.top, 1)
            .padding(.bottom, UIScreen.main.bounds.height / 12)
            VStack {
                Spacer()
                ZStack {
                    HStack (spacing: UIScreen.main.bounds.width / 7) {
                        Button(action: {
                            self.offsetCapsule = -UIScreen.main.bounds.width / 3.08
                            self.widthCapsule = 25
                            self.tabTippSelected = true
                            self.tabChallSelected = false
                            self.tabLogSelected = false
                            self.tabProfileSelected = false
                            
                            self.tippOffset = 0
                            self.challengeOffset = UIScreen.main.bounds.width
                            self.logOffset = UIScreen.main.bounds.width
                            self.profileOffset = UIScreen.main.bounds.width
                            
                            
                            self.tabViewSelected = 0
                            
                            impact(style: .medium)
                        }) {
                            VStack {
                                Image(systemName: "lightbulb")
                                    .font(.system(size: 22, weight: Font.Weight.medium))
                                    .opacity(tabTippSelected ? 1 : 0.5)
                            }
                        }
                        Button(action: {
                            self.offsetCapsule = -UIScreen.main.bounds.width / 9.5
                            self.widthCapsule = 50
                            self.tabTippSelected = false
                            self.tabChallSelected = true
                            self.tabLogSelected = false
                            self.tabProfileSelected = false
                            
                            self.tippOffset = -UIScreen.main.bounds.width
                            self.challengeOffset = 0
                            self.logOffset = UIScreen.main.bounds.width
                            self.profileOffset = UIScreen.main.bounds.width
                            
                            self.tabViewSelected = 1
                            
                            impact(style: .medium)
                        }) {
                            VStack {
                            Image(systemName: "person.3")
                                .font(.system(size: 22, weight: Font.Weight.medium))
                                .opacity(tabChallSelected ? 1 : 0.5)
                            }
                        }
                        Button(action: {
                            self.offsetCapsule = UIScreen.main.bounds.width / 8
                            self.widthCapsule = 30
                            self.tabTippSelected = false
                            self.tabChallSelected = false
                            self.tabLogSelected = true
                            self.tabProfileSelected = false
                            
                            self.tippOffset = -UIScreen.main.bounds.width
                            self.challengeOffset = -UIScreen.main.bounds.width
                            self.logOffset = 0
                            self.profileOffset = UIScreen.main.bounds.width
                            
                            self.tabViewSelected = 2
                            
                            impact(style: .medium)
                        }) {
                            VStack {
                            Image(systemName: "book")
                                .font(.system(size: 22, weight: Font.Weight.medium))
                                .opacity(tabLogSelected ? 1 : 0.5)
                            }
                        }
                        Button(action: {
                            self.offsetCapsule = UIScreen.main.bounds.width / 3.1
                            self.widthCapsule = 20
                            self.tabTippSelected = false
                            self.tabChallSelected = false
                            self.tabLogSelected = false
                            self.tabProfileSelected = true
                            
                            self.tippOffset = -UIScreen.main.bounds.width
                            self.challengeOffset = -UIScreen.main.bounds.width
                            self.logOffset = -UIScreen.main.bounds.width
                            self.profileOffset = 0
                            
                            self.tabViewSelected = 3
                            
                            impact(style: .medium)
                        }) {
                            VStack {
                            Image(systemName: "person")
                                .font(.system(size: 22, weight: Font.Weight.medium))
                                .opacity(tabProfileSelected ? 1 : 0.5)
                            }
                        }
                    }
                .accentColor(Color("black"))
                    .offset(y: -2)
                    Capsule()
                            .fill(Color("black"))
                            .frame(width: widthCapsule, height: 2)
                            .offset(x: offsetCapsule, y: 17)
                }
                .frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height / 14, alignment: .center)
                .background(Color("buttonWhite"))
                .cornerRadius(20)
                .shadow(color: Color(.black).opacity(0.2), radius: 5, x: 0, y: 4)
            }.animation(.spring())
                .padding(.bottom, UIScreen.main.bounds.height / 40)
        }.edgesIgnoringSafeArea(.bottom)
            .animation(.spring())
//        TabView {
//            TippView()
//                .tabItem {
//                    Image(systemName: "lightbulb")
//                    Text("Tipps")
//            }
//            VStack {
//                Text("Hallo")
//            }.tabItem {
//                Image(systemName: "person.3")
//                Text("Challenges")
//            }
//            VStack {
//                TagebuchView()
//            }.tabItem {
//                Image(systemName: "book")
//                Text("Tagebuch")
//            }
//            VStack {
//                ProfilView()
//            }.tabItem {
//                Image(systemName: "person")
//                Text("Profil")
//            }
//        }.accentColor(.primary)
        .onAppear(){
            self.createUser()
            print(UIScreen.main.bounds.height)
        }
    }
    func createUser(){
        if (!self.isUser) {
            if let uuid = UIDevice.current.identifierForVendor?.uuidString {
                let userData = User(id: uuid, name: "", checkedTipps: [], savedTipps: [], checkedChallenges: [], savedChallenges: [])
                
                guard let encoded = try? JSONEncoder().encode(userData) else {
                    print("Failed to encode order")
                    return
                }
                guard let url = URL(string: "http://bastianschmalbach.ddns.net/users") else { return }
                var request = URLRequest(url: url)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
                request.httpBody = encoded
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data else {
                        print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                        return
                    }
                    self.isUser = true
                    UserDefaults.standard.set(self.isUser, forKey: "isUser")
                    print("User erfolgreich erstellt")
                }.resume()
            }
        } else {
            print("isUser")
        }
    }
}

struct User: Encodable, Decodable {
    var id: String
    var name: String
    var checkedTipps: [String]
    var savedTipps: [String]
    var checkedChallenges: [String]
    var savedChallenges: [String]
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
