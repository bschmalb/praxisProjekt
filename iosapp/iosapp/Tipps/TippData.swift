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
//    var show: Bool
}

class Api {
    func fetchTipps(completion: @escaping ([Tipp]) -> ()) {
        guard let url = URL(string: "http://bastianschmalbach.ddns.net/tipps") else { return }
        
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

//class Api : ObservableObject {
//
//    @Published var tipps: [Tipp] = [
//        .init(id: "", title: "Server Error", source:"", level:"", category:"", score:0, show: false),
//        .init(id: "", title: "Server Error", source:"", level:"", category:"", score:0, show: false),
//    ]
//
//
//    func fetchTipps(completion: @escaping ([Tipp]) -> ()) {
//        print("Api().fetchTipps")
//        let apiUrl = "http://bastianschmalbach.ddns.net/tipps"
//
//        guard let url = URL(string: apiUrl) else {
//            print("Invalid Url")
//            return
//
//        }
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if let data = data {
//                if let decodedResponse = try? JSONDecoder().decode([Tipp].self, from: data) {
//                    DispatchQueue.main.async {
//                        self.tipps = decodedResponse
//                        print(self.tipps)
//                        completion(self.tipps)
//                    }
//                    return
//                }
//            }
//            print("Fetch failed:  \(error?.localizedDescription ?? "Unknown Error")")
//        }.resume()
//    }
//
//}

struct TippData_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
