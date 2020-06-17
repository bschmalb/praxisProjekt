//
//  ContentView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 25.03.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import CoreHaptics
//import SwiftUIPager
import SwiftUI

func haptic(type: UINotificationFeedbackGenerator.FeedbackType) {
    UINotificationFeedbackGenerator().notificationOccurred(type)
}

struct ToggleModel {
    var isDark: Bool = false {
        didSet { SceneDelegate.shared?.window!.overrideUserInterfaceStyle = isDark ? .dark : .light }
    }
}

struct ContentView: View {
    
    @State var model = ToggleModel()
    
    var body: some View {
        TabView {
            TippView()
                .tabItem {
                    Image(systemName: "lightbulb")
                    Text("Tipps")
            }
            VStack {
                Text("Hallo")
            }.tabItem {
                Image(systemName: "person.3")
                Text("Challenges")
            }
            VStack {
                TagebuchView()
            }.tabItem {
                Image(systemName: "book")
                Text("Tagebuch")
            }
            VStack {
                ProfilView()
            }.tabItem {
                Image(systemName: "person")
                Text("Profil")
            }
        }.accentColor(.primary)
        .onAppear(){
            self.createUser()
        }
    }
    func createUser(){
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            let userData = User(id: uuid, name: "", checkedTipps: [], savedTipps: [], checkedChallenges: [], savedChallenges: [])
            
            guard let encoded = try? JSONEncoder().encode(userData) else {
                print("Failed to encode order")
                return
            }
            guard let url = URL(string: "http://bastianschmalbach.ddns.net/users") else { return }
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = encoded
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                    return
                }
                print(data)
            }.resume()
        }
    }
}

struct User: Encodable {
    var id: String
    var name: String
    var checkedTipps: [String]
    var savedTipps: [String]
    var checkedChallenges: [String]
    var savedChallenges: [String]
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
