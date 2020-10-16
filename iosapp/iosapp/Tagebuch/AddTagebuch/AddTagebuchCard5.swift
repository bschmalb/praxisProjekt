//
//  AddTagebuchCard2.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 20.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct AddTagebuchCard5: View {
    
    @Binding var tabViewSelected: Int
    
    var kilometer: Int
    var meat: Int
    var cooked: Int
    var foodWaste: Int
    
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State var firstDrinks: Bool = false
    @State var secondDrinks: Bool = false
    @State var thirdDrinks: Bool = false
    @State var fourthDrinks: Bool = false
    @State var fifthDrinks: Bool = false
    @State var drinksSelected: Bool = false
    
    @State var drinks: Int = -1
    
    var screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color("background")
                        .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Spacer()
                        Text("5/7").bold().padding(20).foregroundColor(Color.secondary)
                    }
                    Spacer()
                }
                VStack (spacing: 20){
                    Image("Drink")
                        .resizable()
                        .scaledToFit()
                        .frame(minHeight: 100, idealHeight: 200, maxHeight: 300)
                        .shadow(radius: 2)
                    Text("Wie viel Liter gekaufte Getränke hast du gestern getrunken?")
                        .font(.system(size: screenWidth < 500 ? screenWidth * 0.06 : 26, weight: .medium))
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    HStack (spacing: 40) {
                        
                        Button(action: {
                            impact(style: .medium)
                            self.secondDrinks = false
                            self.thirdDrinks = false
                            self.fourthDrinks = false
                            self.fifthDrinks = false
                            
                            self.drinksSelected = true
                            self.firstDrinks = true
                            
                            self.drinks = 0
                            
                        }) {
                            VStack {
                                Text("0")
                                    .font(.system(size: 18, weight: Font.Weight.medium))
                                    .foregroundColor(Color(self.firstDrinks ? "white" : "black"))
                                Text("Liter")
                                    .font(.subheadline)
                                    .fixedSize()
                                    .foregroundColor(Color(self.firstDrinks ? "white" : "black"))
                                    .multilineTextAlignment(.center)
                                    .padding(5)
                            }.frame(height: 60)
                                .padding(2)
                                .padding(.horizontal, 13)
                                .background(Color(firstDrinks ? "blue" : "transparent"))
                                .cornerRadius(15)
                            
                        }
                        Button(action: {
                            impact(style: .medium)
                            self.firstDrinks = false
                            self.thirdDrinks = false
                            self.fourthDrinks = false
                            self.fifthDrinks = false
                            
                            self.drinksSelected = true
                            self.secondDrinks = true
                            
                            self.drinks = 1
                        }) {
                            VStack {
                                Text("0,5")
                                    .font(.system(size: 18, weight: Font.Weight.medium))
                                    .foregroundColor(Color(self.secondDrinks ? "white" : "black"))
                                Text("Liter")
                                    .font(.footnote)
                                    .fixedSize()
                                    .foregroundColor(Color(self.secondDrinks ? "white" : "black"))
                                    .multilineTextAlignment(.center)
                                    .padding(5)
                            }.frame(height: 60)
                                .padding(2)
                                .padding(.horizontal, 13)
                                .background(Color(secondDrinks ? "blue" : "transparent"))
                                .cornerRadius(15)
                            
                        }
                        Button(action: {
                            impact(style: .medium)
                            self.firstDrinks = false
                            self.secondDrinks = false
                            self.fourthDrinks = false
                            self.fifthDrinks = false
                            
                            self.drinksSelected = true
                            self.thirdDrinks = true
                            
                            self.drinks = 2
                        }) {
                            VStack {
                                Text("1")
                                    .font(.system(size: 18, weight: Font.Weight.medium))
                                    .foregroundColor(Color(self.thirdDrinks ? "white" : "black"))
                                Text("Liter")
                                    .font(.footnote)
                                    .fixedSize()
                                    .foregroundColor(Color(self.thirdDrinks ? "white" : "black"))
                                    .multilineTextAlignment(.center)
                                    .padding(5)
                            }.frame(height: 60)
                                .padding(2)
                                .padding(.horizontal, 13)
                                .background(Color(thirdDrinks ? "blue" : "transparent"))
                                .cornerRadius(15)
                        }
                    }.padding(.bottom, 10)
                    HStack (spacing: 40) {
                        Button(action: {
                            impact(style: .medium)
                            self.firstDrinks = false
                            self.secondDrinks = false
                            self.thirdDrinks = false
                            self.fifthDrinks = false
                            
                            self.drinksSelected = true
                            self.fourthDrinks = true
                            
                            self.drinks = 3
                        }) {
                            VStack {
                                VStack {
                                    Text("1.5")
                                        .font(.system(size: 18, weight: Font.Weight.medium))
                                        .foregroundColor(Color(self.fourthDrinks ? "white" : "black"))
                                    Text("Liter")
                                        .font(.footnote)
                                        .fixedSize()
                                        .foregroundColor(Color(self.fourthDrinks ? "white" : "black"))
                                        .multilineTextAlignment(.center)
                                        .padding(5)
                                }.frame(height: 60)
                                    .padding(2)
                                    .padding(.horizontal, 13)
                                    .background(Color(fourthDrinks ? "blue" : "transparent"))
                                    .cornerRadius(15)
                            }
                        }
                        Button(action: {
                            impact(style: .medium)
                            self.firstDrinks = false
                            self.secondDrinks = false
                            self.thirdDrinks = false
                            self.fourthDrinks = false
                            
                            self.drinksSelected = true
                            self.fifthDrinks = true
                            
                            self.drinks = 4
                        }) {
                            VStack {
                                VStack {
                                    Text("2+")
                                        .font(.system(size: 18, weight: Font.Weight.medium))
                                        .foregroundColor(Color(self.fifthDrinks ? "white" : "black"))
                                    Text("Liter")
                                        .font(.footnote)
                                        .fixedSize()
                                        .foregroundColor(Color(self.fifthDrinks ? "white" : "black"))
                                        .multilineTextAlignment(.center)
                                        .padding(5)
                                }.frame(height: 60)
                                    .padding(2)
                                    .padding(.horizontal, 13)
                                    .background(Color(fifthDrinks ? "blue" : "transparent"))
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
                        NavigationLink (destination: AddTagebuchCard6(tabViewSelected: $tabViewSelected, kilometer: kilometer, meat: meat, cooked: cooked, foodWaste: foodWaste, drinks: drinks).navigationBarBackButtonHidden(true)
                            .navigationBarTitle("")
                            .navigationBarHidden(true)){
                                Text("Überspringen")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                        }
                        Spacer()
                        NavigationLink (destination: AddTagebuchCard6(tabViewSelected: $tabViewSelected, kilometer: kilometer, meat: meat, cooked: cooked, foodWaste: foodWaste, drinks: drinks).navigationBarBackButtonHidden(true)
                            .navigationBarTitle("")
                            .navigationBarHidden(true)){
                                Image(systemName: "arrow.right")
                                    .font(.headline)
                                    .accentColor(Color(drinksSelected ? "white" :"white"))
                                    .padding(5)
                                    .frame(width: 80, height: 40)
                                    .background(Color(drinksSelected ? "blue" : "blueDisabled"))
                                    .cornerRadius(15)
                        }.disabled(!drinksSelected)
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

struct AddTagebuchCard5_Previews: PreviewProvider {
    static var previews: some View {
        AddTagebuchCard5(tabViewSelected: .constant(2), kilometer: 0, meat: 0, cooked: 0, foodWaste: 0)
    }
}
