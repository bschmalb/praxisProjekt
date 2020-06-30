//
//  TippCard.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 07.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct TippCard: View {
    
//    @ObservedObject var userStore = UserDataStore()
    
    @Binding var isChecked: Bool
    @Binding var isBookmarked: Bool
    var tipp: Tipp
    
    var cardColors2: [String]  = [
        "cardgreen2", "cardblue2", "cardyellow2", "cardpurple2", "cardorange2", "cardred2", "cardturqouise2", "cardyelgre2", "cardpink2"
    ]
    
    var body: some View {
        ZStack {
            VStack{
                Spacer()
                Image("I"+tipp.category)
                    .resizable()
                    .scaledToFit()
                    .frame(minHeight: 100, maxHeight: 200)
                Text(tipp.title)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(Color("alwaysblack"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Button(action: {
                    // What to perform
                }) {
                    Text("Quelle")
                        .foregroundColor(.gray)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                }
                HStack {
                    Button(action: {
                        self.isChecked.toggle()
                        self.addToProfile(tippId: self.tipp.id, method: 0)
                        impact(style: .medium)
                    }) {
                        Image(systemName: "checkmark")
//                            .font(.system(size: 25)
                            .font(Font.system(size: 25, weight: isChecked ? .medium : .regular))
                            .foregroundColor(Color(isChecked ? .white : .black))
                            .padding(20)
                            .padding(.bottom, 10)
                            .padding(.leading, 50)
                        
                    }
                    Spacer()
                    Button(action: {
                        self.isBookmarked.toggle()
                        self.addToProfile(tippId: self.tipp.id, method: 1)
                        impact(style: .medium)
                    }) {
                        Image(systemName: "bookmark")
                            .font(Font.system(size: 25, weight: isBookmarked ? .medium : .regular))
                            .foregroundColor(Color(isBookmarked ? .white : .black))
                            .padding(20)
                            .padding(.bottom, 10)
                            .padding(.trailing, 50)
                    }
                }
                
            }
            .background(Color(cardColors2.randomElement() ?? cardColors2[0]))
                .cornerRadius(15)
            VStack {
                HStack(alignment: .top) {
                    Image(tipp.category)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .opacity(0.1)
                        .padding(.leading, 20)
                        .padding(.vertical)
                    Image(tipp.level)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .opacity(0.1)
                        .padding(.vertical)
                    Spacer()
                }
                Spacer()
            }.frame(width: UIScreen.main.bounds.width - 30, height:
                UIScreen.main.bounds.height / 2.1)
        }.frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height/2.1)
            .onAppear(){
                self.getUserTipps()
        }
    }
    func getUserTipps(){
//        if (userStore.user.checkedTipps.contains(self.tipp.id)) {
//            self.isChecked = true
//        }
//        if (userStore.user.savedTipps.contains(self.tipp.id)) {
//            self.isBookmarked = true
//        }
        
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            guard let url = URL(string: "http://bastianschmalbach.ddns.net/users/" + uuid) else { return }
            let request = URLRequest(url: url)

            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                    return
                }
                DispatchQueue.main.async {
                    if let decodedResponse = try? JSONDecoder().decode(User.self, from: data) {
                        if (decodedResponse.checkedTipps.contains(self.tipp.id) ) {
                            self.isChecked = true
                        }
                        if (decodedResponse.savedTipps.contains(self.tipp.id) ) {
                            self.isBookmarked = true
                        }
                    }
                }
            }.resume()
        }
    }
    
    func addToProfile(tippId: String, method: Int) {
        let patchData = TippPatchCheck(checkedTipps: tippId)
        let patchData2 = TippPatchSave(savedTipps: tippId)
        
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            
            var encoded: Data?
            if (method == 0) {
                encoded = try? JSONEncoder().encode(patchData)
            } else {
                encoded = try? JSONEncoder().encode(patchData2)
            }
            guard let url = URL(string: "http://bastianschmalbach.ddns.net/users/" + uuid) else { return }
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "PATCH"
            request.httpBody = encoded
            
            URLSession.shared.dataTask(with: request) { data, response, error in

            }.resume()
        }
    }
    
}

struct TippPatchCheck : Encodable{
    var checkedTipps: String
}
struct TippPatchSave : Encodable{
    var savedTipps: String
}

struct TippCard_Previews: PreviewProvider {
    static var previews: some View {
        TippCard(isChecked: .constant(false), isBookmarked: .constant(false), tipp: .init(id: "123", title: "Saisonale und Regionale Produkte sind umweltfreundlicher als Bio-Produkte", source: "www.google.com", level: "Leicht", category: "Ernährung", score: 25, postedBy: "123"))
    }
}
