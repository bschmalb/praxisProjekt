//
//  AddTagebuchCard2.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 20.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct AddTagebuchCard4: View {
    
    @Binding var tabViewSelected: Int
    
    var kilometer: Int
    var meat: Int
    var cooked: Int
    
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State var firstFoodWaste: Bool = false
    @State var secondFoodWaste: Bool = false
    @State var thirdFoodWaste: Bool = false
    @State var fourthFoodWaste: Bool = false
    @State var fifthFoodWaste: Bool = false
    @State var foodWasteSelected: Bool = false
    
    @State var foodWaste: Int = -1
    
    var screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color("background")
                        .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Spacer()
                        Text("4/7").bold().padding(20).foregroundColor(Color.secondary)
                    }
                    Spacer()
                }
                VStack (spacing: 20){
                    Image("IRecycling")
                        .resizable()
                        .scaledToFit()
                        .shadow(radius: 2)
                        .frame(minHeight: 100, idealHeight: 200, maxHeight: 300)
                    Text("Bei wie vielen Malzeiten hast du Reste weggeschmissen?")
                        .font(.system(size: screenWidth < 500 ? screenWidth * 0.06 : 26, weight: .medium))
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    HStack (spacing: 40) {
                        
                        Button(action: {
                            impact(style: .medium)
                            self.secondFoodWaste = false
                            self.thirdFoodWaste = false
                            self.fourthFoodWaste = false
                            self.fifthFoodWaste = false
                            
                            self.foodWasteSelected = true
                            self.firstFoodWaste = true
                            
                            self.foodWaste = 0
                            
                        }) {
                            VStack {
                                Text("0")
                                    .font(.system(size: 18, weight: Font.Weight.medium))
                                    .foregroundColor(Color(self.firstFoodWaste ? "white" : "black"))
                                Text("Mal")
                                    .font(.subheadline)
                                    .fixedSize()
                                    .foregroundColor(Color(self.firstFoodWaste ? "white" : "black"))
                                    .multilineTextAlignment(.center)
                                    .padding(5)
                            }.frame(height: 60)
                                .padding(2)
                                .padding(.horizontal, 13)
                                .background(Color(firstFoodWaste ? "blue" : "transparent"))
                                .cornerRadius(15)
                            
                        }
                        Button(action: {
                            impact(style: .medium)
                            self.firstFoodWaste = false
                            self.thirdFoodWaste = false
                            self.fourthFoodWaste = false
                            self.fifthFoodWaste = false
                            
                            self.foodWasteSelected = true
                            self.secondFoodWaste = true
                            
                            self.foodWaste = 1
                        }) {
                            VStack {
                                Text("1")
                                    .font(.system(size: 18, weight: Font.Weight.medium))
                                    .foregroundColor(Color(self.secondFoodWaste ? "white" : "black"))
                                Text("Mal")
                                    .font(.footnote)
                                    .fixedSize()
                                    .foregroundColor(Color(self.secondFoodWaste ? "white" : "black"))
                                    .multilineTextAlignment(.center)
                                    .padding(5)
                            }.frame(height: 60)
                                .padding(2)
                                .padding(.horizontal, 13)
                                .background(Color(secondFoodWaste ? "blue" : "transparent"))
                                .cornerRadius(15)
                            
                        }
                        Button(action: {
                            impact(style: .medium)
                            self.firstFoodWaste = false
                            self.secondFoodWaste = false
                            self.fourthFoodWaste = false
                            self.fifthFoodWaste = false
                            
                            self.foodWasteSelected = true
                            self.thirdFoodWaste = true
                            
                            self.foodWaste = 2
                        }) {
                            VStack {
                                Text("2")
                                    .font(.system(size: 18, weight: Font.Weight.medium))
                                    .foregroundColor(Color(self.thirdFoodWaste ? "white" : "black"))
                                Text("Mal")
                                    .font(.footnote)
                                    .fixedSize()
                                    .foregroundColor(Color(self.thirdFoodWaste ? "white" : "black"))
                                    .multilineTextAlignment(.center)
                                    .padding(5)
                            }.frame(height: 60)
                                .padding(2)
                                .padding(.horizontal, 13)
                                .background(Color(thirdFoodWaste ? "blue" : "transparent"))
                                .cornerRadius(15)
                        }
                    }.padding(.bottom, 10)
                    HStack (spacing: 40) {
                        Button(action: {
                            impact(style: .medium)
                            self.firstFoodWaste = false
                            self.secondFoodWaste = false
                            self.thirdFoodWaste = false
                            self.fifthFoodWaste = false
                            
                            self.foodWasteSelected = true
                            self.fourthFoodWaste = true
                            
                            self.foodWaste = 3
                        }) {
                            VStack {
                                VStack {
                                    Text("3")
                                        .font(.system(size: 18, weight: Font.Weight.medium))
                                        .foregroundColor(Color(self.fourthFoodWaste ? "white" : "black"))
                                    Text("Mal")
                                        .font(.footnote)
                                        .fixedSize()
                                        .foregroundColor(Color(self.fourthFoodWaste ? "white" : "black"))
                                        .multilineTextAlignment(.center)
                                        .padding(5)
                                }.frame(height: 60)
                                    .padding(2)
                                    .padding(.horizontal, 13)
                                    .background(Color(fourthFoodWaste ? "blue" : "transparent"))
                                    .cornerRadius(15)
                            }
                        }
                        Button(action: {
                            impact(style: .medium)
                            self.firstFoodWaste = false
                            self.secondFoodWaste = false
                            self.thirdFoodWaste = false
                            self.fourthFoodWaste = false
                            
                            self.foodWasteSelected = true
                            self.fifthFoodWaste = true
                            
                            self.foodWaste = 4
                        }) {
                            VStack {
                                VStack {
                                    Text("4+")
                                        .font(.system(size: 18, weight: Font.Weight.medium))
                                        .foregroundColor(Color(self.fifthFoodWaste ? "white" : "black"))
                                    Text("Mal")
                                        .font(.footnote)
                                        .fixedSize()
                                        .foregroundColor(Color(self.fifthFoodWaste ? "white" : "black"))
                                        .multilineTextAlignment(.center)
                                        .padding(5)
                                }.frame(height: 60)
                                    .padding(2)
                                    .padding(.horizontal, 13)
                                    .background(Color(fifthFoodWaste ? "blue" : "transparent"))
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
                        NavigationLink (destination: AddTagebuchCard5(tabViewSelected: $tabViewSelected, kilometer: kilometer, meat: meat, cooked: cooked, foodWaste: foodWaste).navigationBarBackButtonHidden(true)
                            .navigationBarTitle("")
                            .navigationBarHidden(true)){
                                Text("Überspringen")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                        }
                        Spacer()
                        NavigationLink (destination: AddTagebuchCard5(tabViewSelected: $tabViewSelected, kilometer: kilometer, meat: meat, cooked: cooked, foodWaste: foodWaste).navigationBarBackButtonHidden(true)
                            .navigationBarTitle("")
                            .navigationBarHidden(true)){
                                Image(systemName: "arrow.right")
                                    .font(.headline)
                                    .accentColor(Color(foodWasteSelected ? "white" :"white"))
                                    .padding(5)
                                    .frame(width: 80, height: 40)
                                    .background(Color(foodWasteSelected ? "blue" : "blueDisabled"))
                                    .cornerRadius(15)
                        }.disabled(!foodWasteSelected)
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

struct AddTagebuchCard4_Previews: PreviewProvider {
    static var previews: some View {
        AddTagebuchCard4(tabViewSelected: .constant(2), kilometer: 0, meat: 0, cooked: 0)
    }
}
