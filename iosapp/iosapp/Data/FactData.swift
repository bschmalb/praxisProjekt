//
//  FactData.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 11.09.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct Fact: Codable, Hashable, Identifiable{
    let id: String
    let title: String
    let source: String
    let level: String
    let category: String
    var score: Int16
    var postedBy: String
    var isChecked: Bool = false
    var isBookmarked: Bool = false
    var official: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, source, level, category, score, postedBy, official
    }
}

class FactApi {
    func fetchFacts(completion: @escaping ([Fact]) -> ()) {
        guard let url = URL(string: "http://bastianschmalbach.ddns.net/facts") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            
            if let facts = try? JSONDecoder().decode([Fact].self, from: data) {
                DispatchQueue.main.async {
                    completion(facts)
                }
                return
            }
        }
        .resume()
    }
}
