//
//  AddTagebuchCard2.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 20.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct AddTagebuchCard3: View {
    
    @Binding var tabViewSelected: Int
    
    var kilometer: Int
    var meat: Int
    
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State var firstCooked: Bool = false
    @State var secondCooked: Bool = false
    @State var thirdCooked: Bool = false
    @State var fourthCooked: Bool = false
    @State var fifthCooked: Bool = false
    @State var cookedSelected: Bool = false
    
    @State var cooked: Int = -1
    
    var screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color("background")
                        .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Spacer()
                        Text("3/7").bold().padding(20).foregroundColor(Color.secondary)
                    }
                    Spacer()
                }
                VStack (spacing: 20){
                    Image("Woman Cooking")
                        .resizable()
                        .scaledToFit()
                        .shadow(radius: 2)
                        .frame(minHeight: 100, idealHeight: 200, maxHeight: 300)
                    Text("Wie viele Mahlzeiten hast du gestern gekauft?")
                        .font(.system(size: screenWidth < 500 ? screenWidth * 0.06 : 26, weight: .medium))
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    HStack (spacing: 40) {
                        
                        Button(action: {
                            impact(style: .medium)
                            self.secondCooked = false
                            self.thirdCooked = false
                            self.fourthCooked = false
                            self.fifthCooked = false
                            
                            self.cookedSelected = true
                            self.firstCooked = true
                            
                            self.cooked = 0
                            
                        }) {
                            VStack {
                                Text("0")
                                    .font(.system(size: 18, weight: Font.Weight.medium))
                                    .foregroundColor(Color(self.firstCooked ? "white" : "black"))
                                Text("Mal")
                                    .font(.subheadline)
                                    .fixedSize()
                                    .foregroundColor(Color(self.firstCooked ? "white" : "black"))
                                    .multilineTextAlignment(.center)
                                    .padding(5)
                            }.frame(height: 60)
                                .padding(2)
                                .padding(.horizontal, 13)
                                .background(Color(firstCooked ? "blue" : "transparent"))
                                .cornerRadius(15)
                            
                        }
                        Button(action: {
                            impact(style: .medium)
                            self.firstCooked = false
                            self.thirdCooked = false
                            self.fourthCooked = false
                            self.fifthCooked = false
                            
                            self.cookedSelected = true
                            self.secondCooked = true
                            
                            self.cooked = 1
                        }) {
                            VStack {
                                Text("1")
                                    .font(.system(size: 18, weight: Font.Weight.medium))
                                    .foregroundColor(Color(self.secondCooked ? "white" : "black"))
                                Text("Mal")
                                    .font(.footnote)
                                    .fixedSize()
                                    .foregroundColor(Color(self.secondCooked ? "white" : "black"))
                                    .multilineTextAlignment(.center)
                                    .padding(5)
                            }.frame(height: 60)
                                .padding(2)
                                .padding(.horizontal, 13)
                                .background(Color(secondCooked ? "blue" : "transparent"))
                                .cornerRadius(15)
                            
                        }
                        Button(action: {
                            impact(style: .medium)
                            self.firstCooked = false
                            self.secondCooked = false
                            self.fourthCooked = false
                            self.fifthCooked = false
                            
                            self.cookedSelected = true
                            self.thirdCooked = true
                            
                            self.cooked = 2
                        }) {
                            VStack {
                                Text("2")
                                    .font(.system(size: 18, weight: Font.Weight.medium))
                                    .foregroundColor(Color(self.thirdCooked ? "white" : "black"))
                                Text("Mal")
                                    .font(.footnote)
                                    .fixedSize()
                                    .foregroundColor(Color(self.thirdCooked ? "white" : "black"))
                                    .multilineTextAlignment(.center)
                                    .padding(5)
                            }.frame(height: 60)
                                .padding(2)
                                .padding(.horizontal, 13)
                                .background(Color(thirdCooked ? "blue" : "transparent"))
                                .cornerRadius(15)
                        }
                    }.padding(.bottom, 10)
                    HStack (spacing: 40) {
                        Button(action: {
                            impact(style: .medium)
                            self.firstCooked = false
                            self.secondCooked = false
                            self.thirdCooked = false
                            self.fifthCooked = false
                            
                            self.cookedSelected = true
                            self.fourthCooked = true
                            
                            self.cooked = 3
                        }) {
                            VStack {
                                VStack {
                                    Text("3")
                                        .font(.system(size: 18, weight: Font.Weight.medium))
                                        .foregroundColor(Color(self.fourthCooked ? "white" : "black"))
                                    Text("Mal")
                                        .font(.footnote)
                                        .fixedSize()
                                        .foregroundColor(Color(self.fourthCooked ? "white" : "black"))
                                        .multilineTextAlignment(.center)
                                        .padding(5)
                                }.frame(height: 60)
                                    .padding(2)
                                    .padding(.horizontal, 13)
                                    .background(Color(fourthCooked ? "blue" : "transparent"))
                                    .cornerRadius(15)
                            }
                        }
                        Button(action: {
                            impact(style: .medium)
                            self.firstCooked = false
                            self.secondCooked = false
                            self.thirdCooked = false
                            self.fourthCooked = false
                            
                            self.cookedSelected = true
                            self.fifthCooked = true
                            
                            self.cooked = 4
                        }) {
                            VStack {
                                VStack {
                                    Text("4+")
                                        .font(.system(size: 18, weight: Font.Weight.medium))
                                        .foregroundColor(Color(self.fifthCooked ? "white" : "black"))
                                    Text("Mal")
                                        .font(.footnote)
                                        .fixedSize()
                                        .foregroundColor(Color(self.fifthCooked ? "white" : "black"))
                                        .multilineTextAlignment(.center)
                                        .padding(5)
                                }.frame(height: 60)
                                    .padding(2)
                                    .padding(.horizontal, 13)
                                    .background(Color(fifthCooked ? "blue" : "transparent"))
                                    .cornerRadius(15)
                            }
                        }
                    }
                    HStack {
                        Button (action: {
                            self.mode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.headline)
                                .padding(5)
                                .frame(width: 80, height: 40)
                        }
                        Spacer()
                        NavigationLink (destination: AddTagebuchCard4(tabViewSelected: $tabViewSelected, kilometer: kilometer, meat: meat, cooked: cooked).navigationBarBackButtonHidden(true)
                            .navigationBarTitle("")
                            .navigationBarHidden(true)){
                                Text("Überspringen")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                        }
                        Spacer()
                        NavigationLink (destination: AddTagebuchCard4(tabViewSelected: $tabViewSelected, kilometer: kilometer, meat: meat, cooked: cooked).navigationBarBackButtonHidden(true)
                            .navigationBarTitle("")
                            .navigationBarHidden(true)){
                                Image(systemName: "arrow.right")
                                    .font(.headline)
                                    .accentColor(Color(cookedSelected ? "white" :"white"))
                                    .padding(5)
                                    .frame(width: 80, height: 40)
                                    .background(Color(cookedSelected ? "blue" : "blueDisabled"))
                                    .cornerRadius(15)
                        }.disabled(!cookedSelected)
                    }
                    .padding(20)
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .accentColor(Color("black"))
            }
        }
    }
}

struct AddTagebuchCard3_Previews: PreviewProvider {
    static var previews: some View {
        AddTagebuchCard3(tabViewSelected: .constant(2), kilometer: 0, meat: 0)
    }
}
