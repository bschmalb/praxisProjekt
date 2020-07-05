//
//  EntwicklungGraphView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 20.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct EntwicklungGraphView: View {
    
    @ObservedObject var store = UserDataStore()
    
    @State var pickerSelectedItem = 0
    
    var graphColor: String
    var graphTitle: String
    var graphCategory: Int
    
    var graphLegende: [String] = ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"]
    
    var body: some View {
        VStack {
            HStack {
                Text(graphTitle).font(.system(size: 24, weight: Font.Weight.medium)).padding(.leading, 15).foregroundColor(Color("black").opacity(0.8))
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
            HStack {
                ChartView()
            }
        }
    }
    func ChartView() -> some View {
        let showIndex = store.user.log.count - 7
        
        switch graphCategory {
        case 0: return AnyView(
            HStack {
            GraphLegende()
            HStack (spacing: 20) {
                ForEach(0..<7) { index in
                    HStack {
                        if (self.store.user.log.count > 6) {
                            BarView(graphColor: self.graphColor, graphLegende: self.graphLegende[index], value: CGFloat(self.store.user.log[showIndex + index].kilometer * 45 + 20))
                        }
                        else if (self.store.user.log.count > index) {
                            BarView(graphColor: self.graphColor, graphLegende: self.graphLegende[index], value: CGFloat(self.store.user.log[index].kilometer * 45 + 20))
                        }
                        else {
                            BarView(graphColor: "gray", graphLegende: self.graphLegende[index], value: 5)
                        }
                    }
                }
            }
            }
            )
        case 1: return AnyView(
            HStack {
            GraphLegende()
            HStack (spacing: 20) {
                ForEach(0..<7) { index in
                    HStack {
                        if (self.store.user.log.count > 6) {
                            BarView(graphColor: self.graphColor, graphLegende: self.graphLegende[index], value: CGFloat(self.store.user.log[showIndex + index].meat * 45 + 20))
                        }
                        else if (self.store.user.log.count > index) {
                            BarView(graphColor: self.graphColor, graphLegende: self.graphLegende[index], value: CGFloat(self.store.user.log[index].meat * 45 + 20))
                        }
                        else {
                            BarView(graphColor: "gray", graphLegende: self.graphLegende[index], value: 5)
                        }
                    }
                }
                }
            }
            )
        case 2: return AnyView(
            HStack {
                GraphLegende()
                HStack (spacing: 20) {
                    ForEach(0..<7) { index in
                        HStack {
                            if (self.store.user.log.count > 6) {
                                BarView(graphColor: self.graphColor, graphLegende: self.graphLegende[index], value: CGFloat(self.store.user.log[showIndex + index].cooked * 45 + 20))
                            }
                            else if (self.store.user.log.count > index) {
                                BarView(graphColor: self.graphColor, graphLegende: self.graphLegende[index], value: CGFloat(self.store.user.log[index].cooked * 45 + 20))
                            }
                            else {
                                BarView(graphColor: "gray", graphLegende: self.graphLegende[index], value: 5)
                            }
                        }
                    }
                }
            }
            )
        case 3: return AnyView(
            HStack {
                GraphLegende()
                HStack (spacing: 20) {
                    ForEach(0..<7) { index in
                        HStack {
                            if (self.store.user.log.count > 6) {
                                BarView(graphColor: self.graphColor, graphLegende: self.graphLegende[index], value: CGFloat(self.store.user.log[showIndex + index].foodWaste * 45 + 20))
                            }
                            else if (self.store.user.log.count > index) {
                                BarView(graphColor: self.graphColor, graphLegende: self.graphLegende[index], value: CGFloat(self.store.user.log[index].foodWaste * 45 + 20))
                            }
                            else {
                                BarView(graphColor: "gray", graphLegende: self.graphLegende[index], value: 5)
                            }
                        }
                    }
                }
            }
            )
        case 4: return AnyView(
            HStack {
                GraphLegende()
                HStack (spacing: 20) {
                    ForEach(0..<7) { index in
                        HStack {
                            if (self.store.user.log.count > 6) {
                                BarView(graphColor: self.graphColor, graphLegende: self.graphLegende[index], value: CGFloat(self.store.user.log[showIndex + index].drinks * 45 + 20))
                            }
                            else if (self.store.user.log.count > index) {
                                BarView(graphColor: self.graphColor, graphLegende: self.graphLegende[index], value: CGFloat(self.store.user.log[index].drinks * 45 + 20))
                            }
                            else {
                                BarView(graphColor: "gray", graphLegende: self.graphLegende[index], value: 5)
                            }
                        }
                    }
                }
            }
            )
        case 5: return AnyView(
            HStack {
                GraphLegendeShower()
                HStack (spacing: 20) {
                    ForEach(0..<7) { index in
                        HStack {
                            if (self.store.user.log.count > 6) {
                                BarView(graphColor: self.graphColor, graphLegende: self.graphLegende[index], value: CGFloat(self.store.user.log[showIndex + index].shower * 45 + 20))
                            }
                            else if (self.store.user.log.count > index) {
                                BarView(graphColor: self.graphColor, graphLegende: self.graphLegende[index], value: CGFloat(self.store.user.log[index].shower * 45 + 20))
                            }
                            else {
                                BarView(graphColor: "gray", graphLegende: self.graphLegende[index], value: 5)
                            }
                        }
                    }
                }
            }
            )
        case 6: return AnyView(
            HStack {
                GraphLegendeBinWaste()
                HStack (spacing: 20) {
                    ForEach(0..<7) { index in
                        HStack {
                            if (self.store.user.log.count > 6) {
                                BarView(graphColor: self.graphColor, graphLegende: self.graphLegende[index], value: CGFloat(self.store.user.log[showIndex + index].binWaste * 90 + 20))
                            }
                            else if (self.store.user.log.count > index) {
                                BarView(graphColor: self.graphColor, graphLegende: self.graphLegende[index], value: CGFloat(self.store.user.log[index].binWaste * 90 + 20))
                            }
                            else {
                                BarView(graphColor: "gray", graphLegende: self.graphLegende[index], value: 5)
                            }
                        }
                    }
                }
            }
            )
        default: return AnyView(
            ForEach(0..<7) { index in
                BarView(graphColor: self.graphColor, graphLegende: self.graphLegende[index], value: 1)
            }
            )
        }
    }
}

struct EntwicklungGraphView_Previews: PreviewProvider {
    static var previews: some View {
        EntwicklungGraphView(graphColor: "blue", graphTitle: "Fleischkonsum", graphCategory: 6)
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
                .font(.system(size: 12, weight: Font.Weight.semibold))
                .fixedSize(horizontal: true, vertical: false)
                .foregroundColor(Color("black").opacity(0.8))
        }
    }
}

struct GraphLegende: View {
    var body: some View {
        VStack (spacing: 30){
            Text("4+")
                .font(.system(size: 12, weight: Font.Weight.semibold))
            Text("3")
                .font(.system(size: 12, weight: Font.Weight.semibold))
            Text("2")
                .font(.system(size: 12, weight: Font.Weight.semibold))
            Text("1")
                .font(.system(size: 12, weight: Font.Weight.semibold))
            Text("0")
                .font(.system(size: 12, weight: Font.Weight.semibold))
        }
        .offset(x: 0, y: -10)
    }
}

struct GraphLegendeShower: View {
    var body: some View {
        VStack (spacing: 30){
            Text("20+")
                .font(.system(size: 12, weight: Font.Weight.semibold))
            Text("15")
                .font(.system(size: 12, weight: Font.Weight.semibold))
            Text("10")
                .font(.system(size: 12, weight: Font.Weight.semibold))
            Text("5")
                .font(.system(size: 12, weight: Font.Weight.semibold))
            Text("0")
                .font(.system(size: 12, weight: Font.Weight.semibold))
        }
        .offset(x: 0, y: -10)
    }
}

struct GraphLegendeBinWaste: View {
    var body: some View {
        VStack (spacing: 70){
            Text("Nein")
                .font(.system(size: 12, weight: Font.Weight.semibold))
            Text("Teilweise")
                .font(.system(size: 12, weight: Font.Weight.semibold))
            Text("Ja")
                .font(.system(size: 12, weight: Font.Weight.semibold))
        }
        .offset(x: 0, y: -10)
    }
}
