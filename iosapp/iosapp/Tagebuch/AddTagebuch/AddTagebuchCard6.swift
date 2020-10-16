//
//  AddTagebuchCard2.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 20.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct AddTagebuchCard6: View {
    
    @Binding var tabViewSelected: Int
    
    var kilometer: Int
    var meat: Int
    var cooked: Int
    var foodWaste: Int
    var drinks: Int
    
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State var firstShower: Bool = false
    @State var secondShower: Bool = false
    @State var thirdShower: Bool = false
    @State var fourthShower: Bool = false
    @State var fifthShower: Bool = false
    @State var showerSelected: Bool = false
    
    @State var shower: Int = -1
    
    var screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color("background")
                        .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Spacer()
                        Text("6/7").bold().padding(20).foregroundColor(Color.secondary)
                    }
                    Spacer()
                }
                VStack (spacing: 20){
                    Image("Shower")
                        .resizable()
                        .scaledToFit()
                        .frame(minHeight: 100, idealHeight: 200, maxHeight: 300)
                        .shadow(radius: 2)
                    Text("Wie lange hast du gestern geduscht?")
                        .font(.system(size: screenWidth < 500 ? screenWidth * 0.06 : 26, weight: .medium))
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    HStack (spacing: 40) {
                        
                        Button(action: {
                            impact(style: .medium)
                            self.secondShower = false
                            self.thirdShower = false
                            self.fourthShower = false
                            self.fifthShower = false
                            
                            self.showerSelected = true
                            self.firstShower = true
                            
                            self.shower = 0
                            
                        }) {
                            VStack {
                                Text("0")
                                    .font(.system(size: 18, weight: Font.Weight.medium))
                                    .foregroundColor(Color(self.firstShower ? "white" : "black"))
                                Text("Minuten")
                                    .font(.subheadline)
                                    .fixedSize()
                                    .foregroundColor(Color(self.firstShower ? "white" : "black"))
                                    .multilineTextAlignment(.center)
                                    .padding(5)
                            }.frame(height: 60)
                                .padding(2)
                                .padding(.horizontal, 5)
                                .background(Color(firstShower ? "blue" : "transparent"))
                                .cornerRadius(15)
                            
                        }
                        Button(action: {
                            impact(style: .medium)
                            self.firstShower = false
                            self.thirdShower = false
                            self.fourthShower = false
                            self.fifthShower = false
                            
                            self.showerSelected = true
                            self.secondShower = true
                            
                            self.shower = 1
                        }) {
                            VStack {
                                Text("5")
                                    .font(.system(size: 18, weight: Font.Weight.medium))
                                    .foregroundColor(Color(self.secondShower ? "white" : "black"))
                                Text("Minuten")
                                    .font(.footnote)
                                    .fixedSize()
                                    .foregroundColor(Color(self.secondShower ? "white" : "black"))
                                    .multilineTextAlignment(.center)
                                    .padding(5)
                            }.frame(height: 60)
                                .padding(2)
                                .padding(.horizontal, 5)
                                .background(Color(secondShower ? "blue" : "transparent"))
                                .cornerRadius(15)
                            
                        }
                        Button(action: {
                            impact(style: .medium)
                            self.firstShower = false
                            self.secondShower = false
                            self.fourthShower = false
                            self.fifthShower = false
                            
                            self.showerSelected = true
                            self.thirdShower = true
                            
                            self.shower = 2
                        }) {
                            VStack {
                                Text("10")
                                    .font(.system(size: 18, weight: Font.Weight.medium))
                                    .foregroundColor(Color(self.thirdShower ? "white" : "black"))
                                Text("Minuten")
                                    .font(.footnote)
                                    .fixedSize()
                                    .foregroundColor(Color(self.thirdShower ? "white" : "black"))
                                    .multilineTextAlignment(.center)
                                    .padding(5)
                            }.frame(height: 60)
                                .padding(2)
                                .padding(.horizontal, 5)
                                .background(Color(thirdShower ? "blue" : "transparent"))
                                .cornerRadius(15)
                        }
                    }.padding(.bottom, 10)
                    HStack (spacing: 40) {
                        Button(action: {
                            impact(style: .medium)
                            self.firstShower = false
                            self.secondShower = false
                            self.thirdShower = false
                            self.fifthShower = false
                            
                            self.showerSelected = true
                            self.fourthShower = true
                            
                            self.shower = 3
                        }) {
                            VStack {
                                VStack {
                                    Text("15")
                                        .font(.system(size: 18, weight: Font.Weight.medium))
                                        .foregroundColor(Color(self.fourthShower ? "white" : "black"))
                                    Text("Minuten")
                                        .font(.footnote)
                                        .fixedSize()
                                        .foregroundColor(Color(self.fourthShower ? "white" : "black"))
                                        .multilineTextAlignment(.center)
                                        .padding(5)
                                }.frame(height: 60)
                                    .padding(2)
                                    .padding(.horizontal, 5)
                                    .background(Color(fourthShower ? "blue" : "transparent"))
                                    .cornerRadius(15)
                            }
                        }
                        Button(action: {
                            impact(style: .medium)
                            self.firstShower = false
                            self.secondShower = false
                            self.thirdShower = false
                            self.fourthShower = false
                            
                            self.showerSelected = true
                            self.fifthShower = true
                            
                            self.shower = 4
                        }) {
                            VStack {
                                VStack {
                                    Text("20+")
                                        .font(.system(size: 18, weight: Font.Weight.medium))
                                        .foregroundColor(Color(self.fifthShower ? "white" : "black"))
                                    Text("Minuten")
                                        .font(.footnote)
                                        .fixedSize()
                                        .foregroundColor(Color(self.fifthShower ? "white" : "black"))
                                        .multilineTextAlignment(.center)
                                        .padding(5)
                                }.frame(height: 60)
                                    .padding(2)
                                    .padding(.horizontal, 5)
                                    .background(Color(fifthShower ? "blue" : "transparent"))
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
                        NavigationLink (destination: AddTagebuchCard7(tabViewSelected: $tabViewSelected, kilometer: kilometer, meat: meat, cooked: cooked, foodWaste: foodWaste, drinks: drinks, shower: shower).navigationBarBackButtonHidden(true)
                            .navigationBarTitle("")
                            .navigationBarHidden(true)){
                                Text("Überspringen")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                        }
                        Spacer()
                        NavigationLink (destination: AddTagebuchCard7(tabViewSelected: $tabViewSelected, kilometer: kilometer, meat: meat, cooked: cooked, foodWaste: foodWaste, drinks: drinks, shower: shower).navigationBarBackButtonHidden(true)
                            .navigationBarTitle("")
                            .navigationBarHidden(true)){
                                Image(systemName: "arrow.right")
                                    .font(.headline)
                                    .accentColor(Color(showerSelected ? "white" :"white"))
                                    .padding(5)
                                    .frame(width: 80, height: 40)
                                    .background(Color(showerSelected ? "blue" : "blueDisabled"))
                                    .cornerRadius(15)
                        }.disabled(!showerSelected)
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

struct AddTagebuchCard6_Previews: PreviewProvider {
    static var previews: some View {
        AddTagebuchCard6(tabViewSelected: .constant(2), kilometer: 0, meat: 0, cooked: 0, foodWaste: 0, drinks: 0)
    }
}
