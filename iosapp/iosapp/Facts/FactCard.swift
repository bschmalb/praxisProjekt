//
//  TippCard2.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 14.09.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct FactCard: View {
    
    @State var isLoved: Bool = false
    @State var isSurprised: Bool = false
    @State var isAngry: Bool = false
    @Binding var isBookmarked: Bool
    @State var fact: Fact
    
    @State var userLevelLocal = 0
    
    @State var quelleShowing = false
    
    @State var options: Bool = false
    
    @State var loading: Bool = false
    
    var color: String
    @State var user: User
    
    @State var user2: User = User(_id: "", phoneId: "", level: 2, checkedTipps: [], savedTipps: [], savedFacts: [], log: [])
    
    var body: some View {
        
        ZStack {
            FactCardBackground(fact: fact, isBookmarked: $fact.isBookmarked, quelleShowing: $quelleShowing, color: color, options: $options, user2: $user2)
            FactCardMain(user2: $user2, fact: fact, isBookmarked: $fact.isBookmarked, quelleShowing: $quelleShowing, color: color, options: $options, user: user)
        }
        .animation(.spring())
        .accentColor(.black)
        .frame(width: UIScreen.main.bounds.width > 600 ? 600 - 30 : UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height/2.1)
//        .onTapGesture(){}
//        .gesture(DragGesture()
//                    .onChanged({ (value) in
//                        self.options = false
//                        print("drag")
//                    }))
    }
}

struct FactCard_Previews: PreviewProvider {
    static var previews: some View {
        FactCard(isBookmarked: .constant(false), fact: .init(_id: "123", title: "Saisonale und Regionale Produkte sind umweltfreundlicher als Bio-Produkte", source: "www.google.com", category: "Ernährung", score: 25, postedBy: "123", official: "Community"), color: "cardblue2", user: User(_id: "", phoneId: "", checkedTipps: [], savedTipps: [], savedFacts: [], log: []))
    }
}

struct FactCardMain: View {
    
    @State var id = UserDefaults.standard.string(forKey: "id")
    
    @EnvironmentObject var changeFilter: ChangeFilter
    @EnvironmentObject var levelEnv: UserLevel
    @EnvironmentObject var myUrl: ApiUrl
    
    
    @Binding var user2: User
    @State var fact: Fact
    @Binding var isBookmarked: Bool
    @Binding var quelleShowing: Bool
    
    var color: String
    @Binding var options: Bool
    @State var isLoved: Bool = false
    @State var isSurprised: Bool = false
    @State var isAngry: Bool = false
    
    @State var loveScale: CGFloat = 1
    @State var surprisedScale: CGFloat = 1
    @State var angryScale: CGFloat = 1
    @State var bookmarkScale: CGFloat = 1
    @State var correctUrl: String = ""
    
    @State var showSourceTextView = false
    
    @State var user: User
    
    var body: some View {
        GeometryReader { size in
            ZStack {
                VStack{
                    Spacer()
                    Image("I"+fact.category)
                        .resizable()
                        .scaledToFit()
                        .frame(minHeight: 30, idealHeight: 200, maxHeight: 300)
                        .drawingGroup()
                    Text(fact.title)
                        .font(.system(size: size.size.width < 500 ? size.size.width * 0.07  - CGFloat(fact.title.count / 25) : 26, weight: .medium))
                        .fixedSize(horizontal: false, vertical: showSourceTextView ? false : true)
                        .foregroundColor(Color("alwaysblack"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    if (showSourceTextView){
                        SourceTextView(source: fact.source, show: $showSourceTextView, color: color)
                    } else {
                        if (fact.source.count > 3) {
                            HStack (spacing: 5){
                                Text("Quelle")
                                    .foregroundColor(.gray)
                                    .font(.system(size: size.size.width * 0.03, weight: .medium))
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 5)
//                                if isURL() {
//                                    Image(systemName: "link")
//                                        .foregroundColor(.gray)
//                                        .font(.system(size: size.size.width * 0.02, weight: .medium))
//                                }
                            }
                            .onTapGesture {
                                impact(style: .medium)
                                self.openSource()
                                }
                                .sheet(isPresented: $quelleShowing) {
                                    QuelleView(quelle: fact.source, quelleShowing: self.$quelleShowing)
                                        .environmentObject(ApiUrl())
                                }
                        }
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        ReactionButton(width: size.size.width, isSelected: $isLoved, scale: $loveScale, emoji: "😍", amount: fact.isLoved, fact: fact)
                        Spacer()
                        ReactionButton(width: size.size.width, isSelected: $isSurprised, scale: $surprisedScale, emoji: "🤯", amount: fact.isSurprised, fact: fact)
                        Spacer()
                        ReactionButton(width: size.size.width, isSelected: $isAngry, scale: $angryScale, emoji: "😠", amount: fact.isAngry, fact: fact)
                        Spacer()
                        Image(systemName: "bookmark")
                            .font(Font.system(size: size.size.width < 500 ? size.size.width * 0.06 : 22, weight: isBookmarked ? .medium : .regular))
                            .foregroundColor(Color(isBookmarked ? .white : .black))
                            .scaleEffect(bookmarkScale)
                            .animation(.spring())
                            .padding(10)
                            .onTapGesture(){
                                self.isBookmarked.toggle()
                                self.addToProfile(tippId: self.fact._id, method: 1)

                                self.bookmarkScale = 1.2
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    self.bookmarkScale = 1
                                }

                                self.levelEnv.level += 5
                                UserDefaults.standard.set(self.levelEnv.level, forKey: "userLevel")

                                impact(style: .medium)
                            }
                        Spacer()
                    }
                    Spacer()
                        .frame(maxHeight: 10)
                    
                }
                VStack {
                    HStack(alignment: .top, spacing: 10) {
                        Image(fact.category)
                            .resizable()
                            .scaledToFit()
                            .frame(width: size.size.width < 500 ? size.size.width * 0.07 : 40, height: size.size.width < 500 ? size.size.width * 0.07 : 40)
                            .opacity(0.1)
                            .padding(.leading, 20)
                            .padding(.vertical)
                        Image(fact.official)
                            .resizable()
                            .scaledToFit()
                            .frame(width: size.size.width < 500 ? size.size.width * 0.07 : 40, height: size.size.width < 500 ? size.size.width * 0.07 : 40)
                            .opacity(0.1)
                            .padding(.vertical)
                        Spacer()
                        Image(systemName: "ellipsis")
                            .font(.system(size: size.size.width < 400 ? size.size.width * 0.07 : 25, weight: Font.Weight.medium))
                            .padding(25)
                            .padding(.trailing, 5)
                            .background(Color(color))
                            .opacity(0.1)
                            .onTapGesture(){
                                impact(style: .heavy)
                                self.options.toggle()
                                self.getPoster()
                            }
                    }.foregroundColor(Color("alwaysblack"))
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width > 600 ? 600 - 30 : UIScreen.main.bounds.width - 30, height:
                        UIScreen.main.bounds.height / 2.1)
            }
            .onTapGesture(perform: {
                options = false
            })
            .background(Color(color))
            .cornerRadius(15)
            .offset(x: options ? -size.size.width / 1.3 : 0)
        }
        .onAppear(){
            getUserTipps()
        }
    }
    
    func isURL() -> Bool {
        if let myUrl = URL(string: fact.source) {
            if (UIApplication.shared.canOpenURL(myUrl)) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func openSource () {
        if isURL() {
            self.quelleShowing = true
        } else {
            self.showSourceTextView = true
        }
    }
    
    func getUserTipps(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if (user.savedFacts != nil) {
                if (user.savedFacts!.contains(self.fact._id) ) {
                    self.isBookmarked = true
                }
            }
        }
    }
    
    
    func getPoster() {
        guard let url = URL(string: myUrl.users + fact.postedBy) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            if let data = data {
                if let user = try? JSONDecoder().decode(User.self, from: data) {
                    DispatchQueue.main.async {
                        self.user2 = user
                    }
                    return
                }
            }
        }
        .resume()
    }
    
    func verifyUrl (urlString: String) {
        if (urlString.contains("http://www.") || urlString.contains("https://www.")){
            self.correctUrl = urlString
        } else if (urlString.contains("www.")){
            self.correctUrl = "http://" + urlString
        } else {
            let temp = "http://www.google.com/search?p=" + urlString
            correctUrl = temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "http://www.google.de"
        }
        print(self.correctUrl)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.quelleShowing = true
        }
    }
    
    func addToProfile(tippId: String, method: Int) {
        let patchData = FactPatchSave(savedFacts: tippId)
        
        var encoded: Data?
        encoded = try? JSONEncoder().encode(patchData)
        
        guard let url = URL(string: myUrl.users + (id ?? "")) else { return }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PATCH"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
        }.resume()
    }
    
    func patchScoreUser(reportedTipps: String) {
        
        let rating = ReportedTipps(reportedTipps: reportedTipps)
        
        guard let encoded = try? JSONEncoder().encode(rating) else {
            print("Failed to encode order")
            return
        }
        
        guard let url = URL(string: myUrl.users + fact.postedBy) else { return }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PATCH"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
        }.resume()
    }
}

struct PatchScoreStruct: Encodable {
    var score: Int
}

struct ReactionButton: View {
    
    @EnvironmentObject var levelEnv: UserLevel
    @EnvironmentObject var myUrl: ApiUrl
    
    var width: CGFloat
    @Binding var isSelected: Bool
    @Binding var scale: CGFloat
    var emoji: String
    @State var amount: Int
    var fact: Fact
    
    @State var lock = false
    
    var body: some View {
        VStack (spacing: 5) {
            Text(emoji)
                .font(Font.system(size: width < 500 ? width * 0.07 : 25, weight: isSelected ? .medium : .regular))
            Text(String(amount))
                .font(Font.system(size: width < 500 ? width * 0.03 : 14))
        }
        .saturation(isSelected ? 1 : 0.5)
        .scaleEffect(isSelected ? scale * 1.1 : scale)
        .padding(10)
        .foregroundColor(.black)
        .onTapGesture(){
            lock = true
            self.isSelected.toggle()
            scale = 1.4
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                scale = 1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if (!isSelected) {
                    self.amount -= 1
                    self.levelEnv.level -= 5
                    UserDefaults.standard.set(self.levelEnv.level, forKey: "userLevel")
                    self.patchScore(emoji: emoji, patchAmount: -1)
                    lock = false
                } else {
                    self.amount += 1
                    self.levelEnv.level += 5
                    UserDefaults.standard.set(self.levelEnv.level, forKey: "userLevel")
                    self.patchScore(emoji: emoji, patchAmount: 1)
                    lock = false
                }
            }
            
            impact(style: .medium)
        }
        .animation(.spring())
        .disabled(lock)
    }
    
    func patchScore(emoji: String, patchAmount: Int) {
        
        var encoded: Data?
        if (emoji == "😍") {
            let patchData = PatchLoved(isLoved: patchAmount)
            encoded = try? JSONEncoder().encode(patchData)
        } else if (emoji == "🤯") {
            let patchData = PatchSurprised(isSurprised: patchAmount)
            encoded = try? JSONEncoder().encode(patchData)
        } else if (emoji == "😠") {
            let patchData = PatchAngry(isAngry: patchAmount)
            encoded = try? JSONEncoder().encode(patchData)
        } else {
            return
        }
        
        guard let url = URL(string: myUrl.facts + fact._id) else { return }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PATCH"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
        }.resume()
    }
    
    struct PatchLoved: Encodable {
        var isLoved: Int
    }
    struct PatchSurprised: Encodable {
        var isSurprised: Int
    }
    struct PatchAngry: Encodable {
        var isAngry: Int
    }
}

struct FactCardBackground: View {

    @State var id = UserDefaults.standard.string(forKey: "id")

    @EnvironmentObject var changeFilter: ChangeFilter
    @EnvironmentObject var levelEnv: UserLevel
    @EnvironmentObject var myUrl: ApiUrl

    var fact: Fact
    @Binding var isBookmarked: Bool
    @Binding var quelleShowing: Bool

    var color: String
    @Binding var options: Bool

    @State var showYouSure: Bool = false

    @State var reportClicked: Bool = false
    @State var likeClicked: Bool = false
    @State var dislikeClicked: Bool = false

    @Binding var user2: User


    var body: some View {
        GeometryReader { size in
            if (options) {
                VStack (spacing: 0){
                    HStack(alignment: .top) {
                        Spacer()
                        Button(action: {
                            impact(style: .medium)
                            self.options.toggle()
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: size.size.width < 500 ? size.size.width * 0.06 : 25, weight: Font.Weight.medium))
                                .opacity(0.1)
                                .padding(.top, 25)
                                .padding(.trailing, 25)
                        }
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        VStack (spacing: 0){
                            Group {
                                Spacer()
                                Text("Geposted von:")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                                if user2.name != nil {
                                    Text("\(user2.name ?? "User")")
                                        .multilineTextAlignment(.center)
                                        .padding(5)
                                    Text("\(user2.gender ?? "")  \(user2.age ?? "")")
                                        .font(.footnote)
                                        .multilineTextAlignment(.center)
                                        .opacity(user2.hideInfo ?? false ? 0 : 1)
                                } else {
                                    VStack {
                                        LottieView(filename: "loadingCircle", loop: true)
                                            .shadow(color: Color(.white), radius: 1, x: 0, y: 0)
                                            .frame(width: 30, height: 30)
                                    }.padding(10)
                                }
                                Spacer()
                            }.foregroundColor(Color("alwaysblack"))
//                            if (fact.postedBy == id) {
//                            if (false) {
//                                Group {
//                                    ZStack {
//                                        HStack {
//                                            Spacer()
//                                            Image(systemName: "trash")
//                                                .font(.system(size: size.size.width < 500 ? size.size.width * 0.05 : 22, weight: Font.Weight.medium))
//                                                .foregroundColor(.red)
//                                                .opacity(0.8)
//                                                .padding(10)
//                                                .onTapGesture(){
//                                                    impact(style: .medium)
//                                                    self.deleteTipp()
//                                                }
//                                            Spacer()
//                                            Image(systemName: "xmark")
//                                                .font(.system(size: size.size.width < 500 ? size.size.width * 0.05 : 22, weight: Font.Weight.medium))
//                                                .opacity(0.8)
//                                                .padding(10)
//                                                .onTapGesture(){
//                                                    impact(style: .medium)
//                                                    self.showYouSure = false
//                                                }
//                                            Spacer()
//                                        }
//                                        .offset(y: showYouSure ? 0 : 30)
//                                        .opacity(showYouSure ? 1 : 0)
//
//                                        HStack (spacing: 20){
//                                            Image(systemName: dislikeClicked ? "trash.fill" : "trash")
//                                                .font(.system(size: size.size.width < 500 ? size.size.width * 0.05 : 22, weight: Font.Weight.medium))
//                                                .foregroundColor(.red)
//                                                .opacity(0.8)
//                                            Text("Tipp löschen")
//                                                .font(.system(size: size.size.width < 500 ? size.size.width * 0.05 : 20))
//                                                .foregroundColor(.red)
//                                                .opacity(0.8)
//                                        }
//                                        .padding(10)
//                                        .offset(y: showYouSure ? -30 : 0)
//                                        .opacity(showYouSure ? 0 : 1)
//                                        .cornerRadius(15)
//                                        .onTapGesture(){
//                                            impact(style: .medium)
//
//                                            self.showYouSure = true
//                                        }
//                                    }.foregroundColor(Color("alwaysblack"))
//                                    .animation(.spring())
//                                    Spacer()
//                                }
//                            } else {
                                Group {
                                    HStack (spacing: 15){
                                        Image(systemName: likeClicked ? "hand.thumbsup.fill" : "hand.thumbsup")
                                            .font(.system(size: size.size.width < 500 ? size.size.width * 0.05 : 22, weight: Font.Weight.medium))
                                            .opacity(0.8)
                                        Text("Positiv bewerten")
                                            .font(.system(size: size.size.width < 500 ? size.size.width * 0.05 : 20))
                                            .opacity(0.8)
                                    }
                                    .padding(10)
                                    .cornerRadius(15)
                                    .onTapGesture(){
                                        impact(style: .medium)
                                        if (self.likeClicked) {
                                            self.patchScore2(score: -1)
                                        } else {
                                            if (self.reportClicked) {
                                                self.reportClicked = false
                                                self.patchScore(thumb: "unreport")
                                            }
                                            if (self.dislikeClicked) {
                                                self.dislikeClicked = false
                                                self.patchScore2(score: 1)
                                            }
                                            self.patchScore2(score: 1)
                                        }
                                        self.likeClicked.toggle()
                                    }
                                    Spacer()
                                        .frame(maxHeight: 5)
                                    HStack (spacing: 20){
                                        Image(systemName: dislikeClicked ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                                            .font(.system(size: size.size.width < 500 ? size.size.width * 0.05 : 22, weight: Font.Weight.medium))
                                            .opacity(0.8)
                                        Text("Negativ bewerten")
                                            .font(.system(size: size.size.width < 500 ? size.size.width * 0.05 : 20))
                                            .opacity(0.8)
                                    }
                                    .padding(10)
                                    .cornerRadius(15)
                                    .onTapGesture(){
                                        impact(style: .medium)

                                        if (!self.dislikeClicked && self.likeClicked) {
                                            self.patchScore2(score: -1)
                                            self.patchScore2(score: -1)
                                        } else if (self.dislikeClicked) {
                                            self.patchScore2(score: 1)
                                        } else {
                                            self.patchScore2(score: -1)
                                        }
                                        self.likeClicked = false
                                        self.dislikeClicked.toggle()
                                    }
                                    Spacer()
                                        .frame(maxHeight: 5)
                                    HStack (spacing: 20){
                                        Image(systemName: reportClicked ? "flag.fill" : "flag")
                                            .font(.system(size: size.size.width < 500 ? size.size.width * 0.05 : 22, weight: Font.Weight.medium))
                                            .foregroundColor(.red)
                                            .opacity(0.8)
                                        Text("Diesen Tipp melden")
                                            .font(.system(size: size.size.width < 500 ? size.size.width * 0.05 : 20))
                                            .foregroundColor(.red)
                                            .opacity(0.8)
                                    }
                                    .padding(10)
                                    .cornerRadius(15)
                                    .animation(.spring())
                                    .onTapGesture(){
                                        impact(style: .medium)
                                        if (self.reportClicked) {
                                            self.patchScore(thumb: "unreport")
                                            self.patchScoreUser(reportedTipps: "unreport")
                                        } else {
                                            self.patchScore(thumb: "report")
                                            self.patchScoreUser(reportedTipps: "report")
                                            if (!self.dislikeClicked) {
                                                self.dislikeClicked = true
                                                self.patchScore2(score: -1)
                                            }
                                            if (self.likeClicked) {
                                                self.likeClicked = false
                                                self.patchScore2(score: -1)
                                            }
                                        }
                                        self.reportClicked.toggle()
                                    }
                                    Spacer()
                                }
                                .foregroundColor(Color("alwaysblack"))
//                            }
                        }
                        .frame(width: size.size.width / 1.3)
                    }
                }
                .frame(width: UIScreen.main.bounds.width > 600 ? 600 - 30 : UIScreen.main.bounds.width - 30, height:
                        UIScreen.main.bounds.height / 2.1)
                .background(Color.black.opacity(0.05))
                .background(Color(color))
                .cornerRadius(25)
                .animation(.spring())
            }
        }
    }

    func patchScore(thumb: String) {

        let rating = Rate(thumb: thumb)

        guard let encoded = try? JSONEncoder().encode(rating) else {
            print("Failed to encode order")
            return
        }

        guard let url = URL(string: myUrl.facts + fact._id) else { return }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PATCH"
        request.httpBody = encoded

        URLSession.shared.dataTask(with: request) { data, response, error in

        }.resume()
    }
    
    func patchScore2(score: Int) {
        
        let rating = PatchScoreStruct(score: score)
        
        guard let encoded = try? JSONEncoder().encode(rating) else {
            print("Failed to encode order")
            return
        }
        
        guard let url = URL(string: myUrl.facts + fact._id) else { return }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PATCH"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
        }.resume()
    }

    func patchScoreUser(reportedTipps: String) {

        let rating = ReportedTipps(reportedTipps: reportedTipps)

        guard let encoded = try? JSONEncoder().encode(rating) else {
            print("Failed to encode order")
            return
        }

        guard let url = URL(string: myUrl.users + fact.postedBy) else { return }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PATCH"
        request.httpBody = encoded

        URLSession.shared.dataTask(with: request) { data, response, error in

        }.resume()
    }

    func deleteTipp(){
        
        self.changeFilter.changeFilter = true
        
        guard let url = URL(string: myUrl.facts + (fact._id)) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
//                self.loading = false
            }
        }.resume()
    }
}
