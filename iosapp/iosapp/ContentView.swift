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
    
    @State var launchScreen: Bool = true
    @State var tabViewSelected = 0
    
    @State var tippOffset: CGFloat = 0
    @State var challengeOffset: CGFloat = UIScreen.main.bounds.width
    @State var logOffset: CGFloat = UIScreen.main.bounds.width
    @State var profileOffset: CGFloat = UIScreen.main.bounds.width
    
    @State var offsetCapsule: CGFloat = 0
    @State var widthCapsule: CGFloat = 25
    @State var screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        ZStack {
            Color("background")
                .edgesIgnoringSafeArea(.all)
            VStack {
                ZStack {
                    TippView(isDark: $model.isDark, appearenceDark: $appearenceDark).offset(x: tippOffset).opacity(tabViewSelected == 0 ? 1 : 0)
                        .padding(.top, 1)
                        .padding(.bottom, UIScreen.main.bounds.height / 12)
                    ChallengeView().offset(x: challengeOffset).opacity(tabViewSelected == 1 ? 1 : 0)
                        .padding(.top, 1)
                        .padding(.bottom, UIScreen.main.bounds.height / 12)
                    TagebuchView(tabViewSelected: $tabViewSelected).offset(x: logOffset).opacity(tabViewSelected == 2 ? 1 : 0)
                        .padding(.bottom, UIScreen.main.bounds.height / 12)
                    ProfilView(isDark: $model.isDark, appearenceDark: $appearenceDark).offset(x: profileOffset).opacity(tabViewSelected == 3 ? 1 : 0)
                }
            }
            VStack {
                Spacer()
                //                    .onChange(of: tabViewSelected) { value in
                //                        selectTab(tabViewSelected: tabViewSelected)
                //                    }
                ZStack {
                    HStack (spacing: screenWidth / 14) {
                        GeometryReader { g in
                            Button(action: {
                                self.tabViewSelected = 0
                                self.selectTab(tabViewSelected: self.tabViewSelected)
                                
                                self.offsetCapsule = g.frame(in: .global).midX
                                
                                impact(style: .medium)
                            }) {
                                VStack {
                                    Image(systemName: "lightbulb")
                                        .font(.system(size: 22, weight: Font.Weight.medium))
                                        .opacity(self.tabViewSelected == 0 ? 1 : 0.5)
                                }
                            .padding()
                            }
                            .onAppear(){
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                    self.offsetCapsule = g.frame(in: .global).midX
                                }
                            }
                        }
                        .frame(width: 60)
                        GeometryReader { g in
                            Button(action: {
                                self.tabViewSelected = 1
                                self.selectTab(tabViewSelected: self.tabViewSelected)
                                
                                self.offsetCapsule = g.frame(in: .global).midX
                                
                                impact(style: .medium)
                            }) {
                                VStack {
                                    Image(systemName: "person.3")
                                        .font(.system(size: 22, weight: Font.Weight.medium))
                                        .opacity(self.tabViewSelected == 1 ? 1 : 0.5)
                                }
                                .padding()
                            }
                        }
                        .frame(width: 60)
                        GeometryReader { g in
                            Button(action: {
                                self.tabViewSelected = 2
                                self.selectTab(tabViewSelected: self.tabViewSelected)
                                
                                self.offsetCapsule = g.frame(in: .global).midX
                                
                                impact(style: .medium)
                            }) {
                                VStack {
                                    Image(systemName: "book")
                                        .font(.system(size: 22, weight: Font.Weight.medium))
                                        .opacity(self.tabViewSelected == 2 ? 1 : 0.5)
                                }
                                .padding()
                            }
                        }
                        .frame(width: 60)
                        GeometryReader { g in
                            Button(action: {
                                self.tabViewSelected = 3
                                self.selectTab(tabViewSelected: self.tabViewSelected)
                                
                                self.offsetCapsule = g.frame(in: .global).midX
                                
                                impact(style: .medium)
                            }) {
                                VStack {
                                    Image(systemName: "person")
                                        .font(.system(size: 22, weight: Font.Weight.medium))
                                        .opacity(self.tabViewSelected == 3 ? 1 : 0.5)
                                }
                                .padding()
                            }
                        }
                        .frame(width: 60)
                    }
                    .accentColor(Color("black"))
                    .offset(y: -2)
                    Capsule()
                        .fill(Color("black"))
                        .frame(width: widthCapsule, height: 2)
                        .offset(x: offsetCapsule - (screenWidth/2), y: 17)
                }
                .frame(width: screenWidth - 30, height: UIScreen.main.bounds.height / 14, alignment: .center)
                .background(Color("buttonWhite"))
                .cornerRadius(20)
                .shadow(color: Color(.black).opacity(0.2), radius: 5, x: 0, y: 4)
                //                }
            }
            .padding(.bottom, UIScreen.main.bounds.height / 40)
            .animation(.spring())
            ZStack {
                Color("cardgreen2")
                    .edgesIgnoringSafeArea(.all)
                Image("JustLogo")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 130, height: 130)
                    .offset(y: -23.0)
            }
            .opacity(launchScreen ? 1 : 0)
//            .scaleEffect(launchScreen ? 1 : 2)
                .animation(Animation.easeOut(duration: 0.5).delay(0.5))
        }.edgesIgnoringSafeArea(.bottom)
            .animation(.spring())
            .onAppear(){
                if (!self.isUser2) {
                    self.createUser()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation() {
                        self.launchScreen = false
                    }
                }
        }
    }
    
    func selectTab(tabViewSelected: Int) {
        
        if (tabViewSelected == 0) {
            self.widthCapsule = 25
            
            self.tippOffset = 0
            self.challengeOffset = screenWidth
            self.logOffset = screenWidth
            self.profileOffset = screenWidth
        }
        
        if (tabViewSelected == 1) {
            self.widthCapsule = 50
            
            self.tippOffset = -screenWidth
            self.challengeOffset = 0
            self.logOffset = screenWidth
            self.profileOffset = screenWidth
        }
        
        if (tabViewSelected == 2) {
            self.widthCapsule = 30
            
            self.tippOffset = -screenWidth
            self.challengeOffset = -screenWidth
            self.logOffset = 0
            self.profileOffset = screenWidth
        }
        
        if (tabViewSelected == 3) {
            self.widthCapsule = 25
            
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
                //                print(data)
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
