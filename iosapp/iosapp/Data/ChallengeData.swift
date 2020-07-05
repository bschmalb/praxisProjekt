//
//  Data.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 05.04.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct Challenge: Codable, Hashable, Identifiable{
    let id: String
    let title: String
    let level: String
    let category: String
    var score: Int16
    var participants: Int16
    var postedBy: String?
    var isChecked: Bool = false
    var isBookmarked: Bool = false
    var official: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, level, category, score, participants, postedBy, official
    }
}

class ChallengeApi {
    func fetchChallenges(completion: @escaping ([Challenge]) -> ()) {
        guard let url = URL(string: "http://bastianschmalbach.ddns.net/challenges?minscore=20") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            
            if let challenges = try? JSONDecoder().decode([Challenge].self, from: data) {
                DispatchQueue.main.async {
                    completion(challenges)
                }
                return
            }
        }
        .resume()
    }
}

struct ChallengeData_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, World!")
    }
}
