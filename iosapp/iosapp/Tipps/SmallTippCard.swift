//
//  SmallTippCard.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 13.09.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct SmallTippCard: View {
    
    @State var id = UserDefaults.standard.string(forKey: "id")
    
    @EnvironmentObject var levelEnv: UserLevel
    @EnvironmentObject var myUrl: ApiUrl
    @EnvironmentObject var changeFilter: ChangeFilter
    
    @ObservedObject var user = UserDataStore()
    
    @Binding var isChecked: Bool
    @Binding var isBookmarked: Bool
    @State var isClicked: Bool = false
    @State var isClicked2: Bool = false
    var tipp: Tipp
    var color: String
    
    @State var user2: User = User(_id: "", phoneId: "", level: 2, checkedTipps: [], savedTipps: [], checkedFacts: [], savedFacts: [], log: [])
    
    @State var reportClicked: Bool = false
    @State var likeClicked: Bool = false
    @State var dislikeClicked: Bool = false
    
    @State var showYouSure: Bool = false
    
    @State var userLevelLocal = 0
    
    @State var quelleShowing = false
    
    @State var options: Bool = false
    
    var cardColors2: [String]  = [
        "cardgreen2", "cardblue2", "cardyellow2", "cardpurple2", "cardorange2", "cardred2", "cardturqouise2", "cardyelgre2", "cardpink2"
    ]
    
    var body: some View {
        ZStack {
            GeometryReader { size in
                ZStack {
                    VStack {
                        HStack(alignment: .top) {
                            Spacer()
                            Button(action: {
                                impact(style: .medium)
                                self.options.toggle()
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 20, weight: Font.Weight.medium))
                                    .padding()
                                    .padding(.top, 10)
                                    .padding(.trailing, 10)
                            }
                        }
                        Spacer()
                    }
                    VStack{
                        Text("Geposted von:")
                            .foregroundColor(.gray)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .padding(.top, 20)
                        HStack{
                            Text("\(user2.name ?? "User")")
                                .multilineTextAlignment(.center)
                                .padding(5)
                                .onAppear(){
                                    self.getPoster()
                                }
                            if (!(user2.hideInfo ?? true)){
                                Text("\(user2.gender ?? "")  \(user2.age ?? "")")
                                    .font(.footnote)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .foregroundColor(Color("alwaysblack"))
                        if (tipp.postedBy == id) {
                            //                            if (false) {
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
                                                changeFilter.changeFilter = true
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
                            HStack (spacing: 20){
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
                                    Image(systemName: likeClicked ? "hand.thumbsup.fill" : "hand.thumbsup")
                                        .font(.system(size: 20, weight: Font.Weight.medium))
                                        .opacity(0.8)
                                        .padding()
                                        .padding(.horizontal, 5)
                                        .cornerRadius(15)
                                }
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
                                    Image(systemName: dislikeClicked ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                                        .font(.system(size: 20, weight: Font.Weight.medium))
                                        .opacity(0.8)
                                        .padding()
                                        .padding(.horizontal, 5)
                                        .cornerRadius(15)
                                }
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
                                    Image(systemName: reportClicked ? "flag.fill" : "flag")
                                        .font(.system(size: 20, weight: Font.Weight.medium))
                                        .foregroundColor(.red)
                                        .opacity(0.8)
                                        .padding()
                                        .padding(.horizontal, 5)
                                        .cornerRadius(15)
                                }
                            }
                        }
                    }.frame(width: size.size.width / 1.3)
                }
                .padding(.leading, 60)
                .frame(maxWidth: UIScreen.main.bounds.width - 30)
                .background(Color.black.opacity(0.05))
                .background(Color(color))
                .cornerRadius(25)
                .gesture(DragGesture()
                            .onChanged({ (value) in
                                self.options = false
                            }))
                .animation(.spring())
            }
                .frame(maxWidth: UIScreen.main.bounds.width - 30)
            
            GeometryReader { size in
                VStack{
                    HStack {
                        Text(tipp.title)
                            .font(.system(size: size.size.width < 400 ? size.size.width * 0.05  - CGFloat(tipp.title.count / 40) : 20))
                            .foregroundColor(Color("alwaysblack"))
//                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.leading)
                            .padding(.top)
                        Spacer()
                        VStack {
                            Button(action: {
                                impact(style: .heavy)
                                self.options.toggle()
                            }) {
                                Image(systemName: "ellipsis")
                                    .font(.system(size: 20, weight: Font.Weight.medium))
                                    .padding(.top, 30)
                                    .padding(.trailing, 25)
                            }
                            Spacer()
                        }
                    }
                    HStack {
                        HStack(alignment: .top) {
                            Image(tipp.category)
                                .resizable()
                                .scaledToFit()
                                .frame(width: size.size.width < 400 ? size.size.width * 0.09 : 40, height: size.size.width < 500 ? size.size.width * 0.09 : 40)
                            Image(tipp.level)
                                .resizable()
                                .scaledToFit()
                                .frame(width: size.size.width < 400 ? size.size.width * 0.09 : 40, height: size.size.width < 500 ? size.size.width * 0.09 : 40)
                            Image(tipp.official)
                                .resizable()
                                .scaledToFit()
                                .frame(width: size.size.width < 400 ? size.size.width * 0.09 : 40, height: size.size.width < 500 ? size.size.width * 0.09 : 40)
                        }.padding(.leading)
                        .foregroundColor(Color("alwaysblack"))
                        Spacer()
                        HStack {
                            Button(action: {
                                self.isChecked.toggle()
                                self.addToProfile(tippId: self.tipp._id, method: 0)
                                self.isClicked = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    self.isClicked = false
                                }
                                
                                self.levelEnv.level += 5
                                UserDefaults.standard.set(self.levelEnv.level, forKey: "userLevel")
                                
                                impact(style: .medium)
                            }) {
                                Image(systemName: isChecked ? "checkmark" : "plus")
                                    .font(Font.system(size: size.size.width < 400 ? size.size.width * 0.07 : 25, weight: isChecked ? .medium : .regular))
                                    .foregroundColor(Color(isChecked ? .white : .black))
                                    .rotationEffect(Angle(degrees: isChecked ? 0 : 180))
                                    .scaleEffect(isClicked ? 2 : 1)
                                    .padding(.vertical)
                                
                            }
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
                                    .font(Font.system(size: size.size.width < 400 ? size.size.width * 0.07 : 25, weight: isBookmarked ? .medium : .regular))
                                    .foregroundColor(Color(isBookmarked ? .white : .black))
                                    .scaleEffect(isClicked2 ? 2 : 1)
                                    .padding()
                                    .padding(.trailing, 10)
                            }
                        }
                    }
                    .padding(.bottom, 5)
                }
                .background(Color(color))
                .cornerRadius(15)
                .offset(x: options ? -size.size.width / 1.3 : 0)
                .animation(.spring())
            }
            .frame(maxWidth: UIScreen.main.bounds.width - 30)
        }
        .accentColor(.black)
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
        guard let url = URL(string: myUrl.users + (id ?? "")) else { return }
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
                    DispatchQueue.main.async {
                        self.user2 = user
                    }
                    return
                }
            }
        }
        .resume()
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
    
    func deleteTipp(){
        guard let url = URL(string: myUrl.tipps + (tipp._id)) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
        }.resume()
    }
}

struct TippPatchSave: Encodable {
    var savedTipps: String
}

struct TippPatchCheck: Encodable {
    var checkedTipps: String
}

struct SmallTippCard_Previews: PreviewProvider {
    static var previews: some View {
        SmallTippCard(isChecked: .constant(false), isBookmarked: .constant(false), tipp: .init(_id: "123", title: "Saisonale und Regionale Produkte sind umweltfreundlicher als Bio-Produkte", source: "www.google.com", level: "Leicht", category: "Ernährung", score: 25, postedBy: "123", official: "Community"), color: "cardgreen2")
            .frame(height: 150)
    }
}
