//
//  ContentView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 25.03.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import CoreHaptics
import SwiftUI
import Combine

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

class ApiUrl: ObservableObject {
    @Published var tipps: String = UserDefaults.standard.string(forKey: "urlTipps") ?? "https://sustainablelife.herokuapp.com/tipps/"
    @Published var users: String = UserDefaults.standard.string(forKey: "urlUsers") ?? "https://sustainablelife.herokuapp.com/users/"
    @Published var feedbacks: String = UserDefaults.standard.string(forKey: "urlFeedbacks") ?? "https://sustainablelife.herokuapp.com/feedbacks/"
    @Published var facts: String = UserDefaults.standard.string(forKey: "urlFacts") ?? "https://sustainablelife.herokuapp.com/facts/"
    @Published var tippsNoSlash: String = UserDefaults.standard.string(forKey: "tippsNoSlash") ?? "https://sustainablelife.herokuapp.com/tipps"
    
    init() {
        UserDefaults.standard.set("https://sustainablelife.herokuapp.com/tipps/", forKey: "urlTipps")
        UserDefaults.standard.set("https://sustainablelife.herokuapp.com/users/", forKey: "urlUsers")
        UserDefaults.standard.set("https://sustainablelife.herokuapp.com/feedbacks/", forKey: "urlFeedbacks")
        UserDefaults.standard.set("https://sustainablelife.herokuapp.com/facts/", forKey: "urlFacts")
        UserDefaults.standard.set("https://sustainablelife.herokuapp.com/tipps", forKey: "tippsNoSlash")
    }
}

class Overlay: ObservableObject {
    @Published var overlayLog = UserDefaults.standard.bool(forKey: "overlay")
}

class OverlayLog: ObservableObject {
    @Published var overlayLog = UserDefaults.standard.bool(forKey: "overlayLog")
}

class RedrawScrollView: ObservableObject {
    @Published var redraw = true
}

class ChangeFilter: ObservableObject {
    @Published var changeFilter = false
    @Published var changeFilterProfile = false
}

class FilterString: ObservableObject {
    var didChange = PassthroughSubject<Void, Never>()
    
    @Published var filterString: [String] {
        didSet {
            UserDefaults.standard.set(filterString, forKey: "filterString")
            didChange.send()
        }
    }
    init() {
        self.filterString = UserDefaults.standard.stringArray(forKey: "filterString") ?? ["Ernährung", "Transport", "Haushalt", "Ressourcen", "Leicht", "Mittel", "Schwer", "Offiziell", "Community"]
        if (self.filterString.count < 2) {
            self.filterString = ["Ernährung", "Transport", "Haushalt", "Ressourcen", "Leicht", "Mittel", "Schwer", "Offiziell", "Community"]
            UserDefaults.standard.set(filterString, forKey: "filterString")
        }
    }
}

class FilterStringFacts: ObservableObject {
    var didChange = PassthroughSubject<Void, Never>()
    
    @Published var filterString: [String] {
        didSet {
            UserDefaults.standard.set(filterString, forKey: "filterStringFacts")
            didChange.send()
        }
    }
    init() {
        self.filterString = UserDefaults.standard.stringArray(forKey: "filterStringFacts") ?? ["Ernährung", "Transport", "Haushalt", "Ressourcen", "Offiziell", "Community"]
        if (self.filterString.count < 2) {
            self.filterString = ["Ernährung", "Transport", "Haushalt", "Ressourcen", "Offiziell", "Community"]
            UserDefaults.standard.set(filterString, forKey: "filterStringFacts")
        }
    }
}


class Model: ObservableObject {
    @Published var pushed = false
}

class UserObserv: ObservableObject {
    @Published var name = UserDefaults.standard.string(forKey: "userName") ?? ""
//    @Published var age = UserDefaults.standard.string(forKey: "age") ?? ""
//    @Published var gender = UserDefaults.standard.string(forKey: "gender") ?? ""
//    @Published var notCategories: [String] = UserDefaults.standard.stringArray(forKey: "notCategory") ?? []
//    @Published var notDifficulties: [String] = UserDefaults.standard.stringArray(forKey: "notDifficulty") ?? []
}

struct ContentView: View {
    
    @State var model = ToggleModel()
    
    @State private var deviceCorners = UserDefaults.standard.bool(forKey: "deviceCorners")
    
    @State var id = UserDefaults.standard.string(forKey: "id")
    
    @EnvironmentObject var myUrl: ApiUrl
    @EnvironmentObject var filterString: FilterString
    
    @State private var appearenceDark = UserDefaults.standard.bool(forKey: "appearenceDark")
    @State private var isUser2 = UserDefaults.standard.bool(forKey: "isUser4")
    @State private var seenTipps = UserDefaults.standard.stringArray(forKey: "seenTipps")
    @State private var userLevel = UserDefaults.standard.integer(forKey: "userLevel")
    @State private var firstUseTipp = UserDefaults.standard.bool(forKey: "firstUseTipp")
    @State private var firstUseLog = UserDefaults.standard.bool(forKey: "firstUseLog")
    @State private var firstUseEntw = UserDefaults.standard.bool(forKey: "firstUseEntw")
    @State private var alreadyRated = UserDefaults.standard.stringArray(forKey: "alreadyRated")
    
    var notCategories: [String] = UserDefaults.standard.stringArray(forKey: "notCategory") ?? []
    var notDifficulties: [String] = UserDefaults.standard.stringArray(forKey: "notDifficulty") ?? []
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var overlay: Overlay
    @EnvironmentObject var levelEnv: UserLevel
    @EnvironmentObject var changeFilter: ChangeFilter
    @ObservedObject var filter = FilterData2()
    @ObservedObject var filterFacts = FilterDataFacts()
    @State var objectLoaded: Bool = false
    @State var objectLoaded2: Bool = false
    
    @State var notca: [String] = []
    
    @State var showTutorial = UserDefaults.standard.bool(forKey: "showTutorial")
    @State var tutorialAnimation = !UserDefaults.standard.bool(forKey: "showTutorial")
    @State var launchScreen: Bool = true
    @State var launchScale: CGFloat = 1
    @State var tabViewSelected = 0
    @State var idLoaded = false
    
    @State var loadLater = false
    
    @State var tippOffset: CGFloat = 0
    @State var challengeOffset: CGFloat = UIScreen.main.bounds.width
    @State var logOffset: CGFloat = UIScreen.main.bounds.width
    @State var profileOffset: CGFloat = UIScreen.main.bounds.width
    
    @State var offsetCapsule: CGFloat = 0
    @State var widthCapsule: CGFloat = 25
    @State var screenWidth = UIScreen.main.bounds.width
    
    @State var selection: Int? = 0
    
    var body: some View {
        GeometryReader { bounds in
            ZStack {
                Color("background")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    if idLoaded {
                        ZStack {
                            TippView(filter: filter)
                                .offset(x: tippOffset)
                                .opacity(tabViewSelected == 0 ? 1 : 0)
                                .padding(.top, 1)
                                .padding(.bottom, UIScreen.main.bounds.height / 12)
                                .environmentObject(UserObserv()).environmentObject(FilterData2())
                            if loadLater {
                                FactView(filter: filterFacts)
                                    .offset(x: challengeOffset)
                                    .opacity(tabViewSelected == 1 ? 1 : 0)
                                    .padding(.top, 1)
                                    .padding(.bottom, UIScreen.main.bounds.height / 12)
                                    .environmentObject(FilterDataFacts())
                                TagebuchView(tabViewSelected: $tabViewSelected)
                                    .offset(x: logOffset)
                                    .opacity(tabViewSelected == 2 ? 1 : 0)
                                    .padding(.bottom, UIScreen.main.bounds.height / 12)
                                ProfilView(tabViewSelected: $tabViewSelected, isDark: $model.isDark, appearenceDark: $appearenceDark, selection: $selection, filter: filter)
                                    .offset(x: profileOffset)
                                    .opacity(tabViewSelected == 3 ? 1 : 0)
                                    .environmentObject(UserObserv()).environmentObject(FilterString())
                            }
                        }
                    }
                }
                .scaleEffect(launchScreen ? 0.8 : 1)
                .scaleEffect(tutorialAnimation ? 0.8 : 1)
                .offset(x: tutorialAnimation ? UIScreen.main.bounds.width : 0)
                .animation(.spring())
                VStack {
                    Spacer()
                    ZStack {
                        HStack {
                            Spacer()
                                .frame(width: bounds.size.width / 13)
                            GeometryReader { g in
                                Button(action: {
                                    self.tabViewSelected = 0
                                    self.selectTab(tabViewSelected: self.tabViewSelected)
                                    
                                    self.offsetCapsule = g.frame(in: .global).midX
                                    
                                    impact(style: .medium)
                                }) {
                                    Image(systemName: "lightbulb")
                                        .font(.system(size: 16 + UIScreen.main.bounds.height / 160, weight: Font.Weight.medium))
                                        .opacity(self.tabViewSelected == 0 ? 1 : 0.5)
                                        .frame(width: 40, height: 40)
                                }
                                .onAppear(){
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.7) {
                                        self.offsetCapsule = g.frame(in: .global).midX
                                    }
                                }
                            }
                            .frame(width: 40, height: 40)
                            Spacer()
                            GeometryReader { g in
                                Button(action: {
                                    self.tabViewSelected = 1
                                    self.selectTab(tabViewSelected: self.tabViewSelected)
                                    
                                    self.offsetCapsule = g.frame(in: .global).midX
                                    
                                    impact(style: .medium)
                                }) {
                                    Image(systemName: "doc.plaintext")
                                        .font(.system(size: 16 + UIScreen.main.bounds.height / 160, weight: Font.Weight.medium))
                                        .opacity(self.tabViewSelected == 1 ? 1 : 0.5)
                                        .frame(width: 40, height: 40)
                                }
                            }
                            .frame(width: 40, height: 40)
                            Spacer()
                            if #available(iOS 14.0, *) {
                                GeometryReader { g in
                                    Button(action: {
                                        self.tabViewSelected = 2
                                        self.selectTab(tabViewSelected: self.tabViewSelected)
                                        
                                        self.offsetCapsule = g.frame(in: .global).midX
                                        
                                        impact(style: .medium)
                                    }) {
                                        Image(systemName: "book")
                                            .font(.system(size: 16 + UIScreen.main.bounds.height / 160, weight: Font.Weight.medium))
                                            .opacity(self.tabViewSelected == 2 ? 1 : 0.5)
                                            .frame(width: 40, height: 40)
                                    }
                                    .onChange(of: tabViewSelected, perform: { value in
                                        if tabViewSelected == 2 {
                                            self.selectTab(tabViewSelected: self.tabViewSelected)
                                            self.offsetCapsule = g.frame(in: .global).midX
                                        }
                                    })
                                }
                                .frame(width: 40, height: 40)
                            } else {
                                GeometryReader { g in
                                    Button(action: {
                                        self.tabViewSelected = 2
                                        self.selectTab(tabViewSelected: self.tabViewSelected)
                                        
                                        self.offsetCapsule = g.frame(in: .global).midX
                                        
                                        impact(style: .medium)
                                    }) {
                                        Image(systemName: "book")
                                            .font(.system(size: 16 + UIScreen.main.bounds.height / 160, weight: Font.Weight.medium))
                                            .opacity(self.tabViewSelected == 2 ? 1 : 0.5)
                                            .frame(width: 40, height: 40)
                                    }
                                }
                                .frame(width: 40, height: 40)
                            }
                            Spacer()
                            GeometryReader { g in
                                Button(action: {
                                    if (tabViewSelected == 3) {
                                        self.selection = 0
                                    }
                                    
                                    self.tabViewSelected = 3
                                    self.selectTab(tabViewSelected: self.tabViewSelected)
                                    
                                    self.mode.wrappedValue.dismiss()
                                    
                                    self.offsetCapsule = g.frame(in: .global).midX
                                    
                                    impact(style: .medium)
                                }) {
                                    Image(systemName: "person")
                                        .font(.system(size: 16 + UIScreen.main.bounds.height / 160, weight: Font.Weight.medium))
                                        .opacity(self.tabViewSelected == 3 ? 1 : 0.5)
                                        .frame(width: 40, height: 40)
                                }
                            }
                            .frame(width: 40, height: 40)
                            Spacer()
                                .frame(width: bounds.size.width / 13)
                        }
                        .accentColor(Color("black"))
                        .offset(y: -2)
                        Capsule()
                            .fill(Color("black"))
                            .frame(width: widthCapsule, height: 2)
                            .offset(x: offsetCapsule - (screenWidth/2), y: 17)
                    }
                    .frame(width: screenWidth - 30, height: 25 + UIScreen.main.bounds.height / 26, alignment: .center)
                    .background(Color("buttonWhite"))
                    .cornerRadius(20)
                    .shadow(color: Color(.black).opacity(0.2), radius: 5, x: 0, y: 4)
                }
                .padding(.bottom, UIScreen.main.bounds.height / 40)
                .scaleEffect(launchScreen ? 0.8 : 1)
                .scaleEffect(tutorialAnimation ? 0.8 : 1)
                .offset(x: tutorialAnimation ? UIScreen.main.bounds.width : 0)
                .animation(.spring())
                if (!showTutorial){
                    StartTutorialView(show: $showTutorial, animation: $tutorialAnimation, filter: filter, launchScreen: $launchScreen).environmentObject(UserObserv())
                        .offset(x: tutorialAnimation ? 0 : -UIScreen.main.bounds.width)
                        .animation(.spring())
                }
                ZStack {
                    Color("greenLaunch")
                        .edgesIgnoringSafeArea(.all)
                        .opacity(launchScreen ? 1 : 0)
                        .animation(.spring())
                    Image("JustLogo")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: launchScreen ? 130 : screenWidth, height: launchScreen ? 130 : screenWidth)
                        .offset(y: launchScreen ? -23.0 : 0)
                        .scaleEffect(1 * launchScale)
                        .animation(.spring())
                }
                .opacity(launchScreen ? 1 : 0)
                .animation(Animation.easeOut(duration: 0.5).delay(0))
            }.edgesIgnoringSafeArea(.bottom)
                .animation(.spring())
                .onAppear(){
                    loadObject()
                    loadObjectFacts()
                    
                    if (!self.isUser2) {
                        self.createUser()
                    } else {
                        self.idLoaded = true
                    }
                    if self.appearenceDark {
                        self.model.isDark = true
                    }else{
                        self.model.isDark = false
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation() {
                            self.launchScreen = false
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                        self.launchScale = 0.8
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.launchScale = 80
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                        self.loadLater = true
                    }
            }
        }
    }
    
    func loadObject() {
        if !objectLoaded {
            filter.addItem(Filter(id: UUID(), icon: "Ernährung", name: "Ernährung", isSelected: true))
            filter.addItem(Filter(id: UUID(), icon: "Transport", name: "Transport", isSelected: true))
            filter.addItem(Filter(id: UUID(), icon: "Haushalt", name: "Haushalt", isSelected: true))
            filter.addItem(Filter(id: UUID(), icon: "Ressourcen", name: "Ressourcen", isSelected: true))
            filter.addItem(Filter(id: UUID(), icon: "Leicht", name: "Leicht", isSelected: true))
            filter.addItem(Filter(id: UUID(), icon: "Mittel", name: "Mittel", isSelected: true))
            filter.addItem(Filter(id: UUID(), icon: "Schwer", name: "Schwer", isSelected: true))
            filter.addItem(Filter(id: UUID(), icon: "Offiziell", name: "Offiziell", isSelected: true))
            filter.addItem(Filter(id: UUID(), icon: "Community", name: "Community", isSelected: true))
            objectLoaded = true
        }
    }
    
    func loadObjectFacts() {
        if !objectLoaded2 {
            filterFacts.addItem(Filter(id: UUID(), icon: "Ernährung", name: "Ernährung", isSelected: true))
            filterFacts.addItem(Filter(id: UUID(), icon: "Transport", name: "Transport", isSelected: true))
            filterFacts.addItem(Filter(id: UUID(), icon: "Haushalt", name: "Haushalt", isSelected: true))
            filterFacts.addItem(Filter(id: UUID(), icon: "Ressourcen", name: "Ressourcen", isSelected: true))
            filterFacts.addItem(Filter(id: UUID(), icon: "Offiziell", name: "Offiziell", isSelected: true))
            filterFacts.addItem(Filter(id: UUID(), icon: "Community", name: "Community", isSelected: true))
            objectLoaded2 = true
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
            self.widthCapsule = 25
            
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
        print("createUser")
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            let userData = PostUser(phoneId: uuid)
            
            guard let encoded = try? JSONEncoder().encode(userData) else {
                print("Failed to encode order")
                return
            }
            guard let url = URL(string: myUrl.users) else { return }
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = encoded
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                if let data = data {
                    if let user = try? JSONDecoder().decode(User.self, from: data) {
                        DispatchQueue.main.async {
                            self.isUser2 = true
                            UserDefaults.standard.set(self.isUser2, forKey: "isUser4")
                            UserDefaults.standard.set(user._id, forKey: "id")
                            self.idLoaded = true
                        }
                        return
                    }
                } else {
                    print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                    return
                }
            }.resume()
        }
    }
}

struct PostUser: Codable {
    var phoneId: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        //        ContentView().environmentObject(UserLevel()).environmentObject(Overlay()).environmentObject(OverlayLog())
        Group {
            ContentView().environmentObject(UserLevel()).environmentObject(Overlay()).environmentObject(OverlayLog()).environmentObject(ChangeFilter()).environmentObject(FilterString()).environmentObject(ApiUrl())
                .previewDevice(PreviewDevice(rawValue: "iPod touch (7th generation))"))
                .previewDisplayName("iPod touch (7th generation)")
//
            ContentView().environmentObject(UserLevel()).environmentObject(Overlay()).environmentObject(OverlayLog()).environmentObject(ChangeFilter()).environmentObject(FilterString()).environmentObject(ApiUrl())
                .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
                .previewDisplayName("iPhone 11")
        }
    }
}
