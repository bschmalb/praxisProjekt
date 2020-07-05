//
//  AllTippData.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 29.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

class AllApi {
    func fetchAllTipps(completion: @escaping ([Tipp]) -> ()) {
        guard let url = URL(string: "http://bastianschmalbach.ddns.net/tipps") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            
            if let allTipps = try? JSONDecoder().decode([Tipp].self, from: data) {
                DispatchQueue.main.async {
                    completion(allTipps)
                }
                print(allTipps)
                return
            }
        }
        .resume()
    }
}
