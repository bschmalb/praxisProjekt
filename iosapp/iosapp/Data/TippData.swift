//
//  Data.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 05.04.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct Tipp: Codable, Hashable, Identifiable{
    let id: String
    let title: String
    let source: String
    let level: String
    let category: String
    var score: Int16
}

class Api {
    func fetchTipps(completion: @escaping ([Tipp]) -> ()) {
        guard let url = URL(string: "http://bastianschmalbach.ddns.net/tipps?minscore=20") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            
            let tipps = try! JSONDecoder().decode([Tipp].self, from: data)
            
            DispatchQueue.main.async {
                completion(tipps)
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
