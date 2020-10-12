//
//  FactData.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 11.09.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct Fact: Codable, Hashable, Identifiable{
    var id = UUID()
    let _id: String
    let title: String
    let source: String
    let category: String
    var isLoved: Int = 0
    var isSurprised: Int = 0
    var isAngry: Int = 0
    var score: Int
    var postedBy: String
    var isChecked: Bool = false
    var isBookmarked: Bool = false
    var official: String
    var __v: Int?
    
    enum CodingKeys: String, CodingKey {
        case _id, title, source, category, isLoved, isSurprised, isAngry, score, postedBy, official
    }
}

class FactApi {
    func fetchAll(completion: @escaping ([Fact]) -> ()) {
        guard let url = URL(string: "https://sustainablelife.herokuapp.com/facts") else { return }
        
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
    
    func fetchRate(completion: @escaping ([Fact]) -> ()) {
        guard let url = URL(string: "https://sustainablelife.herokuapp.com/facts?maxscore=20") else { return }
        
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
    
    func fetchApproved(completion: @escaping ([Fact]) -> ()) {
        guard let url = URL(string: "https://sustainablelife.herokuapp.com/facts?minscore=20") else { return }
        
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
