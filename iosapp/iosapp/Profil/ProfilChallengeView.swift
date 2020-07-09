//
//  ProfilTippView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 19.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct ProfilChallengeView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    let uuid = UIDevice.current.identifierForVendor?.uuidString
    
    @State var filteredChallenges: [Challenge] = []
    
    @State var checkedSelected: Bool = true
    @State var savedSelected: Bool = false
    @State var ownSelected: Bool = false
    @State var tippOffset: CGFloat = -UIScreen.main.bounds.width / 2.8
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
                        Image(systemName: "arrow.left.circle")
                            .font(.system(size: 24, weight: Font.Weight.medium))
                            .foregroundColor(Color("black"))
                        Text("Deine Challenges")
                            .font(.system(size: 26, weight: Font.Weight.medium))
                            .fontWeight(.semibold)
                            .foregroundColor(Color("black"))
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .padding(.top, UIScreen.main.bounds.height / 40)
                }
                ZStack {
                    Text(slidingText)
                        .font(.footnote)
                        .foregroundColor(Color("black"))
                        .frame(width: selectWidth, height: 2)
                        .offset(x: tippOffset, y:  UIScreen.main.bounds.height / 30)
                        .animation(.spring())
                    //                    RoundedRectangle(cornerRadius: 15, style: .circular)
                    //                        .foregroundColor(Color("black"))
                    //                        .frame(width: selectWidth, height: 2)
                    //                        .offset(x: tippOffset, y:  UIScreen.main.bounds.height / 30)
                    HStack (spacing: 95){
                        Button(action: {
                            self.checkedSelected = true
                            self.savedSelected = false
                            self.ownSelected = false
                            self.tippOffset = -UIScreen.main.bounds.width / 2.8
                            self.selectWidth = 90
                            
                            self.slidingText = "Abgehakte"
                            
                            impact(style: .medium)
                        }){
                            VStack {
                                Image(systemName: "checkmark")
                                    .multilineTextAlignment(.center)
                                    .font(Font.system(size: 25, weight: .regular))
                                    .foregroundColor(checkedSelected ? Color("black") : .secondary)
                                    .offset(y: checkedSelected ? 0 : 5)
                            }
                            .padding(.all, 10)
                            .animation(.spring())
                        }
                        Button(action: {
                            self.checkedSelected = false
                            self.savedSelected = true
                            self.ownSelected = false
                            self.tippOffset = 0
                            self.selectWidth = 120
                            
                            self.slidingText = "Gepseicherte"
                            
                            impact(style: .medium)
                        }){
                            VStack {
                                Image(systemName: "bookmark")
                                    .multilineTextAlignment(.center)
                                    .font(Font.system(size: 25, weight: .regular))
                                    .foregroundColor(savedSelected ? Color("black") : .secondary)
                                    .offset(y: savedSelected ? 0 : 5)
                            }
                            .padding(.all, 10)
                            .animation(.spring())
                        }
                        Button(action: {
                            self.checkedSelected = false
                            self.savedSelected = false
                            self.ownSelected = true
                            self.tippOffset = UIScreen.main.bounds.width / 2.8
                            self.selectWidth = 80
                            
                            self.slidingText = "Eigene"
                            
                            impact(style: .medium)
                        }){
                            VStack {
                                Image(systemName: "plus.circle")
                                    .multilineTextAlignment(.center)
                                    .font(Font.system(size: 25, weight: .regular))
                                    .foregroundColor(ownSelected ? Color("black") : .secondary)
                                    .offset(y: ownSelected ? 0 : 5)
                            }
                            .padding(.all, 10)
                            .animation(.spring())
                        }
                    }.padding(.horizontal, 10)
                        .padding(.bottom, 10)
                }
                .offset(y: -5)
                
                ZStack {
                    VStack {
                        if (!self.filteredChallenges.isEmpty) {
                            GeometryReader { proxy in
                                UIScrollViewWrapper {
                                    HStack {
                                        ForEach(self.filteredChallenges.indices, id: \.self) { index in
                                            HStack {
                                                if(self.filteredChallenges[index].isChecked) {
                                                    GeometryReader { geometry in
                                                        ChallengeCard(isChecked: self.$filteredChallenges[index].isChecked, isBookmarked: self.$filteredChallenges[index].isBookmarked, challenge: self.filteredChallenges[index])
                                                            .rotation3DEffect(Angle(degrees: (Double(geometry.frame(in: .global).minX) - 5 ) / -8), axis: (x: 0, y: 10.0, z:0))
                                                            .shadow(color: Color("black").opacity(0.05), radius: 5, x: 4, y: 4)
                                                            .padding(.vertical, 10)
                                                    }
                                                    .frame(width: UIScreen.main.bounds.width - 7.5, height: UIScreen.main.bounds.height/2.1 + 20)
                                                }
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
                    }.offset(x: self.checkedSelected ? 0 : -UIScreen.main.bounds.width)
                    VStack {
                        if (!self.filteredChallenges.isEmpty) {
                            //                            GeometryReader { proxy in
                            //                                UIScrollViewWrapper {
                            //                                    HStack {
                            //                                        ForEach(filteredTipps3.indices, id: \.self) { index in
                            //                                            HStack {
                            //                                                if(filteredTipps3[index].isBookmarked) {
                            //                                                    GeometryReader { geometry in
                            //                                                        TippCard(isChecked: self.$filteredTipps3[index].isChecked, isBookmarked: self.$filteredTipps3[index].isBookmarked, tipp: self.filteredTipps3[index])
                            //                                                            .rotation3DEffect(Angle(degrees: (Double(geometry.frame(in: .global).minX) - 20 ) / -8), axis: (x: 0, y: 10.0, z:0))
                            //                                                            .shadow(color: Color("black").opacity(0.05), radius: 5, x: 4, y: 4)
                            //                                                            .padding(.vertical, 10)
                            //                                                    }
                            //                                                    .frame(width: UIScreen.main.bounds.width - 7.5, height: UIScreen.main.bounds.height/2.1 + 20)
                            //                                                }
                            //                                            }
                            //                                        }
                            //                                    }.padding(.horizontal, 15)
                            //                                    .frame(height: UIScreen.main.bounds.height/2.1 + 20)
                            //                                    .background(Color("background"))
                            //                                }
                            //                            }
                            //                            .frame(height: UIScreen.main.bounds.height/2.1 + 20)
                            //                            .animation(.spring())
                            
                            ScrollView (.horizontal, showsIndicators: false) {
                                HStack (spacing: -2){
                                    ForEach(filteredChallenges.indices, id: \.self) { index in
                                        VStack {
                                            if (self.filteredChallenges[index].isBookmarked) {
                                                GeometryReader { geometry in
                                                    ChallengeCard(isChecked: self.$filteredChallenges[index].isChecked, isBookmarked: self.$filteredChallenges[index].isBookmarked, challenge: self.filteredChallenges[index])
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
                    }.offset(x: self.checkedSelected ? UIScreen.main.bounds.width : 0)
                        .offset(x: self.ownSelected ? -UIScreen.main.bounds.width : 0)
                    VStack {
                        if (!self.filteredChallenges.isEmpty) {
                            GeometryReader { proxy in
                                UIScrollViewWrapper {
                                    HStack {
                                        ForEach(self.filteredChallenges.indices, id: \.self) { index in
                                            HStack {
//                                                if(self.filteredChallenges[index].postedBy == self.uuid) {
                                                    GeometryReader { geometry in
                                                        ChallengeCard(isChecked: self.$filteredChallenges[index].isChecked, isBookmarked: self.$filteredChallenges[index].isBookmarked, challenge: self.filteredChallenges[index])
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
                    }.offset(x: self.ownSelected ? 0 : UIScreen.main.bounds.width)
                }.animation(.spring())
                Spacer()
            }
            .onAppear{
                ChallengeApi().fetchChallenges { (filteredChallenges) in
                    self.filteredChallenges = filteredChallenges
                    print(filteredChallenges)
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


struct ProfilChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilChallengeView()
    }
}
