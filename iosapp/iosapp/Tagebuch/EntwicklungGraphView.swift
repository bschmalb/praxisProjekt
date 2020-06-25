//
//  EntwicklungGraphView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 20.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct EntwicklungGraphView: View {
    
    @State var pickerSelectedItem = 0
    
    var graphColor: String
    var graphLegende: [String] = ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"]
    var graphTitle: String
    
    var body: some View {
        VStack {
            HStack {
                Text(graphTitle).font(.system(size: 24, weight: Font.Weight.medium)).padding(.leading, 15).foregroundColor(Color("black").opacity(0.8))
//                Text("pro Tag")
//                    .font(.caption)
//                    .offset(y: 3)
                Spacer()
//                Picker(selection: $pickerSelectedItem, label: Text("")) {
//                    Text("W").tag(0)
//                    Text("M").tag(1)
//                    Text("J").tag(2)
//                }
//                .pickerStyle(SegmentedPickerStyle())
//                .padding(.leading, 230)
//                .padding(10)
            }
            HStack (spacing: 20){
                BarView(graphColor: graphColor, graphLegende: graphLegende[0], value: 20)
                BarView(graphColor: graphColor, graphLegende: graphLegende[1], value: 180)
                BarView(graphColor: graphColor, graphLegende: graphLegende[2], value: 50)
                BarView(graphColor: graphColor, graphLegende: graphLegende[3], value: 120)
                BarView(graphColor: graphColor, graphLegende: graphLegende[4], value: 200)
                BarView(graphColor: graphColor, graphLegende: graphLegende[5], value: 180)
                BarView(graphColor: graphColor, graphLegende: graphLegende[6], value: 100)
            }
            .animation(.spring())
        }
    }
}

struct EntwicklungGraphView_Previews: PreviewProvider {
    static var previews: some View {
        EntwicklungGraphView(graphColor: "blue", graphTitle: "Fleischkonsum")
    }
}

struct BarView : View {
    
    var graphColor: String
    var graphLegende: String
    var value: CGFloat
    
    var body: some View {
        VStack {
            ZStack (alignment: .bottom) {
                Capsule().frame(width: 30, height: 200).foregroundColor(Color("buttonWhite")).shadow(color: Color(graphColor).opacity(0.1), radius: 5, x: 0, y: 4)
                Capsule().frame(width: 30, height: value).foregroundColor(Color(graphColor))
                
            }
            Text(graphLegende)
                .font(.system(size: 14, weight: Font.Weight.semibold))
                .foregroundColor(Color("black").opacity(0.8))
        }
    }
}
