//
//  ContentView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 25.03.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import CoreHaptics
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

class UserLevel: ObservableObject {
    @Published var level = UserDefaults.standard.integer(forKey: "userLevel")
}

class Overlay: ObservableObject {
    @Published var overlayLog = UserDefaults.standard.bool(forKey: "overlay")
}

class OverlayLog: ObservableObject {
    @Published var overlayLog = UserDefaults.standard.bool(forKey: "overlayLog")
}

struct ContentView: View {
    
    @State var model = ToggleModel()
    
    @State private var appearenceDark = UserDefaults.standard.bool(forKey: "appearenceDark")
    @State private var isUser2 = UserDefaults.standard.bool(forKey: "isUser2")
    @State private var seenTipps = UserDefaults.standard.stringArray(forKey: "seenTipps")
    @State private var userLevel = UserDefaults.standard.integer(forKey: "userLevel")
    @State private var firstUseTipp = UserDefaults.standard.bool(forKey: "firstUseTipp")
//    @State private var firstUseChallenge = UserDefaults.standard.bool(forKey: "firstUseChallenge")
    @State private var firstUseLog = UserDefaults.standard.bool(forKey: "firstUseLog")
    @State private var firstUseEntw = UserDefaults.standard.bool(forKey: "firstUseEntw")
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var overlay: Overlay
    @EnvironmentObject var levelEnv: UserLevel
    
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
    @State var screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        ZStack {
            Color("background")
                .edgesIgnoringSafeArea(.all)
            VStack {
                ZStack {
                    TippView(isDark: $model.isDark, appearenceDark: $appearenceDark).offset(x: tippOffset).opacity(tabTippSelected ? 1 : 0)
                        .padding(.top, 1)
                        .padding(.bottom, UIScreen.main.bounds.height / 12)
                    ChallengeView().offset(x: challengeOffset).opacity(tabChallSelected ? 1 : 0)
                        .padding(.top, 1)
                        .padding(.bottom, UIScreen.main.bounds.height / 12)
                    TagebuchView(tabViewSelected: $tabViewSelected).offset(x: logOffset).opacity(tabLogSelected ? 1 : 0)
                        .padding(.bottom, UIScreen.main.bounds.height / 12)
                    ProfilView(isDark: $model.isDark, appearenceDark: $appearenceDark).offset(x: profileOffset).opacity(tabProfileSelected ? 1 : 0)
                }
            }
            VStack {
                Spacer()
                
//                    .onChange(of: tabViewSelected) { value in
//                        selectTab(tabViewSelected: tabViewSelected)
//                    }

                    ZStack {
                        HStack (spacing: screenWidth / 7) {
                            Button(action: {
                                self.tabViewSelected = 0
                                self.selectTab(tabViewSelected: self.tabViewSelected)
                                
                                impact(style: .medium)
                            }) {
                                VStack {
                                    Image(systemName: "lightbulb")
                                        .font(.system(size: 22, weight: Font.Weight.medium))
                                        .opacity(tabTippSelected ? 1 : 0.5)
                                }
                            }
                            Button(action: {
                                self.tabViewSelected = 1
                                self.selectTab(tabViewSelected: self.tabViewSelected)
                                
                                impact(style: .medium)
                            }) {
                                VStack {
                                    Image(systemName: "person.3")
                                        .font(.system(size: 22, weight: Font.Weight.medium))
                                        .opacity(tabChallSelected ? 1 : 0.5)
                                }
                            }
                            Button(action: {
                                self.tabViewSelected = 2
                                self.selectTab(tabViewSelected: self.tabViewSelected)
                                
                                impact(style: .medium)
                            }) {
                                VStack {
                                    Image(systemName: "book")
                                        .font(.system(size: 22, weight: Font.Weight.medium))
                                        .opacity(tabLogSelected ? 1 : 0.5)
                                }
                            }
                            Button(action: {
                                self.tabViewSelected = 3
                                self.selectTab(tabViewSelected: self.tabViewSelected)
                                
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
                    .frame(width: screenWidth - 30, height: UIScreen.main.bounds.height / 14, alignment: .center)
                    .background(Color("buttonWhite"))
                    .cornerRadius(20)
                    .shadow(color: Color(.black).opacity(0.2), radius: 5, x: 0, y: 4)
//                }
            }.animation(.spring())
            .padding(.bottom, UIScreen.main.bounds.height / 40)
        }.edgesIgnoringSafeArea(.bottom)
        .animation(.spring())
        .onAppear(){
            if (!self.isUser2) {
                self.createUser()
            }
        }
    }
    
    func selectTab(tabViewSelected: Int) {
        
        if (tabViewSelected == 0) {
            self.offsetCapsule = -screenWidth / 3.05
            self.widthCapsule = 25
            self.tabTippSelected = true
            self.tabChallSelected = false
            self.tabLogSelected = false
            self.tabProfileSelected = false
            
            self.tippOffset = 0
            self.challengeOffset = screenWidth
            self.logOffset = screenWidth
            self.profileOffset = screenWidth
        }
        
        if (tabViewSelected == 1) {
            self.offsetCapsule = -screenWidth / 9.5
            self.widthCapsule = 50
            self.tabTippSelected = false
            self.tabChallSelected = true
            self.tabLogSelected = false
            self.tabProfileSelected = false
            
            self.tippOffset = -screenWidth
            self.challengeOffset = 0
            self.logOffset = screenWidth
            self.profileOffset = screenWidth
        }
        
        if (tabViewSelected == 2) {
            self.offsetCapsule = screenWidth / 8
            self.widthCapsule = 30
            self.tabTippSelected = false
            self.tabChallSelected = false
            self.tabLogSelected = true
            self.tabProfileSelected = false
            
            self.tippOffset = -screenWidth
            self.challengeOffset = -screenWidth
            self.logOffset = 0
            self.profileOffset = screenWidth
        }
        
        if (tabViewSelected == 3) {
            self.offsetCapsule = screenWidth / 3.08
            self.widthCapsule = 20
            self.tabTippSelected = false
            self.tabChallSelected = false
            self.tabLogSelected = false
            self.tabProfileSelected = true
            
            self.tippOffset = -screenWidth
            self.challengeOffset = -screenWidth
            self.logOffset = -screenWidth
            self.profileOffset = 0
        }
    }
    
    func createUser(){
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            let userData = User(id: uuid, level: 0, checkedTipps: [], savedTipps: [], checkedChallenges: [], savedChallenges: [], log: [])
            
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
                print(data)
                self.isUser2 = true
                UserDefaults.standard.set(self.isUser2, forKey: "isUser2")
            }.resume()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(UserLevel()).environmentObject(Overlay()).environmentObject(OverlayLog())
    }
}
