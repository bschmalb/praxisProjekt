//
//  UserData.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 28.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct User: Encodable, Decodable {
    var id: String
    var name: String
    var checkedTipps: [String]
    var savedTipps: [String]
    var checkedChallenges: [String]
    var savedChallenges: [String]
//    var seenTipps: [String]?
//    var seenChallenges: [String]?
//    var tagebuch: [Eintrag]?
}

struct Eintrag: Encodable, Decodable {
    var kilometer: Int8
    var meat: Int8
    var cooked: Int8
    var foodWaste: Int8
    var drinks: Int8
    var shower: Int8
    var binWaste: Int8
}

class UserApi {
    func fetchUser(completion: @escaping (User) -> ()) {
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            
            guard let url = URL(string: "http://bastianschmalbach.ddns.net/users/" + uuid) else { return }
            
            URLSession.shared.dataTask(with: url) { (data, _, _) in
                
                if let data = data {
                    if let user = try? JSONDecoder().decode(User.self, from: data) {
                        // we have good data – go back to the main thread
                        DispatchQueue.main.async {
                            // update our UI
                            completion(user)
                        }

                        // everything is good, so we can exit
                        return
                    }
                }
            }
            .resume()
        }
    }
}

struct UserData_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello World")
    }
}
