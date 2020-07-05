//
//  AddTagebuchCard2.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 20.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct AddTagebuchCard2: View {
    
    @Binding var tabViewSelected: Int
    
    var kilometer: Int
    
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State var firstMeat: Bool = false
    @State var secondMeat: Bool = false
    @State var thirdMeat: Bool = false
    @State var fourthMeat: Bool = false
    @State var fifthMeat: Bool = false
    @State var kilometerSelected: Bool = false
    
    @State var meat: Int = -1
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color("background")
                        .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Spacer()
                        Text("2/7").bold().padding(20).foregroundColor(Color.secondary)
                    }
                    Spacer()
                }
                VStack (spacing: 20){
                    Image("IErnährung")
                        .resizable()
                        .scaledToFit()
                        .shadow(radius: 2)
                        .frame(minHeight: 100, idealHeight: 200, maxHeight: 300)
                    Text("Wie oft hast du gestern Fleisch gegessen?")
                        .font(.system(size: 20, weight: Font.Weight.medium))
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    HStack (spacing: 40) {
                        
                        Button(action: {
                            impact(style: .medium)
                            self.secondMeat = false
                            self.thirdMeat = false
                            self.fourthMeat = false
                            self.fifthMeat = false
                            
                            self.kilometerSelected = true
                            self.firstMeat = true
                            
                            self.meat = 0
                            
                        }) {
                            VStack {
                                Text("0")
                                    .font(.system(size: 18, weight: Font.Weight.medium))
                                    .foregroundColor(Color(self.firstMeat ? "white" : "black"))
                                Text("Mal")
                                    .font(.subheadline)
                                    .fixedSize()
                                    .foregroundColor(Color(self.firstMeat ? "white" : "black"))
                                    .multilineTextAlignment(.center)
                                    .padding(5)
                            }.frame(height: 60)
                                .padding(2)
                                .padding(.horizontal, 13)
                                .background(Color(firstMeat ? "blue" : "transparent"))
                                .cornerRadius(15)
                            
                        }
                        Button(action: {
                            impact(style: .medium)
                            self.firstMeat = false
                            self.thirdMeat = false
                            self.fourthMeat = false
                            self.fifthMeat = false
                            
                            self.kilometerSelected = true
                            self.secondMeat = true
                            
                            self.meat = 1
                        }) {
                            VStack {
                                Text("1")
                                    .font(.system(size: 18, weight: Font.Weight.medium))
                                    .foregroundColor(Color(self.secondMeat ? "white" : "black"))
                                Text("Mal")
                                    .font(.footnote)
                                    .fixedSize()
                                    .foregroundColor(Color(self.secondMeat ? "white" : "black"))
                                    .multilineTextAlignment(.center)
                                    .padding(5)
                            }.frame(height: 60)
                                .padding(2)
                                .padding(.horizontal, 13)
                                .background(Color(secondMeat ? "blue" : "transparent"))
                                .cornerRadius(15)
                            
                        }
                        Button(action: {
                            impact(style: .medium)
                            self.firstMeat = false
                            self.secondMeat = false
                            self.fourthMeat = false
                            self.fifthMeat = false
                            
                            self.kilometerSelected = true
                            self.thirdMeat = true
                            
                            self.meat = 2
                        }) {
                            VStack {
                                Text("2")
                                    .font(.system(size: 18, weight: Font.Weight.medium))
                                    .foregroundColor(Color(self.thirdMeat ? "white" : "black"))
                                Text("Mal")
                                    .font(.footnote)
                                    .fixedSize()
                                    .foregroundColor(Color(self.thirdMeat ? "white" : "black"))
                                    .multilineTextAlignment(.center)
                                    .padding(5)
                            }.frame(height: 60)
                                .padding(2)
                                .padding(.horizontal, 13)
                                .background(Color(thirdMeat ? "blue" : "transparent"))
                                .cornerRadius(15)
                        }
                    }.padding(.bottom, 10)
                    HStack (spacing: 40) {
                        Button(action: {
                            impact(style: .medium)
                            self.firstMeat = false
                            self.secondMeat = false
                            self.thirdMeat = false
                            self.fifthMeat = false
                            
                            self.kilometerSelected = true
                            self.fourthMeat = true
                            
                            self.meat = 3
                        }) {
                            VStack {
                                VStack {
                                    Text("3")
                                        .font(.system(size: 18, weight: Font.Weight.medium))
                                        .foregroundColor(Color(self.fourthMeat ? "white" : "black"))
                                    Text("Mal")
                                        .font(.footnote)
                                        .fixedSize()
                                        .foregroundColor(Color(self.fourthMeat ? "white" : "black"))
                                        .multilineTextAlignment(.center)
                                        .padding(5)
                                }.frame(height: 60)
                                    .padding(2)
                                    .padding(.horizontal, 13)
                                    .background(Color(fourthMeat ? "blue" : "transparent"))
                                    .cornerRadius(15)
                            }
                        }
                        Button(action: {
                            impact(style: .medium)
                            self.firstMeat = false
                            self.secondMeat = false
                            self.thirdMeat = false
                            self.fourthMeat = false
                            
                            self.kilometerSelected = true
                            self.fifthMeat = true
                            
                            self.meat = 4
                        }) {
                            VStack {
                                VStack {
                                    Text("4+")
                                        .font(.system(size: 18, weight: Font.Weight.medium))
                                        .foregroundColor(Color(self.fifthMeat ? "white" : "black"))
                                    Text("Mal")
                                        .font(.footnote)
                                        .fixedSize()
                                        .foregroundColor(Color(self.fifthMeat ? "white" : "black"))
                                        .multilineTextAlignment(.center)
                                        .padding(5)
                                }.frame(height: 60)
                                    .padding(2)
                                    .padding(.horizontal, 13)
                                    .background(Color(fifthMeat ? "blue" : "transparent"))
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
                        NavigationLink (destination: AddTagebuchCard3(tabViewSelected: $tabViewSelected, kilometer: kilometer, meat: meat).navigationBarBackButtonHidden(true)
                            .navigationBarTitle("")
                            .navigationBarHidden(true)){
                                Text("Überspringen")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                        }
                        Spacer()
                        NavigationLink (destination: AddTagebuchCard3(tabViewSelected: $tabViewSelected, kilometer: kilometer, meat: meat).navigationBarBackButtonHidden(true)
                            .navigationBarTitle("")
                            .navigationBarHidden(true)){
                                Image(systemName: "arrow.right")
                                    .font(.headline)
                                    .accentColor(Color(kilometerSelected ? "white" :"white"))
                                    .padding(5)
                                    .frame(width: 80, height: 40)
                                    .background(Color(kilometerSelected ? "blue" : "blueDisabled"))
                                    .cornerRadius(15)
                        }.disabled(!kilometerSelected)
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

struct AddTagebuchCard2_Previews: PreviewProvider {
    static var previews: some View {
        AddTagebuchCard2(tabViewSelected: .constant(2), kilometer: 0)
    }
}
