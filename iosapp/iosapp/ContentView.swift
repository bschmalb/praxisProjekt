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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
