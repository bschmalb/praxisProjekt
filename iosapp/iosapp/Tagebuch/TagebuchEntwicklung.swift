//
//  TagebuchEntwicklung.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 05.07.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct TagebuchEntwicklung: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
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
                        EntwicklungGraphView(graphColor: "cardgreen2", graphTitle: "Gefahrene Kilometer", graphCategory: 0)
                        EntwicklungGraphView(graphColor: "cardblue2", graphTitle: "Fleischkonsum", graphCategory: 1)
                        EntwicklungGraphView(graphColor: "cardgreen2", graphTitle: "Essen gekauft", graphCategory: 2)
                        EntwicklungGraphView(graphColor: "cardpurple2", graphTitle: "Essen weggeschmissen", graphCategory: 3)
                        EntwicklungGraphView(graphColor: "cardyellow2", graphTitle: "Getränke gekauft", graphCategory: 4)
                        EntwicklungGraphView(graphColor: "cardturqouise2", graphTitle: "Duschzeit", graphCategory: 5)
                        EntwicklungGraphView(graphColor: "cardred2", graphTitle: "Mülltrennung", graphCategory: 6)
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
    }
}

struct TagebuchEntwicklung_Previews: PreviewProvider {
    static var previews: some View {
        TagebuchEntwicklung()
    }
}
