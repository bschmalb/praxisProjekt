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
    
    var factUrl: String = "https://sustainablelife.herokuapp.com/facts?"
    
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
    
    func fetchApproved(filter: [String], completion: @escaping ([Fact]) -> ()) {
        
        for i in filter {
            if (i == "Ernährung" || i == "Haushalt" || i == "Transport" || i == "Ressourcen") {
                factUrl.append("category=")
            } else if (i == "Community" || i == "Offiziell") {
                factUrl.append("official=")
            }
            factUrl.append(i)
            if (i != filter[filter.count-1]){
                factUrl.append("&")
            } else {
                if !factUrl.contains("category") {
                    factUrl.append("&")
                    factUrl.append("category=none")
                }
                if !factUrl.contains("official") {
                    factUrl.append("&")
                    factUrl.append("official=none")
                }
            }
        }
        print(factUrl)
        let tippScore = TippScore(minscore: 20)
        guard let encoded = try? JSONEncoder().encode(tippScore) else {
            print("Failed to encode order")
            return
        }
        guard let url = URL(string: factUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!) else {
            print("can not convert String to URL")
            return
        }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        request.httpBody = encoded

        URLSession.shared.dataTask(with: url) { data, response, error in
            
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
