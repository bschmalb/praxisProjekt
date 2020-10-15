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
    
    var user: User
    
    var graphColor: String
    var graphTitle: String
    var graphCategory: Int
    
    var graphLegende: [String] = ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"]
    
    var colors: [String] = ["cardgreen2", "graphgreen", "graphgreenyellow", "graphyellow", "graphred"]
    
    var screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        VStack {
            HStack {
                Text(graphTitle)
                    .font(.system(size: screenWidth < 500 ? screenWidth * 0.055 : 20, weight: .medium))
                    .padding(.leading, 15)
                    .foregroundColor(Color("black").opacity(0.8))
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
        let showIndex = user.log.count - 7
        
        switch graphCategory {
        case 0: return AnyView(
            HStack {
            GraphLegendeKilometer()
            HStack (spacing: 0) {
                ForEach(0..<7) { index in
                    HStack {
                        if (self.user.log.count > 6) {
                            BarView(graphColor: self.graphColor, graphLegende: self.graphLegende[index], value: CGFloat(self.user.log[showIndex + index].kilometer * 45 + 20))
                        }
                        else if (self.user.log.count > index) {
                            BarView(graphColor: self.graphColor, graphLegende: self.graphLegende[index], value: CGFloat(self.user.log[index].kilometer * 45 + 20))
                        }
                        else {
                            BarView(graphColor: "gray", graphLegende: self.graphLegende[index], value: 5)
                        }
                        Spacer()
                    }
                }
            }
            }
            )
        case 1: return AnyView(
            HStack {
                GraphLegende()
                HStack (spacing: 0) {
                    ForEach(0..<7) { index in
                        HStack {
                            if (self.user.log.count > 6) {
                                BarView(graphColor: self.graphColor, graphLegende: self.graphLegende[index], value: CGFloat(self.user.log[showIndex + index].meat * 45 + 20))
                            }
                            else if (self.user.log.count > index) {
                                BarView(graphColor: self.graphColor, graphLegende: self.graphLegende[index], value: CGFloat(self.user.log[index].meat * 45 + 20))
                            }
                            else {
                                BarView(graphColor: "gray", graphLegende: self.graphLegende[index], value: 5)
                            }
                            Spacer()
                        }
                    }
                }
            }
            )
        case 2: return AnyView(
            HStack {
                GraphLegende()
                HStack (spacing: 0) {
                    ForEach(0..<7) { index in
                        HStack {
                            if (self.user.log.count > 6) {
                                BarView(graphColor: self.graphColor, graphLegende: self.graphLegende[index], value: CGFloat(self.user.log[showIndex + index].cooked * 45 + 20))
                            }
                            else if (self.user.log.count > index) {
                                BarView(graphColor: self.graphColor, graphLegende: self.graphLegende[index], value: CGFloat(self.user.log[index].cooked * 45 + 20))
                            }
                            else {
                                BarView(graphColor: "gray", graphLegende: self.graphLegende[index], value: 5)
                            }
                            Spacer()
                        }
                    }
                }
            }
            )
        case 3: return AnyView(
            HStack {
                GraphLegende()
                HStack (spacing: 0) {
                    ForEach(0..<7) { index in
                        HStack {
                            if (self.user.log.count > 6) {
                                BarView(graphColor: self.graphColor, graphLegende: self.graphLegende[index], value: CGFloat(self.user.log[showIndex + index].foodWaste * 45 + 20))
                            }
                            else if (self.user.log.count > index) {
                                BarView(graphColor: self.graphColor, graphLegende: self.graphLegende[index], value: CGFloat(self.user.log[index].foodWaste * 45 + 20))
                            }
                            else {
                                BarView(graphColor: "gray", graphLegende: self.graphLegende[index], value: 5)
                            }
                            Spacer()
                        }
                    }
                }
            }
            )
        case 4: return AnyView(
            HStack {
                GraphLegende()
                HStack (spacing: 0) {
                    ForEach(0..<7) { index in
                        HStack {
                            if (self.user.log.count > 6) {
                                BarView(graphColor: self.graphColor, graphLegende: self.graphLegende[index], value: CGFloat(self.user.log[showIndex + index].drinks * 45 + 20))
                            }
                            else if (self.user.log.count > index) {
                                BarView(graphColor: self.graphColor, graphLegende: self.graphLegende[index], value: CGFloat(self.user.log[index].drinks * 45 + 20))
                            }
                            else {
                                BarView(graphColor: "gray", graphLegende: self.graphLegende[index], value: 5)
                            }
                            Spacer()
                        }
                    }
                }
            }
            )
        case 5: return AnyView(
            HStack {
                GraphLegendeShower()
                HStack (spacing: 0) {
                    ForEach(0..<7) { index in
                        HStack {
                            if (self.user.log.count > 6) {
                                BarView(graphColor: self.graphColor, graphLegende: self.graphLegende[index], value: CGFloat(self.user.log[showIndex + index].shower * 45 + 20))
                            }
                            else if (self.user.log.count > index) {
                                BarView(graphColor: self.graphColor, graphLegende: self.graphLegende[index], value: CGFloat(self.user.log[index].shower * 45 + 20))
                            }
                            else {
                                BarView(graphColor: "gray", graphLegende: self.graphLegende[index], value: 5)
                            }
                            Spacer()
                        }
                    }
                }
            }
            )
        case 6: return AnyView(
            HStack {
                GraphLegendeBinWaste()
                HStack (spacing: 0) {
                    ForEach(0..<7) { index in
                        HStack {
                            if (self.user.log.count > 6) {
                                BarView(graphColor: self.graphColor, graphLegende: self.graphLegende[index], value: CGFloat(self.user.log[showIndex + index].binWaste * 90 + 20))
                            }
                            else if (self.user.log.count > index) {
                                BarView(graphColor: self.graphColor, graphLegende: self.graphLegende[index], value: CGFloat(self.user.log[index].binWaste * 90 + 20))
                            }
                            else {
                                BarView(graphColor: "gray", graphLegende: self.graphLegende[index], value: 5)
                            }
                            Spacer()
                        }
                    }
                }
            }
            )
        default: return AnyView(
            ForEach(0..<7) { index in
                BarView(graphColor: self.graphColor, graphLegende: self.graphLegende[index], value: 1)
                Spacer()
            }
            )
        }
    }
    
//    func ChartView() -> some View {
//        let showIndex = store.user.log.count - 7
//
//        switch graphCategory {
//        case 0: return AnyView(
//            HStack {
//            GraphLegendeKilometer()
//            HStack (spacing: 20) {
//                ForEach(0..<7) { index in
//                    HStack {
//                        if (self.store.user.log.count > 6) {
//                            BarView(graphColor: colors[self.store.user.log[showIndex + index].kilometer+1], graphLegende: self.graphLegende[index], value: CGFloat(self.store.user.log[showIndex + index].kilometer * 45 + 20))
//                        }
//                        else if (self.store.user.log.count > index) {
//                            BarView(graphColor: colors[self.store.user.log[showIndex + index].kilometer], graphLegende: self.graphLegende[index], value: CGFloat(self.store.user.log[index].kilometer * 45 + 20))
//                        }
//                        else {
//                            BarView(graphColor: "gray", graphLegende: self.graphLegende[index], value: 5)
//                        }
//                    }
//                }
//            }
//            }
//            )
//        case 1: return AnyView(
//            HStack {
//            GraphLegende()
//            HStack (spacing: 20) {
//                ForEach(0..<7) { index in
//                    HStack {
//                        if (self.store.user.log.count > 6) {
//                            BarView(graphColor: colors[self.store.user.log[showIndex + index].meat], graphLegende: self.graphLegende[index], value: CGFloat(self.store.user.log[showIndex + index].meat * 45 + 20))
//                        }
//                        else if (self.store.user.log.count > index) {
//                            BarView(graphColor: colors[self.store.user.log[showIndex + index].meat], graphLegende: self.graphLegende[index], value: CGFloat(self.store.user.log[index].meat * 45 + 20))
//                        }
//                        else {
//                            BarView(graphColor: "gray", graphLegende: self.graphLegende[index], value: 5)
//                        }
//                    }
//                }
//                }
//            }
//            )
//        case 2: return AnyView(
//            HStack {
//                GraphLegende()
//                HStack (spacing: 20) {
//                    ForEach(0..<7) { index in
//                        HStack {
//                            if (self.store.user.log.count > 6) {
//                                BarView(graphColor: colors[self.store.user.log[showIndex + index].cooked], graphLegende: self.graphLegende[index], value: CGFloat(self.store.user.log[showIndex + index].cooked * 45 + 20))
//                            }
//                            else if (self.store.user.log.count > index) {
//                                BarView(graphColor: colors[self.store.user.log[showIndex + index].cooked], graphLegende: self.graphLegende[index], value: CGFloat(self.store.user.log[index].cooked * 45 + 20))
//                            }
//                            else {
//                                BarView(graphColor: "gray", graphLegende: self.graphLegende[index], value: 5)
//                            }
//                        }
//                    }
//                }
//            }
//            )
//        case 3: return AnyView(
//            HStack {
//                GraphLegende()
//                HStack (spacing: 20) {
//                    ForEach(0..<7) { index in
//                        HStack {
//                            if (self.store.user.log.count > 6) {
//                                BarView(graphColor: colors[self.store.user.log[showIndex + index].foodWaste], graphLegende: self.graphLegende[index], value: CGFloat(self.store.user.log[showIndex + index].foodWaste * 45 + 20))
//                            }
//                            else if (self.store.user.log.count > index) {
//                                BarView(graphColor: colors[self.store.user.log[showIndex + index].foodWaste], graphLegende: self.graphLegende[index], value: CGFloat(self.store.user.log[index].foodWaste * 45 + 20))
//                            }
//                            else {
//                                BarView(graphColor: "gray", graphLegende: self.graphLegende[index], value: 5)
//                            }
//                        }
//                    }
//                }
//            }
//            )
//        case 4: return AnyView(
//            HStack {
//                GraphLegende()
//                HStack (spacing: 20) {
//                    ForEach(0..<7) { index in
//                        HStack {
//                            if (self.store.user.log.count > 6) {
//                                BarView(graphColor: colors[self.store.user.log[showIndex + index].drinks], graphLegende: self.graphLegende[index], value: CGFloat(self.store.user.log[showIndex + index].drinks * 45 + 20))
//                            }
//                            else if (self.store.user.log.count > index) {
//                                BarView(graphColor: colors[self.store.user.log[showIndex + index].drinks], graphLegende: self.graphLegende[index], value: CGFloat(self.store.user.log[index].drinks * 45 + 20))
//                            }
//                            else {
//                                BarView(graphColor: "gray", graphLegende: self.graphLegende[index], value: 5)
//                            }
//                        }
//                    }
//                }
//            }
//            )
//        case 5: return AnyView(
//            HStack {
//                GraphLegendeShower()
//                HStack (spacing: 20) {
//                    ForEach(0..<7) { index in
//                        HStack {
//                            if (self.store.user.log.count > 6) {
//                                BarView(graphColor: colors[self.store.user.log[showIndex + index].shower], graphLegende: self.graphLegende[index], value: CGFloat(self.store.user.log[showIndex + index].shower * 45 + 20))
//                            }
//                            else if (self.store.user.log.count > index) {
//                                BarView(graphColor: colors[self.store.user.log[showIndex + index].shower], graphLegende: self.graphLegende[index], value: CGFloat(self.store.user.log[index].shower * 45 + 20))
//                            }
//                            else {
//                                BarView(graphColor: "gray", graphLegende: self.graphLegende[index], value: 5)
//                            }
//                        }
//                    }
//                }
//            }
//            )
//        case 6: return AnyView(
//            HStack {
//                GraphLegendeBinWaste()
//                HStack (spacing: 20) {
//                    ForEach(0..<7) { index in
//                        HStack {
//                            if (self.store.user.log.count > 6) {
//                                BarView(graphColor: colors[self.store.user.log[showIndex + index].binWaste], graphLegende: self.graphLegende[index], value: CGFloat(self.store.user.log[showIndex + index].binWaste * 90 + 20))
//                            }
//                            else if (self.store.user.log.count > index) {
//                                BarView(graphColor: colors[self.store.user.log[showIndex + index].binWaste], graphLegende: self.graphLegende[index], value: CGFloat(self.store.user.log[index].binWaste * 90 + 20))
//                            }
//                            else {
//                                BarView(graphColor: "gray", graphLegende: self.graphLegende[index], value: 5)
//                            }
//                        }
//                    }
//                }
//            }
//            )
//        default: return AnyView(
//            ForEach(0..<7) { index in
//                BarView(graphColor: colors[self.store.user.log[showIndex + index].kilometer], graphLegende: self.graphLegende[index], value: 1)
//            }
//            )
//        }
//    }
}

struct EntwicklungGraphView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EntwicklungGraphView(user: User(_id: "", phoneId: "", checkedTipps: [], savedTipps: [], savedFacts: [], log: []), graphColor: "blue", graphTitle: "Kilometer", graphCategory: 0)
            EntwicklungGraphView(user: User(_id: "", phoneId: "", checkedTipps: [], savedTipps: [], savedFacts: [], log: []), graphColor: "blue", graphTitle: "Kilometer", graphCategory: 0)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
                .previewDisplayName("iPhone 11")
        }
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
                if (value < 201 && value > -1) {
                Capsule().frame(width: 30, height: value).foregroundColor(Color(graphColor).opacity(1-(Double(self.value)/400)))
                }
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
        VStack {
            Text("4+")
                .font(.system(size: 12, weight: Font.Weight.semibold))
                .padding(.top, 10)
            Spacer()
            Text("3")
                .font(.system(size: 12, weight: Font.Weight.semibold))
            Spacer()
            Text("2")
                .font(.system(size: 12, weight: Font.Weight.semibold))
            Spacer()
            Text("1")
                .font(.system(size: 12, weight: Font.Weight.semibold))
            Spacer()
            Text("0")
                .font(.system(size: 12, weight: Font.Weight.semibold))
                .padding(.bottom, 10)
        }
        .offset(x: 0, y: -10)
    }
}

struct GraphLegendeShower: View {
    var body: some View {
        VStack {
            Text("20+")
                .font(.system(size: 12, weight: Font.Weight.semibold))
                .padding(.top, 10)
            Spacer()
            Text("15")
                .font(.system(size: 12, weight: Font.Weight.semibold))
            Spacer()
            Text("10")
                .font(.system(size: 12, weight: Font.Weight.semibold))
            Spacer()
            Text("5")
                .font(.system(size: 12, weight: Font.Weight.semibold))
            Spacer()
            Text("0")
                .font(.system(size: 12, weight: Font.Weight.semibold))
                .padding(.bottom, 10)
            
        }
        .offset(x: 0, y: -10)
    }
}

struct GraphLegendeKilometer: View {
    var body: some View {
        VStack {
            Text("50+")
                .font(.system(size: 12, weight: Font.Weight.semibold))
                .padding(.top, 10)
            Spacer()
            Text("35")
                .font(.system(size: 12, weight: Font.Weight.semibold))
            Spacer()
            Text("20")
                .font(.system(size: 12, weight: Font.Weight.semibold))
            Spacer()
            Text("10")
                .font(.system(size: 12, weight: Font.Weight.semibold))
            Spacer()
            Text("0")
                .font(.system(size: 12, weight: Font.Weight.semibold))
                .padding(.bottom, 10)
        }
        .offset(x: 0, y: -10)
    }
}

struct GraphLegendeBinWaste: View {
    var body: some View {
        VStack {
            Text("Nein")
                .font(.system(size: 12, weight: Font.Weight.semibold))
                .padding(.top, 10)
            Spacer()
            Text("Ja")
                .font(.system(size: 12, weight: Font.Weight.semibold))
                .padding(.bottom, 10)
        }
        .offset(x: 0, y: -10)
    }
}
