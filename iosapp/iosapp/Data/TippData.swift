//
//  Data.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 05.04.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct Tipp: Codable, Hashable, Identifiable{
    var id = UUID()
    let _id: String
    let title: String
    let source: String
    let level: String
    let category: String
    var score: Int16
    var postedBy: String
    var isChecked: Bool = false
    var isBookmarked: Bool = false
    var official: String
    var __v: Int?
    
    enum CodingKeys: String, CodingKey {
        case _id, title, source, level, category, score, postedBy, official
    }
}

class Api {
    func fetchTipps(completion: @escaping ([Tipp]) -> ()) {
        guard let url = URL(string: "https://sustainablelife.herokuapp.com/tipps?minscore=20") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            
            if let tipps = try? JSONDecoder().decode([Tipp].self, from: data) {
                DispatchQueue.main.async {
                    completion(tipps)
                }
                return
            }
        }
        .resume()
    }
}

struct TippScore: Encodable {
    var maxscore: Int?
    var minscore: Int?
}

class TippApi {
    var tippUrl: String = "https://sustainablelife.herokuapp.com/tipps?"
    
    func fetchAll(filter: [String], completion: @escaping ([Tipp]) -> ()) {
        guard let url = URL(string: tippUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            
            if let tipps = try? JSONDecoder().decode([Tipp].self, from: data) {
                DispatchQueue.main.async {
                    completion(tipps)
                }
                return
            }
        }
        .resume()
    }
    
    func fetchRate(completion: @escaping ([Tipp]) -> ()) {
        let tippScore = TippScore(maxscore: 20)
        guard let encoded = try? JSONEncoder().encode(tippScore) else {
            print("Failed to encode order")
            return
        }
        guard let url = URL(string: tippUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!) else {
            print("can not convert String to URL")
            return
        }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        request.httpBody = encoded

        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else { return }
            
            if let tipps = try? JSONDecoder().decode([Tipp].self, from: data) {
                DispatchQueue.main.async {
                    completion(tipps)
                }
                return
            }
        }
        .resume()
    }
    
    func fetchApproved(filter: [String], completion: @escaping ([Tipp]) -> ()) {
        
        for i in filter {
            if (i == "Ernährung" || i == "Haushalt" || i == "Transport" || i == "Ressourcen") {
                tippUrl.append("category=")
            } else if (i == "Leicht" || i == "Mittel" || i == "Schwer") {
                tippUrl.append("level=")
            } else if (i == "Community" || i == "Offiziell") {
                tippUrl.append("official=")
            }
            tippUrl.append(i)
            if (i != filter[filter.count-1]){
                tippUrl.append("&")
            } else {
                if !tippUrl.contains("category") {
                    tippUrl.append("&")
                    tippUrl.append("category=none")
                }
                if !tippUrl.contains("level") {
                    tippUrl.append("&")
                    tippUrl.append("level=none")
                }
                if !tippUrl.contains("official") {
                    tippUrl.append("&")
                    tippUrl.append("official=none")
                }
            }
        }
        let tippScore = TippScore(minscore: 20)
        guard let encoded = try? JSONEncoder().encode(tippScore) else {
            print("Failed to encode order")
            return
        }
        guard let url = URL(string: tippUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!) else {
            print("can not convert String to URL")
            return
        }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        request.httpBody = encoded

        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else { return }
            
            if let tipps = try? JSONDecoder().decode([Tipp].self, from: data) {
                DispatchQueue.main.async {
                    completion(tipps)
                }
                return
            }
        }
        .resume()
    }
}

struct TippData_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, World!")
    }
}
