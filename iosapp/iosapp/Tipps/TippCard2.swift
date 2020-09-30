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
    @Binding var isChecked: Bool
    @Binding var isBookmarked: Bool
    @State var isClicked: Bool = false
    @State var isClicked2: Bool = false
    var tipp: Tipp
    
    @State var user2: User = User(_id: "", phoneId: "", level: 2, checkedTipps: [], savedTipps: [], checkedFacts: [], savedFacts: [], log: [])
    
    @State var userLevelLocal = 0
    
    @State var quelleShowing = false
    
    @State var options: Bool = false
    
    @State var reportClicked: Bool = false
    @State var likeClicked: Bool = false
    @State var dislikeClicked: Bool = false
    
    @State var myUrl = "https://www.google.com"
    
//    var cardColors2: [String]  = [
//        "cardgreen2", "cardblue2", "cardyellow2", "cardpurple2", "cardorange2", "cardred2", "cardturqouise2", "cardyelgre2", "cardpink2"
//    ]
    
    var color: String
    
    var body: some View {
        
//        let color = cardColors2.randomElement() ?? cardColors2[0]
        
        return ZStack {
            GeometryReader { size in
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
                                    .onAppear(){
                                        self.getPoster()
                                    }
                                Text("\(user2.gender ?? "")  \(user2.age ?? "")")
                                    .font(.footnote)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color("black"))
                                    .opacity(user2.hideInfo ?? false ? 0 : 1)
                                Spacer()
                                Button(action: {
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
                                }) {
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
                                    .gesture(DragGesture()
                                                .onChanged({ (value) in
                                                    self.options = false
                                                }))
                                }
                            }
                        Spacer()
                            .frame(maxHeight: 5)
                        Button(action: {
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
                        }) {
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
                            .gesture(DragGesture()
                                        .onChanged({ (value) in
                                            self.options = false
                                        }))
                        }
                        Spacer()
                            .frame(maxHeight: 5)
                        Button(action: {
                            impact(style: .medium)
                            if (self.reportClicked) {
                                self.patchScore(thumb: "unreport")
                                self.patchScoreUser(reportedTipps: "unreport")
                            } else {
                                self.patchScore(thumb: "report")
                                self.patchScoreUser(reportedTipps: "unreport")
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
                        }) {
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
                            .gesture(DragGesture()
                                        .onChanged({ (value) in
                                            self.options = false
                                        }))
                            .animation(.spring())
                        }
                        Spacer()
                    }
                    .frame(width: size.size.width / 1.3)
                }
                }
                .frame(width: UIScreen.main.bounds.width > 600 ? 600 - 30 : UIScreen.main.bounds.width - 30, height:
                        UIScreen.main.bounds.height / 2.1)
                .background(Color.black.opacity(0.05))
                .background(Color(color))
                .cornerRadius(25)
                .gesture(DragGesture()
                            .onChanged({ (value) in
                                self.options = false
                            }))
                .animation(.spring())
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
                                    //                            if (self.verifyUrl(urlString: self.tipp.source)){
                                    //                                self.myUrl = self.tipp.source
                                    //                            } else {
                                    //                                self.myUrl = "http://bastianschmalbach.ddns.net/users"
                                    //                            }
                                    //                            self.myUrl = "https://www.youtube.com"
                                    //                            print(self.myUrl)
                                    //                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    //                                self.quelleShowing = true
                                    //                            }
                                    print(String("https://" + self.tipp.source))
                                    self.quelleShowing = true
                                }
                                .sheet(isPresented: $quelleShowing) {
                                    //                        WebLinkView(url: String(self.tipp.source))
                                    QuelleView(quelle: String(self.tipp.source), quelleShowing: self.$quelleShowing)
                                }
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
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
                            }) {
                                Image(systemName: isChecked ? "checkmark" : "plus")
                                    .font(Font.system(size: size.size.width < 500 ? size.size.width * 0.07 : 25, weight: isChecked ? .medium : .regular))
                                    .foregroundColor(Color(isChecked ? .white : .black))
                                    .rotationEffect(Angle(degrees: isChecked ? 0 : 180))
                                    .scaleEffect(isClicked ? 2 : 1)
                                    .animation(.spring())
                                    .padding()
                                
                            }
                            Spacer()
                            Spacer()
                            Button(action: {
                                self.isBookmarked.toggle()
                                self.addToProfile(tippId: self.tipp._id, method: 1)
                                
                                self.isClicked2 = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    self.isClicked2 = false
                                }
                                
                                self.levelEnv.level += 5
                                UserDefaults.standard.set(self.levelEnv.level, forKey: "userLevel")
                                
                                impact(style: .medium)
                            }) {
                                Image(systemName: "bookmark")
                                    .font(Font.system(size: size.size.width < 500 ? size.size.width * 0.07 : 25, weight: isBookmarked ? .medium : .regular))
                                    .foregroundColor(Color(isBookmarked ? .white : .black))
                                    .scaleEffect(isClicked2 ? 2 : 1)
                                    .animation(.spring())
                                    .padding()
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
                            Button(action: {
                                impact(style: .heavy)
                                self.options.toggle()
                            }) {
                                Image(systemName: "ellipsis")
                                    .font(.system(size: size.size.width < 400 ? size.size.width * 0.07 : 25, weight: Font.Weight.medium))
                                    .opacity(0.1)
                                    .padding(25)
                                    .padding(.trailing, 5)
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
        }
        .animation(.spring())
        .accentColor(.black)
        .frame(width: UIScreen.main.bounds.width > 600 ? 600 - 30 : UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height/2.1)
        .onAppear(){
            self.getUserTipps()
        }
    }
    func getUserTipps(){
        guard let url = URL(string: "http://bastianschmalbach.ddns.net/users/" + (id ?? "")) else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            DispatchQueue.main.async {
                if let decodedResponse = try? JSONDecoder().decode(User.self, from: data) {
                    if (decodedResponse.checkedTipps.contains(self.tipp._id) ) {
                        self.isChecked = true
                    }
                    if (decodedResponse.savedTipps.contains(self.tipp._id) ) {
                        self.isBookmarked = true
                    }
                }
            }
        }.resume()
    }
    
    func patchScore(thumb: String) {
        
        let rating = Rate(thumb: thumb)
        
        guard let encoded = try? JSONEncoder().encode(rating) else {
            print("Failed to encode order")
            return
        }
        
        guard let url = URL(string: "http://bastianschmalbach.ddns.net/tipps/" + tipp._id) else { return }
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
        
        guard let url = URL(string: "http://bastianschmalbach.ddns.net/users/" + tipp.postedBy) else { return }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PATCH"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
        }.resume()
    }
    
    func getPoster() {
        guard let url = URL(string: "http://bastianschmalbach.ddns.net/users/" + tipp.postedBy) else { return }
        
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
    
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
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
        guard let url = URL(string: "http://bastianschmalbach.ddns.net/users/" + (id ?? "")) else { return }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PATCH"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
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
