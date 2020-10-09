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
    
    @State var loading2: Bool = true
    
    var screenWidth = UIScreen.main.bounds.width
    
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
                        HStack (spacing: 10){
                            Image(systemName: "arrow.left")
                                .font(.system(size: screenWidth < 500 ? screenWidth * 0.040 : 18, weight: .medium))
                                .foregroundColor(Color("black"))
                            Text("Deine Entwicklung")
                                .font(.system(size: screenWidth < 500 ? screenWidth * 0.040 : 18, weight: .medium))
                                .foregroundColor(Color("black"))
                            Spacer()
                        }
                        .padding(.leading, 20)
                        .padding(.vertical, 10)
                    }
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
                    .padding(.leading, 10)
                    .opacity(loading2 ? 0.01 : 1)
                }
            }
            VStack {
                if (loading2) {
                    VStack{
                        LottieView(filename: "loadingCircle", loop: true)
                            .frame(width: 50, height: 50)
                    }
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self.loading2 = false
            }
        }
    }
}

struct ProfilEntwicklung_Previews: PreviewProvider {
    static var previews: some View {
        ProfilEntwicklung()
    }
}
