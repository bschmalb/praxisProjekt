//
//  ProfilTippView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 19.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct ProfilTippView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    let uuid = UIDevice.current.identifierForVendor?.uuidString
    
    @State var filteredTipps3: [Tipp] = []
    
    @State var checkedSelected: Bool = true
    @State var savedSelected: Bool = false
    @State var ownSelected: Bool = false
    
    @State var tabSelected = 0
    
    @State var tippOffset: CGFloat = -UIScreen.main.bounds.width / 2.8 + (UIScreen.main.bounds.width/2)
    @State var selectWidth: CGFloat = 90
    @State var slidingText: String = "Abgehakte"
    
    
    var body: some View {
        ZStack {
            Color("background")
                .edgesIgnoringSafeArea(.all)
            VStack {
                Button(action: {
                    self.mode.wrappedValue.dismiss()
                    impact(style: .medium)
                }) {
                    HStack (spacing: 15){
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: Font.Weight.medium))
                            .foregroundColor(Color("black"))
                        Text("Deine Gewohnheiten")
                            .font(.system(size: 20, weight: Font.Weight.medium))
                            .fontWeight(.semibold)
                            .foregroundColor(Color("black"))
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 5)
                    .padding(.top, UIScreen.main.bounds.height / 40)
                }
                ZStack {
                    Text(slidingText)
                        .font(.footnote)
                        .foregroundColor(Color("black"))
                        .frame(width: selectWidth, height: 2)
                        .offset(x: tippOffset - (UIScreen.main.bounds.width/2), y:  UIScreen.main.bounds.height / 30)
                        .animation(.spring())
                    HStack (spacing: UIScreen.main.bounds.width / 5){
                        GeometryReader { g in
                            Button(action: {
                                self.tabSelected = 0
                                self.tippOffset = g.frame(in: .global).midX
                                self.selectWidth = 90
                                
                                self.slidingText = "Abgehakte"
                                
                                impact(style: .medium)
                            }){
                                VStack {
                                    Image(systemName: "checkmark")
                                        .multilineTextAlignment(.center)
                                        .font(Font.system(size: 25, weight: .regular))
                                        .foregroundColor(self.tabSelected == 0 ? Color("black") : .secondary)
                                        .offset(y: self.tabSelected == 0 ? 0 : 5)
                                }
                                .padding(.all, 10)
                                .animation(.spring())
                            }
                        }
                        .frame(width: 60, height: 50)
                        GeometryReader { g in
                            Button(action: {
                                self.tabSelected = 1
                                self.tippOffset = g.frame(in: .global).midX
                                self.selectWidth = 120
                                
                                self.slidingText = "Gespeicherte"
                                
                                impact(style: .medium)
                            }){
                                VStack {
                                    Image(systemName: "bookmark")
                                        .multilineTextAlignment(.center)
                                        .font(Font.system(size: 25, weight: .regular))
                                        .foregroundColor(self.tabSelected == 1 ? Color("black") : .secondary)
                                        .offset(y: self.tabSelected == 1 ? 0 : 5)
                                }
                                .padding(.all, 10)
                                .animation(.spring())
                            }
                        }
                        .frame(width: 60, height: 50)
                        GeometryReader { g in
                            Button(action: {
                                self.tabSelected = 2
                                self.tippOffset = g.frame(in: .global).midX
                                self.selectWidth = 80
                                
                                self.slidingText = "Eigene"
                                
                                impact(style: .medium)
                            }){
                                VStack {
                                    Image(systemName: "plus.circle")
                                        .multilineTextAlignment(.center)
                                        .font(Font.system(size: 25, weight: .regular))
                                        .foregroundColor(self.tabSelected == 2 ? Color("black") : .secondary)
                                        .offset(y: self.tabSelected == 2 ? 0 : 5)
                                }
                                .padding(.all, 10)
                                .animation(.spring())
                            }
                        }
                        .frame(width: 60, height: 50)
                    }.padding(.horizontal, 10)
                        .padding(.bottom, 10)
                }
                .offset(y: -10)
                ZStack {
                    VStack {
                        if (!self.filteredTipps3.isEmpty) {
                            ScrollView(.vertical, showsIndicators: false) {
                                ForEach(self.filteredTipps3.indices, id: \.self) { index in
                                    VStack {
                                        if(self.filteredTipps3[index].isChecked) {
                                            SmallTippCard(isChecked: self.$filteredTipps3[index].isChecked, isBookmarked: self.$filteredTipps3[index].isBookmarked, tipp: self.filteredTipps3[index])
                                                    .shadow(color: Color("black").opacity(0.05), radius: 5, x: 4, y: 4)
                                                    .padding(.vertical, 5)
                                        }
                                    }
                                }
                            }
                            
//                            GeometryReader { proxy in
//                                UIScrollViewWrapper {
//                                    HStack {
//                                        ForEach(self.filteredTipps3.indices, id: \.self) { index in
//                                            HStack {
//                                                if(self.filteredTipps3[index].isChecked) {
//                                                    GeometryReader { geometry in
//                                                        TippCard(isChecked: self.$filteredTipps3[index].isChecked, isBookmarked: self.$filteredTipps3[index].isBookmarked, tipp: self.filteredTipps3[index])
//                                                            .rotation3DEffect(Angle(degrees: (Double(geometry.frame(in: .global).minX) - 5 ) / -8), axis: (x: 0, y: 10.0, z:0))
//                                                            .shadow(color: Color("black").opacity(0.05), radius: 5, x: 4, y: 4)
//                                                            .padding(.vertical, 10)
//                                                    }
//                                                    .frame(width: UIScreen.main.bounds.width - 7.5, height: UIScreen.main.bounds.height/2.1 + 20)
//                                                }
//                                            }
//                                        }
//                                    }.padding(.horizontal, 5)
//                                        .frame(height: UIScreen.main.bounds.height/2.1 + 20)
//                                        .background(Color("background"))
//                                        .animation(.spring())
//                                }
//                            }
//                            .frame(height: UIScreen.main.bounds.height/2.1 + 20)
                        }
                    }.offset(x: self.tabSelected == 0 ? 0 : -UIScreen.main.bounds.width)
                    VStack {
                        if (!self.filteredTipps3.isEmpty) {
                            //                                                        GeometryReader { proxy in
                            //                                                            UIScrollViewWrapper {
                            //                                                                HStack {
                            //                                                                    ForEach(self.filteredTipps3.indices, id: \.self) { index in
                            //                                                                        HStack {
                            //                                                                            if(self.filteredTipps3[index].isBookmarked) {
                            //                                                                                GeometryReader { geometry in
                            //                                                                                    TippCard(isChecked: self.$filteredTipps3[index].isChecked, isBookmarked: self.$filteredTipps3[index].isBookmarked, tipp: self.filteredTipps3[index])
                            //                                                                                        .rotation3DEffect(Angle(degrees: (Double(geometry.frame(in: .global).minX) - 20 ) / -8), axis: (x: 0, y: 10.0, z:0))
                            //                                                                                        .shadow(color: Color("black").opacity(0.05), radius: 5, x: 4, y: 4)
                            //                                                                                        .padding(.vertical, 10)
                            //                                                                                }
                            //                                                                                .frame(width: UIScreen.main.bounds.width - 7.5, height: UIScreen.main.bounds.height/2.1 + 20)
                            //                                                                            }
                            //                                                                        }
                            //                                                                    }
                            //                                                                }.padding(.horizontal, 15)
                            //                                                                .frame(height: UIScreen.main.bounds.height/2.1 + 20)
                            //                                                                .background(Color("background"))
                            //                                                            }
                            //                                                        }
                            //                                                        .frame(height: UIScreen.main.bounds.height/2.1 + 20)
                            //                                                        .animation(.spring())
                            
                            ScrollView (.horizontal, showsIndicators: false) {
                                HStack (spacing: -2){
                                    ForEach(filteredTipps3.indices, id: \.self) { index in
                                        HStack {
                                            if (self.filteredTipps3[index].isBookmarked) {
                                                GeometryReader { geometry in
                                                    TippCard(isChecked: self.$filteredTipps3[index].isChecked, isBookmarked: self.$filteredTipps3[index].isBookmarked, tipp: self.filteredTipps3[index])
                                                        .padding(.vertical, UIScreen.main.bounds.height / 81)
                                                        .rotation3DEffect(Angle(degrees: (Double(geometry.frame(in: .global).minX) - 20 ) / -20), axis: (x: 0, y: 10.0, z:0))
                                                        .shadow(color: Color(.black).opacity(0.1), radius: 5, x: 4, y: 3)
                                                }
                                                .frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height/2.1 + 20)
                                            }
                                        }
                                    }
                                }
                                .padding(.leading, 15)
                                .padding(.trailing, 15)
                                .animation(.spring())
                            }
                        }
                    }.offset(x: self.tabSelected == 0 ? UIScreen.main.bounds.width : 0)
                        .offset(x: self.tabSelected == 2 ? -UIScreen.main.bounds.width : 0)
                    VStack {
                        if (!self.filteredTipps3.isEmpty) {
                            GeometryReader { proxy in
                                UIScrollViewWrapper {
                                    HStack {
                                        ForEach(self.filteredTipps3.indices, id: \.self) { index in
                                            HStack {
                                                //                                                if(self.uuid == self.filteredTipps3[index].postedBy) {
                                                GeometryReader { geometry in
                                                    TippCard(isChecked: self.$filteredTipps3[index].isChecked, isBookmarked: self.$filteredTipps3[index].isBookmarked, tipp: self.filteredTipps3[index])
                                                        .rotation3DEffect(Angle(degrees: (Double(geometry.frame(in: .global).minX) - 5 ) / -8), axis: (x: 0, y: 10.0, z:0))
                                                        .shadow(color: Color("black").opacity(0.05), radius: 5, x: 4, y: 4)
                                                        .padding(.vertical, 10)
                                                }
                                                .frame(width: UIScreen.main.bounds.width - 7.5, height: UIScreen.main.bounds.height/2.1 + 20)
                                                //                                                }
                                            }
                                        }
                                    }.padding(.horizontal, 5)
                                        .frame(height: UIScreen.main.bounds.height/2.1 + 20)
                                        .background(Color("background"))
                                        .animation(.spring())
                                }
                            }
                            .frame(height: UIScreen.main.bounds.height/2.1 + 20)
                        }
                    }.offset(x: self.tabSelected == 2 ? 0 : UIScreen.main.bounds.width)
                }
                .animation(.spring())
                Spacer()
            }
            .onAppear{
                AllApi().fetchAllTipps { (filteredTipps3) in
                    self.filteredTipps3 = filteredTipps3
                }
                impact(style: .medium)
            }
        }
        .accentColor(.black)
        .gesture(DragGesture()
        .onChanged({ (value) in
            if value.translation.width > 40 {
                self.mode.wrappedValue.dismiss()
            }
        }))
    }
}


struct ProfilTippView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilTippView()
    }
}
