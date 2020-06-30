//
//  RateTippData.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 15.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

class RateApi {
    func fetchRateTipps(completion: @escaping ([Tipp]) -> ()) {
        guard let url = URL(string: "http://bastianschmalbach.ddns.net/tipps?maxscore=20") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            
            let rateTipps = try! JSONDecoder().decode([Tipp].self, from: data)
            
            DispatchQueue.main.async {
                completion(rateTipps)
            }
        }
    .resume()
    }
}

struct RateTippData_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, World!")
    }
}
