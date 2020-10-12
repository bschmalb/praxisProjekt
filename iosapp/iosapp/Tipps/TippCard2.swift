//
//  TippCard2.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 14.09.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct TippCard2: View {
    
    @State var id = UserDefaults.standard.string(forKey: "id")
    
    @EnvironmentObject var levelEnv: UserLevel
    @EnvironmentObject var changeFilter: ChangeFilter
    @EnvironmentObject var myUrl: ApiUrl
    
    @ObservedObject var user = UserDataStore()
    
    @Binding var isChecked: Bool
    @Binding var isBookmarked: Bool
    @State var isClicked: Bool = false
    @State var isClicked2: Bool = false
    @State var tipp: Tipp
    
    @State var user2: User = User(_id: "", phoneId: "", level: 2, checkedTipps: [], savedTipps: [], checkedFacts: [], savedFacts: [], log: [])
    
    @State var userLevelLocal = 0
    
    @State var quelleShowing = false
    
    @State var options: Bool = false
    
    @State var loading: Bool = false
    
    @State var reportClicked: Bool = false
    @State var likeClicked: Bool = false
    @State var dislikeClicked: Bool = false
    
    @State var correctUrl: String = ""
    
    @State var showYouSure: Bool = false
    
    var color: String
    
    var body: some View {
        
        ZStack {
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
                                        .foregroundColor(.secondary)
                                        .font(.caption)
                                        .multilineTextAlignment(.center)
                                    Text("\(user2.name ?? "User")")
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color("black"))
                                        .padding(5)
                                    Text("\(user2.gender ?? "")  \(user2.age ?? "")")
                                        .font(.footnote)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color("black"))
                                        .opacity(user2.hideInfo ?? false ? 0 : 1)
                                    Spacer()
                                }
                                if (tipp.postedBy == id) {
                                    Group {
                                        ZStack {
                                            HStack {
                                                Spacer()
                                                Image(systemName: "trash")
                                                    .font(.system(size: size.size.width < 500 ? size.size.width * 0.05 : 22, weight: Font.Weight.medium))
                                                    .foregroundColor(.red)
                                                    .opacity(0.8)
                                                    .padding(10)
                                                    .onTapGesture(){
                                                        impact(style: .medium)
                                                        self.loading = true
                                                        self.deleteTipp()
                                                    }
                                                Spacer()
                                                Image(systemName: "xmark")
                                                    .font(.system(size: size.size.width < 500 ? size.size.width * 0.05 : 22, weight: Font.Weight.medium))
                                                    .opacity(0.8)
                                                    .padding(10)
                                                    .onTapGesture(){
                                                        impact(style: .medium)
                                                        self.showYouSure = false
                                                    }
                                                Spacer()
                                            }
                                            .offset(y: showYouSure ? 0 : 30)
                                            .opacity(showYouSure ? 1 : 0)
                                            
                                            HStack (spacing: 20){
                                                Image(systemName: dislikeClicked ? "trash.fill" : "trash")
                                                    .font(.system(size: size.size.width < 500 ? size.size.width * 0.05 : 22, weight: Font.Weight.medium))
                                                    .foregroundColor(.red)
                                                    .opacity(0.8)
                                                Text("Tipp löschen")
                                                    .font(.system(size: size.size.width < 500 ? size.size.width * 0.05 : 20))
                                                    .foregroundColor(.red)
                                                    .opacity(0.8)
                                            }
                                            .padding(10)
                                            .offset(y: showYouSure ? -30 : 0)
                                            .opacity(showYouSure ? 0 : 1)
                                            .cornerRadius(15)
                                            .onTapGesture(){
                                                impact(style: .medium)
                                                
                                                self.showYouSure = true
                                            }
                                        }
                                        .animation(.spring())
                                        Spacer()
                                    }
                                } else {
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
                                                self.patchScore(thumb: "down")
                                            } else {
                                                if (self.reportClicked) {
                                                    self.reportClicked = false
                                                    self.patchScore(thumb: "unreport")
                                                }
                                                if (self.dislikeClicked) {
                                                    self.dislikeClicked = false
                                                    self.patchScore(thumb: "up")
                                                }
                                                self.patchScore(thumb: "up")
                                            }
                                            self.likeClicked.toggle()
                                        }
                                        .onTapGesture(){}
                                        .gesture(DragGesture()
                                                    .onChanged({ (value) in
                                                        self.options = false
                                                    }))
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
                                                self.patchScore(thumb: "down")
                                                self.patchScore(thumb: "down")
                                            } else if (self.dislikeClicked) {
                                                self.patchScore(thumb: "up")
                                            } else {
                                                self.patchScore(thumb: "down")
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
                                                    self.patchScore(thumb: "down")
                                                }
                                                if (self.likeClicked) {
                                                    self.likeClicked = false
                                                    self.patchScore(thumb: "down")
                                                }
                                            }
                                            self.reportClicked.toggle()
                                        }
                                        Spacer()
                                    }
                                }
                            }
                            .frame(width: size.size.width / 1.3)
                            .gesture(DragGesture()
                                        .onChanged({ (value) in
                                            self.options = false
                                        }))
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width > 600 ? 600 - 30 : UIScreen.main.bounds.width - 30, height:
                            UIScreen.main.bounds.height / 2.1)
                    .background(Color.black.opacity(0.05))
                    .background(Color(color))
                    .cornerRadius(25)
                    .onTapGesture(){}
                    .gesture(DragGesture()
                                .onChanged({ (value) in
                                    self.options = false
                                }))
                    .animation(.spring())
                }
            }
            GeometryReader { size in
                ZStack {
                    VStack{
                        Spacer()
                        Image("I"+tipp.category)
                            .resizable()
                            .scaledToFit()
                            .frame(minHeight: 100, idealHeight: 200, maxHeight: 300)
                            .drawingGroup()
                        Text(tipp.title)
                            .font(.system(size: size.size.width < 500 ? size.size.width * 0.07  - CGFloat(tipp.title.count / 25) : 26, weight: .medium))
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(Color("alwaysblack"))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        if (tipp.source.count > 3) {
                            Text("Quelle")
                                .foregroundColor(.gray)
                                .font(.system(size: size.size.width * 0.03, weight: .medium))
                                .multilineTextAlignment(.center)
                                .padding(.top, 5)
                                .onTapGesture {
                                    self.verifyUrl(urlString: tipp.source)
                                }
                                .sheet(isPresented: $quelleShowing) {
                                    QuelleView(quelle: correctUrl, quelleShowing: self.$quelleShowing)
                                }
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: isChecked ? "checkmark" : "plus")
                                .font(Font.system(size: size.size.width < 500 ? size.size.width * 0.07 : 25, weight: isChecked ? .medium : .regular))
                                .foregroundColor(Color(isChecked ? .white : .black))
                                .rotationEffect(Angle(degrees: isChecked ? 0 : 180))
                                .scaleEffect(isClicked ? 2 : 1)
                                .animation(.spring())
                                .padding()
                                .onTapGesture(){
                                    self.isChecked.toggle()
                                    self.addToProfile(tippId: self.tipp._id, method: 0)
                                    self.patchScore(thumb: "up")
                                    self.isClicked = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        self.isClicked = false
                                    }
                                    
                                    self.levelEnv.level += 5
                                    UserDefaults.standard.set(self.levelEnv.level, forKey: "userLevel")
                                    
                                    impact(style: .medium)
                                }
                            Spacer()
                            Spacer()
                            Image(systemName: "bookmark")
                                .font(Font.system(size: size.size.width < 500 ? size.size.width * 0.07 : 25, weight: isBookmarked ? .medium : .regular))
                                .foregroundColor(Color(isBookmarked ? .white : .black))
                                .scaleEffect(isClicked2 ? 2 : 1)
                                .animation(.spring())
                                .padding()
                                .onTapGesture(){
                                    self.isBookmarked.toggle()
                                    self.addToProfile(tippId: self.tipp._id, method: 1)
                                    
                                    self.isClicked2 = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        self.isClicked2 = false
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
                        HStack(alignment: .top) {
                            Image(tipp.category)
                                .resizable()
                                .scaledToFit()
                                .frame(width: size.size.width < 500 ? size.size.width * 0.09 : 40, height: size.size.width < 500 ? size.size.width * 0.09 : 40)
                                .opacity(0.1)
                                .padding(.leading, 20)
                                .padding(.vertical)
                            Image(tipp.level)
                                .resizable()
                                .scaledToFit()
                                .frame(width: size.size.width < 500 ? size.size.width * 0.09 : 40, height: size.size.width < 500 ? size.size.width * 0.09 : 40)
                                .opacity(0.1)
                                .padding(.vertical)
                            Image(tipp.official)
                                .resizable()
                                .scaledToFit()
                                .frame(width: size.size.width < 500 ? size.size.width * 0.09 : 40, height: size.size.width < 500 ? size.size.width * 0.09 : 40)
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
                        }
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width > 600 ? 600 - 30 : UIScreen.main.bounds.width - 30, height:
                            UIScreen.main.bounds.height / 2.1)
                }
                .background(Color(color))
                .cornerRadius(15)
                .offset(x: options ? -size.size.width / 1.3 : 0)
            }
            .onTapGesture(){}
            .gesture(DragGesture()
                        .onChanged({ (value) in
                            self.options = false
                        }))
            if loading {
                VStack {
                    LottieView(filename: "loadingCircle", loop: true)
                        .frame(width: 80, height: 80)
                        .background(Color("white"))
                        .cornerRadius(50)
                }
                .frame(width: 150, height: 150)
                .background(Color("white"))
                .cornerRadius(50)
                .shadow(radius: 5)
                .animation(.spring())
            }
        }
        .animation(.spring())
        .accentColor(.black)
        .frame(width: UIScreen.main.bounds.width > 600 ? 600 - 30 : UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height/2.1)
        .onAppear(){
            self.getUserTipps()
        }
    }
    func getUserTipps(){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if (user.user.checkedTipps.contains(self.tipp._id) ) {
                self.isChecked = true
            }
            if (user.user.savedTipps.contains(self.tipp._id) ) {
                self.isBookmarked = true
            }
        }
    }
    
    func patchScore(thumb: String) {
        
        let rating = Rate(thumb: thumb)
        
        guard let encoded = try? JSONEncoder().encode(rating) else {
            print("Failed to encode order")
            return
        }
        
        guard let url = URL(string: myUrl.tipps + tipp._id) else { return }
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
        
        guard let url = URL(string: myUrl.users + tipp.postedBy) else { return }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PATCH"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
        }.resume()
    }
    
    func getPoster() {
        guard let url = URL(string: myUrl.users + tipp.postedBy) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            if let data = data {
                if let user = try? JSONDecoder().decode(User.self, from: data) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        self.user2 = user
                    }
                    
                    // everything is good, so we can exit
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
        let patchData = TippPatchCheck(checkedTipps: tippId)
        let patchData2 = TippPatchSave(savedTipps: tippId)
        
        var encoded: Data?
        if (method == 0) {
            encoded = try? JSONEncoder().encode(patchData)
        } else {
            encoded = try? JSONEncoder().encode(patchData2)
        }
        guard let url = URL(string: myUrl.users + (id ?? "")) else { return }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PATCH"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
        }.resume()
    }
    
    func deleteTipp(){
        
        self.changeFilter.changeFilter = true
        
        guard let url = URL(string: myUrl.tipps + (tipp._id)) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.loading = false
            }
        }.resume()
    }
}

struct ReportedTipps: Encodable, Decodable {
    var reportedTipps: String
}

struct TippCard2_Previews: PreviewProvider {
    static var previews: some View {
        TippCard2(isChecked: .constant(false), isBookmarked: .constant(false), tipp: .init(_id: "123", title: "Saisonale und Regionale Produkte sind umweltfreundlicher als Bio-Produkte", source: "www.google.com", level: "Leicht", category: "Ernährung", score: 25, postedBy: "123", official: "Community"), color: "cardblue2")
    }
}
