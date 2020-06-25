//
//  AddTagebuchCard2.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 20.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct AddTagebuchCard2: View {
    
    var kilometer: Int
    
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State var firstFleisch: Bool = false
    @State var secondFleisch: Bool = false
    @State var thirdFleisch: Bool = false
    @State var fourthFleisch: Bool = false
    @State var fifthFleisch: Bool = false
    @State var kilometerSelected: Bool = false
    
    @State var fleisch: Int = 0
    
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
                        .frame(minHeight: 100, idealHeight: 200, maxHeight: 300)
                    Text("Wie oft hast du gestern Fleisch gegessen?")
                        .font(.system(size: 20, weight: Font.Weight.medium))
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    HStack (spacing: 40) {
                        
                        Button(action: {
                            haptic(type: .success)
                            self.secondFleisch = false
                            self.thirdFleisch = false
                            self.fourthFleisch = false
                            self.fifthFleisch = false
                            
                            self.kilometerSelected = true
                            self.firstFleisch = true
                            
                            self.fleisch = 0
                            
                        }) {
                            VStack {
                                Text("0")
                                    .font(.system(size: 18, weight: Font.Weight.medium))
                                    .foregroundColor(Color(self.firstFleisch ? "white" : "black"))
                                Text("Mal")
                                    .font(.subheadline)
                                    .fixedSize()
                                    .foregroundColor(Color(self.firstFleisch ? "white" : "black"))
                                    .multilineTextAlignment(.center)
                                    .padding(5)
                            }.frame(height: 60)
                                .padding(2)
                                .padding(.horizontal, 13)
                                .background(Color(firstFleisch ? "blue" : "transparent"))
                                .cornerRadius(15)
                            
                        }
                        Button(action: {
                            haptic(type: .success)
                            self.firstFleisch = false
                            self.thirdFleisch = false
                            self.fourthFleisch = false
                            self.fifthFleisch = false
                            
                            self.kilometerSelected = true
                            self.secondFleisch = true
                            
                            self.fleisch = 1
                        }) {
                            VStack {
                                Text("1")
                                    .font(.system(size: 18, weight: Font.Weight.medium))
                                    .foregroundColor(Color(self.secondFleisch ? "white" : "black"))
                                Text("Mal")
                                    .font(.footnote)
                                    .fixedSize()
                                    .foregroundColor(Color(self.secondFleisch ? "white" : "black"))
                                    .multilineTextAlignment(.center)
                                    .padding(5)
                            }.frame(height: 60)
                                .padding(2)
                                .padding(.horizontal, 13)
                                .background(Color(secondFleisch ? "blue" : "transparent"))
                                .cornerRadius(15)
                            
                        }
                        Button(action: {
                            haptic(type: .success)
                            self.firstFleisch = false
                            self.secondFleisch = false
                            self.fourthFleisch = false
                            self.fifthFleisch = false
                            
                            self.kilometerSelected = true
                            self.thirdFleisch = true
                            
                            self.fleisch = 2
                        }) {
                            VStack {
                                Text("2")
                                    .font(.system(size: 18, weight: Font.Weight.medium))
                                    .foregroundColor(Color(self.thirdFleisch ? "white" : "black"))
                                Text("Mal")
                                    .font(.footnote)
                                    .fixedSize()
                                    .foregroundColor(Color(self.thirdFleisch ? "white" : "black"))
                                    .multilineTextAlignment(.center)
                                    .padding(5)
                            }.frame(height: 60)
                                .padding(2)
                                .padding(.horizontal, 13)
                                .background(Color(thirdFleisch ? "blue" : "transparent"))
                                .cornerRadius(15)
                        }
                    }.padding(.bottom, 10)
                    HStack (spacing: 40) {
                        Button(action: {
                            haptic(type: .success)
                            self.firstFleisch = false
                            self.secondFleisch = false
                            self.thirdFleisch = false
                            self.fifthFleisch = false
                            
                            self.kilometerSelected = true
                            self.fourthFleisch = true
                            
                            self.fleisch = 3
                        }) {
                            VStack {
                                VStack {
                                    Text("3")
                                        .font(.system(size: 18, weight: Font.Weight.medium))
                                        .foregroundColor(Color(self.fourthFleisch ? "white" : "black"))
                                    Text("Mal")
                                        .font(.footnote)
                                        .fixedSize()
                                        .foregroundColor(Color(self.fourthFleisch ? "white" : "black"))
                                        .multilineTextAlignment(.center)
                                        .padding(5)
                                }.frame(height: 60)
                                    .padding(2)
                                    .padding(.horizontal, 13)
                                    .background(Color(fourthFleisch ? "blue" : "transparent"))
                                    .cornerRadius(15)
                            }
                        }
                        Button(action: {
                            haptic(type: .success)
                            self.firstFleisch = false
                            self.secondFleisch = false
                            self.thirdFleisch = false
                            self.fourthFleisch = false
                            
                            self.kilometerSelected = true
                            self.fifthFleisch = true
                            
                            self.fleisch = 4
                        }) {
                            VStack {
                                VStack {
                                    Text("4+")
                                        .font(.system(size: 18, weight: Font.Weight.medium))
                                        .foregroundColor(Color(self.fifthFleisch ? "white" : "black"))
                                    Text("Mal")
                                        .font(.footnote)
                                        .fixedSize()
                                        .foregroundColor(Color(self.fifthFleisch ? "white" : "black"))
                                        .multilineTextAlignment(.center)
                                        .padding(5)
                                }.frame(height: 60)
                                    .padding(2)
                                    .padding(.horizontal, 13)
                                    .background(Color(fifthFleisch ? "blue" : "transparent"))
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
                        NavigationLink (destination: AddTagebuchCard2(kilometer: kilometer).navigationBarBackButtonHidden(true)
                            .navigationBarTitle("")
                            .navigationBarHidden(true)){
                                Text("Überspringen")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                        }
                        Spacer()
                        NavigationLink (destination: AddTagebuchCard2(kilometer: kilometer).navigationBarBackButtonHidden(true)
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
        AddTagebuchCard2(kilometer: 0)
    }
}
