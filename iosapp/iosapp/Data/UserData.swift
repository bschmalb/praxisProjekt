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
    var level: Int16
    var checkedTipps: [String]
    var savedTipps: [String]
    var checkedChallenges: [String]
    var savedChallenges: [String]
//    var seenTipps: [String]?
//    var seenChallenges: [String]?
    var log: [Log]
}

struct Log: Encodable, Decodable {
    var id: String
    var kilometer: Int
    var meat: Int
    var cooked: Int
    var foodWaste: Int
    var drinks: Int
    var shower: Int
    var binWaste: Int
    var date: String
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
