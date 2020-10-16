////
////  ChallengeCard.swift
////  iosapp
////
////  Created by Bastian Schmalbach on 07.06.20.
////  Copyright © 2020 Bastian Schmalbach. All rights reserved.
////
//
//import SwiftUI
//
//struct ChallengeCard: View {
//    
//    //    @ObservedObject var userStore = UserDataStore()
//    
//    @EnvironmentObject var levelEnv: UserLevel
//    @Binding var isChecked: Bool
//    @Binding var isBookmarked: Bool
//    var challenge: Challenge
//    
//    @State var userLevelLocal = 0
//    
//    @State var options: Bool = false
//    
//    var cardColors2: [String]  = [
//        "cardgreen2", "cardblue2", "cardyellow2", "cardpurple2", "cardorange2", "cardred2", "cardturqouise2", "cardyelgre2", "cardpink2"
//    ]
//    
//    var body: some View {
//        ZStack {
//            VStack{
//                Spacer()
//                Image("I"+challenge.category)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(minHeight: 100, maxHeight: 200)
//                Text(challenge.title)
//                    .font(.system(size: 24, weight: .medium))
//                    .foregroundColor(Color("alwaysblack"))
//                    .multilineTextAlignment(.center)
//                    .padding(.horizontal)
//                Button(action: {
//                    // What to perform
//                }) {
//                    Text("\(challenge.participants) weitere nehmen Teil")
//                        .foregroundColor(.gray)
//                        .font(.footnote)
//                        .multilineTextAlignment(.center)
//                        .padding(.top, 5)
//                }
//                HStack {
//                    Button(action: {
//                        self.isChecked.toggle()
//                        self.addToProfile(challengeId: self.challenge.id, method: 0)
//                        
//                        self.levelEnv.level += 5
//                        UserDefaults.standard.set(self.levelEnv.level, forKey: "userLevel")
//                        
//                        impact(style: .medium)
//                    }) {
//                        Image(systemName: "checkmark")
//                            //                            .font(.system(size: 25)
//                            .font(Font.system(size: 25, weight: isChecked ? .medium : .regular))
//                            .foregroundColor(Color(isChecked ? .white : .black))
//                            .padding(20)
//                            .padding(.bottom, 10)
//                            .padding(.leading, 50)
//                        
//                    }
//                    Spacer()
//                    Button(action: {
//                        self.isBookmarked.toggle()
//                        self.addToProfile(challengeId: self.challenge.id, method: 1)
//                        
//                        self.levelEnv.level += 5
//                        UserDefaults.standard.set(self.levelEnv.level, forKey: "userLevel")
//                        
//                        impact(style: .medium)
//                    }) {
//                        Image(systemName: "bookmark")
//                            .font(Font.system(size: 25, weight: isBookmarked ? .medium : .regular))
//                            .foregroundColor(Color(isBookmarked ? .white : .black))
//                            .padding(20)
//                            .padding(.bottom, 10)
//                            .padding(.trailing, 50)
//                    }
//                }
//                
//            }
//            .opacity(options ? 0 : 1)
//            .animation(options ? .easeIn(duration: 0.15) : Animation.easeOut(duration: 0.15).delay(0.15))
//            .background(Color(cardColors2.randomElement() ?? cardColors2[0]))
//            .cornerRadius(15)
//            VStack {
//                HStack(alignment: .top) {
//                    Image(challenge.category)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 30, height: 30)
//                        .opacity(0.1)
//                        .padding(.leading, 20)
//                        .padding(.vertical)
//                    Image(challenge.level)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 30, height: 30)
//                        .opacity(0.1)
//                        .padding(.vertical)
//                    Image(challenge.official ?? "Community")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 30, height: 30)
//                        .opacity(0.1)
//                        .padding(.vertical)
//                    Spacer()
//                    Button(action: {
//                        impact(style: .heavy)
//                        self.options.toggle()
//                    }) {
//                        Text("...")
//                            .font(.system(size: 30, weight: Font.Weight.bold))
//                            .opacity(0.1)
//                            .padding(10)
//                            .padding(.trailing, 15)
//                    }
//                }
//                Spacer()
//            }
//            .frame(width: UIScreen.main.bounds.width - 30, height:
//                UIScreen.main.bounds.height / 2.3)
//                .opacity(options ? 0 : 1)
//                .animation(options ? .easeIn(duration: 0.15) : Animation.easeOut(duration: 0.15).delay(0.15))
//            VStack {
//                HStack(alignment: .top) {
//                    Spacer()
//                    Button(action: {
//                        impact(style: .medium)
//                        self.options.toggle()
//                    }) {
//                        Image(systemName: "xmark")
//                            .font(.system(size: 24, weight: Font.Weight.medium))
//                            .opacity(0.1)
//                            .padding(20)
//                            .padding(.trailing, 5)
//                    }
//                }
//                Spacer()
//                Button(action: {
//                    impact(style: .medium)
//                }) {
//                    HStack (spacing: 20){
//                        Image(systemName: "hand.thumbsup")
//                            .font(.system(size: 20, weight: Font.Weight.medium))
//                            .opacity(0.8)
//                        Text("Positiv bewerten")
//                            .font(.system(size: 18))
//                            .opacity(0.8)
//                    }
//                    .padding()
//                    .padding(.horizontal, 20)
//                    .frame(width: UIScreen.main.bounds.width - 50, height: 55)
//                    .background(Color(.white).opacity(0.2))
//                    .cornerRadius(15)
//                }
//                Button(action: {
//                    impact(style: .medium)
//                }) {
//                    HStack (spacing: 20){
//                        Image(systemName: "hand.thumbsdown")
//                            .font(.system(size: 20, weight: Font.Weight.medium))
//                            .opacity(0.8)
//                        Text("Negativ bewerten")
//                            .font(.system(size: 18))
//                            .opacity(0.8)
//                    }
//                    .padding()
//                    .padding(.horizontal, 20)
//                    .frame(width: UIScreen.main.bounds.width - 50, height: 55)
//                    .background(Color(.white).opacity(0.2))
//                    .cornerRadius(15)
//                }
//                Button(action: {
//                    impact(style: .medium)
//                }) {
//                    HStack (spacing: 20){
//                        Image(systemName: "flag")
//                            .font(.system(size: 20, weight: Font.Weight.medium))
//                            .opacity(0.8)
//                        Text("Diese Challenge melden")
//                            .font(.system(size: 18))
//                            .opacity(0.8)
//                    }
//                    .padding()
//                    .padding(.horizontal, 20)
//                    .frame(width: UIScreen.main.bounds.width - 50, height: 55)
//                    .background(Color(.white).opacity(0.2))
//                    .cornerRadius(15)
//                }
//                Spacer()
//            }.frame(width: UIScreen.main.bounds.width - 30, height:
//                UIScreen.main.bounds.height / 2.3)
//                .rotation3DEffect(Angle(degrees: 180), axis: (x: 0, y: 1, z: 0))
//                .opacity(options ? 1 : 0)
//                .animation(options ? Animation.easeOut(duration: 0.15).delay(0.15) : .easeIn(duration: 0.15))
//            
//        }
//        .rotation3DEffect(Angle(degrees: options ? 180 : 0), axis: (x: 0, y: 1, z: 0))
//        .animation(.spring())
//        .accentColor(.black)
//        .frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height/2.3)
////        .onAppear(){
////            self.getUserChallenges()
////        }
//    }
////    func getUserChallenges(){
////        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
////            guard let url = URL(string: "http://bastianschmalbach.ddns.net/users/" + uuid) else { return }
////            let request = URLRequest(url: url)
////
////            URLSession.shared.dataTask(with: request) { data, response, error in
////                guard let data = data else {
////                    print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
////                    return
////                }
////                DispatchQueue.main.async {
////                    if let decodedResponse = try? JSONDecoder().decode(User.self, from: data) {
////                        if (decodedResponse.checkedChallenges.contains(self.challenge.id) ) {
////                            self.isChecked = true
////                        }
////                        if (decodedResponse.savedChallenges.contains(self.challenge.id) ) {
////                            self.isBookmarked = true
////                        }
////                    }
////                }
////            }.resume()
////        }
////    }
//    
//    func addToProfile(challengeId: String, method: Int) {
//        let patchData = ChallengePatchCheck(checkedChallenges: challengeId)
//        let patchData2 = ChallengePatchSave(savedChallenges: challengeId)
//        
//        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
//            
//            var encoded: Data?
//            if (method == 0) {
//                encoded = try? JSONEncoder().encode(patchData)
//            } else {
//                encoded = try? JSONEncoder().encode(patchData2)
//            }
//            guard let url = URL(string: "https://sustainablelife.herokuapp.com/users/" + uuid) else { return }
//            var request = URLRequest(url: url)
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.httpMethod = "PATCH"
//            request.httpBody = encoded
//            
//            URLSession.shared.dataTask(with: request) { data, response, error in
//                
//            }.resume()
//        }
//    }
//    
//}
//
//struct ChallengePatchCheck : Encodable{
//    var checkedChallenges: String
//}
//struct ChallengePatchSave : Encodable{
//    var savedChallenges: String
//}
//
//struct ChallengeCard_Previews: PreviewProvider {
//    static var previews: some View {
//        ChallengeCard(isChecked: .constant(false), isBookmarked: .constant(false), challenge: .init(id: "123", title: "Saisonale und Regionale Produkte sind umweltfreundlicher als Bio-Produkte", level: "Leicht", category: "Ernährung", score: 25, participants: 0, postedBy: "123"))
//    }
//}
