//
//  Data.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 05.04.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct Tipp: Codable, Hashable{
    let id: String
    let title: String
    let description: String
    let source: String
    let level: String
    let category: String
    let foodType: String
    let score: Int16
}

//struct Tipp: Identifiable, Decodable, Hashable{
//    let id = UUID()
//    let title: String
//    let description: String
//}

class Api : ObservableObject {
    
    @Published var tipps: [Tipp] = [
        .init(id: "", title: "Server Error", description: "Stellen Sie sicher, dass Sie mit dem Internet verbunden sind", source:"", level:"", category:"", foodType:"", score:0),
        .init(id: "", title: "Server Error", description: "Stellen Sie sicher, dass Sie mit dem Internet verbunden sind", source:"", level:"", category:"", foodType:"", score:0),
    ]
    
    
    func fetchTipps(completion: @escaping ([Tipp]) -> ()) {
        print("Api().fetchTipps")
        let apiUrl = "http://bastianschmalbach.ddns.net/tipps"

        guard let url = URL(string: apiUrl) else {
            print("Invalid Url")
            return
            
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Tipp].self, from: data) {
                    DispatchQueue.main.async {
                        self.tipps = decodedResponse
                        completion(self.tipps)
                    }
                    return
                }
            }
            print("Fetch failed:  \(error?.localizedDescription ?? "Unknown Error")")
        }.resume()
    }
    
}

