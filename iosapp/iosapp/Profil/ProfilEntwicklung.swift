//
//  ProfilEntwicklung.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 28.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct ProfilEntwicklung: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            Color("background")
                .edgesIgnoringSafeArea(.all)
            VStack {
                ScrollView (.vertical) {
                    Button(action: {
                        self.mode.wrappedValue.dismiss()
                        impact(style: .medium)
                    }) {
                        HStack (spacing: 20){
                            Image(systemName: "arrow.left.circle")
                                .font(.system(size: 24))
                                .foregroundColor(Color("black"))
                            Text("Deine Entwicklung")
                                .font(.system(size: 22))
                                .fontWeight(.medium)
                                .foregroundColor(Color("black"))
                            Spacer()
                        }
                        .padding(15)
                    }
                    VStack (spacing: 30) {
                        EntwicklungGraphView(graphColor: "cardgreen2", graphTitle: "Gefahrene Kilometer", graphCategory: 0)
                        EntwicklungGraphView(graphColor: "cardblue2", graphTitle: "Fleischkonsum", graphCategory: 1)
                        EntwicklungGraphView(graphColor: "cardgreen2", graphTitle: "Selbst zubereitet", graphCategory: 2)
                        EntwicklungGraphView(graphColor: "cardpurple2", graphTitle: "Essen weggeschmissen", graphCategory: 3)
                        EntwicklungGraphView(graphColor: "cardyellow2", graphTitle: "Getränke gekauft", graphCategory: 4)
                        EntwicklungGraphView(graphColor: "cardturqouise2", graphTitle: "Duschzeit", graphCategory: 5)
                        EntwicklungGraphView(graphColor: "cardred2", graphTitle: "Mülltrennung", graphCategory: 6)
                            .padding(.bottom, 15)
                    }
                }
            }
            .padding(.top, 15)
        }
        .gesture(DragGesture()
                    .onChanged({ (value) in
                        if value.translation.width > 40 {
                            self.mode.wrappedValue.dismiss()
                        }
                    }))
        .onAppear {
            impact(style: .medium)
        }
    }
}

struct ProfilEntwicklung_Previews: PreviewProvider {
    static var previews: some View {
        ProfilEntwicklung()
    }
}
