//
//  TagebuchEntwicklung.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 05.07.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct TagebuchEntwicklung: View {
    
    @State var id = UserDefaults.standard.string(forKey: "id")
    
    @EnvironmentObject var myUrl: ApiUrl
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State var user: User = User(_id: "", phoneId: "", checkedTipps: [], savedTipps: [], savedFacts: [], log: [])
    
    var body: some View {
        ZStack {
            ZStack {
                Color("background")
                    .edgesIgnoringSafeArea(.all)
            }
            
            ScrollView {
                VStack {
                    HStack {
                        Text("Deine Entwicklung")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.leading, 15)
                            .padding(.bottom, 15)
                        Spacer()
                    }
                    .padding(.top, 30.0)
                    
                    VStack (spacing: 30) {
                        EntwicklungGraphView(user: user, graphColor: "cardgreen2", graphTitle: "Gefahrene Kilometer", graphCategory: 0)
                        EntwicklungGraphView(user: user, graphColor: "cardblue2", graphTitle: "Fleischkonsum", graphCategory: 1)
                        EntwicklungGraphView(user: user, graphColor: "cardgreen2", graphTitle: "Essen gekauft", graphCategory: 2)
                        EntwicklungGraphView(user: user, graphColor: "cardpurple2", graphTitle: "Essen weggeschmissen", graphCategory: 3)
                        EntwicklungGraphView(user: user, graphColor: "cardyellow2", graphTitle: "Getränke gekauft", graphCategory: 4)
                        EntwicklungGraphView(user: user, graphColor: "cardturqouise2", graphTitle: "Duschzeit", graphCategory: 5)
                        EntwicklungGraphView(user: user, graphColor: "cardred2", graphTitle: "Mülltrennung", graphCategory: 6)
                            .padding(.bottom, 15)
                    }
                    .animation(.spring())
                    .padding(.leading, 10)
                }
            }
        }
        .gesture(DragGesture()
                    .onChanged({ (value) in
                        if value.translation.width > 40 {
                            self.mode.wrappedValue.dismiss()
                        }
                    }))
        .onAppear {
            getUser()
        }
    }
    
    func getUser() {
        guard let url = URL(string: myUrl.users + (id ?? "")) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            if let data = data {
                if let user = try? JSONDecoder().decode(User.self, from: data) {
                    DispatchQueue.main.async {
                        self.user = user
                    }
                    return
                }
            }
        }
        .resume()
    }
}

struct TagebuchEntwicklung_Previews: PreviewProvider {
    static var previews: some View {
        TagebuchEntwicklung().environmentObject(ApiUrl())
    }
}
