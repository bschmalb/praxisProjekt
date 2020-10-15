////
////  ProfilTippView.swift
////  iosapp
////
////  Created by Bastian Schmalbach on 19.06.20.
////  Copyright © 2020 Bastian Schmalbach. All rights reserved.
////
//
//import SwiftUI
//
//struct ProfilChallengeView: View {
//
//    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
//
//    let uuid = UIDevice.current.identifierForVendor?.uuidString
//
//    @State var filteredChallenges: [Challenge] = []
//    @State var filteredTipps: [Tipp] = []
//
//    @State var checkedSelected: Bool = true
//    @State var savedSelected: Bool = false
//    @State var ownSelected: Bool = false
//
//    @State var tabSelected = 0
//
//    @State var tippOffset: CGFloat = -UIScreen.main.bounds.width / 2.8 + (UIScreen.main.bounds.width/2)
//    @State var selectWidth: CGFloat = 90
//    @State var slidingText: String = "Abgehakte"
//
//    var screenWidth = UIScreen.main.bounds.width
//
//    var cardColors: [String]  = [
//        "cardgreen2", "cardblue2", "cardyellow2", "cardpurple2", "cardorange2", "cardred2", "cardturqouise2", "cardyelgre2", "cardpink2"
//    ]
//
//    var body: some View {
//        ZStack {
//            Color("background")
//                .edgesIgnoringSafeArea(.all)
//            VStack {
//                Button(action: {
//                    self.mode.wrappedValue.dismiss()
//                    impact(style: .medium)
//                }) {
//                    HStack (spacing: 10){
//                        Image(systemName: "arrow.left")
//                            .font(.system(size: screenWidth < 500 ? screenWidth * 0.040 : 18, weight: .medium))
//                            .foregroundColor(Color("black"))
//                        Text("Deine Fakten")
//                            .font(.system(size: screenWidth < 500 ? screenWidth * 0.040 : 18, weight: .medium))
//                            .foregroundColor(Color("black"))
//                        Spacer()
//                    }
//                    .padding(.leading, 20)
//                    .padding(.vertical, 10)
//                }
////                SliderView(slidingText: $slidingText, selectWidth: $selectWidth, tippOffset: $tippOffset, tabSelected: $tabSelected)
////                .offset(y: -10)
//
//                ZStack {
//                    VStack {
//                        if (!self.filteredChallenges.isEmpty) {
//                            GeometryReader { proxy in
//                                UIScrollViewWrapper {
//                                    HStack {
//                                        ForEach(self.filteredTipps.indices, id: \.self) { index in
//                                            HStack {
//                                                GeometryReader { geometry in
//                                                        TippCard2(isChecked: self.$filteredTipps[index].isChecked, isBookmarked: self.$filteredTipps[index].isBookmarked, tipp: self.filteredTipps[index], color: cardColors[index % 9])
//                                                            .rotation3DEffect(Angle(degrees: (Double(geometry.frame(in: .global).minX) - 5 ) / -10), axis: (x: 0, y: 10.0, z:0))
//                                                            .shadow(color: Color("black").opacity(0.05), radius: 5, x: 4, y: 4)
//                                                            .padding(.vertical, 10)
//                                                    }
//                                                    .frame(width: UIScreen.main.bounds.width - 7.5, height: UIScreen.main.bounds.height/2.1 + 20)
//                                            }
//                                        }
//                                    }
//                                    .padding(.horizontal, 5)
//                                    .frame(height: UIScreen.main.bounds.height/2.1 + 20)
//                                    .background(Color("background"))
//                                    .animation(.spring())
//                                }
//                            }
//                            .frame(height: UIScreen.main.bounds.height/2.1 + 20)
////                            GeometryReader { proxy in
////                                UIScrollViewWrapper {
////                                    HStack {
////                                        ForEach(self.filteredChallenges.indices, id: \.self) { index in
////                                            HStack {
////                                                if(self.filteredChallenges[index].isChecked) {
////                                                    GeometryReader { geometry in
////                                                        ChallengeCard(isChecked: self.$filteredChallenges[index].isChecked, isBookmarked: self.$filteredChallenges[index].isBookmarked, challenge: self.filteredChallenges[index])
////                                                            .rotation3DEffect(Angle(degrees: (Double(geometry.frame(in: .global).minX) - 5 ) / -8), axis: (x: 0, y: 10.0, z:0))
////                                                            .shadow(color: Color("black").opacity(0.05), radius: 5, x: 4, y: 4)
////                                                            .padding(.vertical, 10)
////                                                    }
////                                                    .frame(width: UIScreen.main.bounds.width - 7.5, height: UIScreen.main.bounds.height/2.1 + 20)
////                                                }
////                                            }
////                                        }
////                                    }.padding(.horizontal, 5)
////                                        .frame(height: UIScreen.main.bounds.height/2.1 + 20)
////                                        .background(Color("background"))
////                                        .animation(.spring())
////                                }
////                            }
////                            .frame(height: UIScreen.main.bounds.height/2.1 + 20)
//                        }
//                    }.offset(x: self.tabSelected == 0 ? 0 : -UIScreen.main.bounds.width)
//                    VStack {
//                        if (!self.filteredChallenges.isEmpty) {
//                            //                            GeometryReader { proxy in
//                            //                                UIScrollViewWrapper {
//                            //                                    HStack {
//                            //                                        ForEach(filteredTipps3.indices, id: \.self) { index in
//                            //                                            HStack {
//                            //                                                if(filteredTipps3[index].isBookmarked) {
//                            //                                                    GeometryReader { geometry in
//                            //                                                        TippCard(isChecked: self.$filteredTipps3[index].isChecked, isBookmarked: self.$filteredTipps3[index].isBookmarked, tipp: self.filteredTipps3[index])
//                            //                                                            .rotation3DEffect(Angle(degrees: (Double(geometry.frame(in: .global).minX) - 20 ) / -8), axis: (x: 0, y: 10.0, z:0))
//                            //                                                            .shadow(color: Color("black").opacity(0.05), radius: 5, x: 4, y: 4)
//                            //                                                            .padding(.vertical, 10)
//                            //                                                    }
//                            //                                                    .frame(width: UIScreen.main.bounds.width - 7.5, height: UIScreen.main.bounds.height/2.1 + 20)
//                            //                                                }
//                            //                                            }
//                            //                                        }
//                            //                                    }.padding(.horizontal, 15)
//                            //                                    .frame(height: UIScreen.main.bounds.height/2.1 + 20)
//                            //                                    .background(Color("background"))
//                            //                                }
//                            //                            }
//                            //                            .frame(height: UIScreen.main.bounds.height/2.1 + 20)
//                            //                            .animation(.spring())
//
//                            ScrollView (.horizontal, showsIndicators: false) {
//                                HStack (spacing: -2){
//                                    ForEach(filteredChallenges.indices, id: \.self) { index in
//                                        VStack {
//                                            if (self.filteredChallenges[index].isBookmarked) {
//                                                GeometryReader { geometry in
//                                                    ChallengeCard(isChecked: self.$filteredChallenges[index].isChecked, isBookmarked: self.$filteredChallenges[index].isBookmarked, challenge: self.filteredChallenges[index])
//                                                        .padding(.vertical, UIScreen.main.bounds.height / 81)
//                                                        .rotation3DEffect(Angle(degrees: (Double(geometry.frame(in: .global).minX) - 20 ) / -20), axis: (x: 0, y: 10.0, z:0))
//                                                        .shadow(color: Color(.black).opacity(0.1), radius: 5, x: 4, y: 3)
//                                                }
//                                                .frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height/2.1 + 20)
//                                            }
//                                        }
//                                    }
//                                }
//                                .padding(.leading, 15)
//                                .padding(.trailing, 15)
//                                .animation(.spring())
//                            }
//                        }
//                    }.offset(x: self.tabSelected == 0 ? UIScreen.main.bounds.width : 0)
//                        .offset(x: self.tabSelected == 2 ? -UIScreen.main.bounds.width : 0)
//                    VStack {
//                        if (!self.filteredChallenges.isEmpty) {
//                            GeometryReader { proxy in
//                                UIScrollViewWrapper {
//                                    HStack {
//                                        ForEach(self.filteredChallenges.indices, id: \.self) { index in
//                                            HStack {
////                                                if(self.filteredChallenges[index].postedBy == self.uuid) {
//                                                    GeometryReader { geometry in
//                                                        ChallengeCard(isChecked: self.$filteredChallenges[index].isChecked, isBookmarked: self.$filteredChallenges[index].isBookmarked, challenge: self.filteredChallenges[index])
//                                                            .rotation3DEffect(Angle(degrees: (Double(geometry.frame(in: .global).minX) - 5 ) / -8), axis: (x: 0, y: 10.0, z:0))
//                                                            .shadow(color: Color("black").opacity(0.05), radius: 5, x: 4, y: 4)
//                                                            .padding(.vertical, 10)
//                                                    }
//                                                    .frame(width: UIScreen.main.bounds.width - 7.5, height: UIScreen.main.bounds.height/2.1 + 20)
////                                                }
//                                            }
//                                        }
//                                    }.padding(.horizontal, 5)
//                                        .frame(height: UIScreen.main.bounds.height/2.1 + 20)
//                                        .background(Color("background"))
//                                        .animation(.spring())
//                                }
//                            }
//                            .frame(height: UIScreen.main.bounds.height/2.1 + 20)
//                        }
//                    }.offset(x: self.tabSelected == 2 ? 0 : UIScreen.main.bounds.width)
//                }.animation(.spring())
//                Spacer()
//            }
//            .onAppear{
//                ChallengeApi().fetchChallenges { (filteredChallenges) in
//                    self.filteredChallenges = filteredChallenges
//                }
//                Api().fetchTipps { (filteredTipps) in
//                    self.filteredTipps = filteredTipps
//                }
//            }
//        }
//        .accentColor(.black)
//        .gesture(DragGesture()
//        .onChanged({ (value) in
//            if value.translation.width > 40 {
//                self.mode.wrappedValue.dismiss()
//            }
//        }))
//    }
//}
//
//
//struct ProfilChallengeView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfilChallengeView()
//    }
//}
