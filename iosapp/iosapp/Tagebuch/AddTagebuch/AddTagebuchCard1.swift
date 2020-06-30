//
//  AddTagebuchCard1.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 20.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct AddLog: Codable, Hashable, Identifiable {
    let id: UUID
    let category: String
    let difficulty: String
    var name: String
    var quelle: String
}

struct AddTagebuchCard1: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State var firstKilometer: Bool = false
    @State var secondKilometer: Bool = false
    @State var thirdKilometer: Bool = false
    @State var fourthKilometer: Bool = false
    @State var fifthKilometer: Bool = false
    @State var kilometerSelected: Bool = false
    
    @State var kilometer: Int = 0
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color("background")
                        .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Spacer()
                        Text("1/7").bold().padding(20).foregroundColor(Color.secondary)
                    }
                    Spacer()
                }
                VStack (spacing: 20){
                    Image("Kilometer")
                        .resizable()
                        .scaledToFit()
                        .frame(minHeight: 100, idealHeight: 200, maxHeight: 300)
                    Text("Wie viele Kilometer bist du gestern mit dem Auto gefahren?")
                        .font(.system(size: 20, weight: Font.Weight.medium))
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    HStack (spacing: 20) {
                        
                        Button(action: {
                            impact(style: .medium)
                            self.secondKilometer = false
                            self.thirdKilometer = false
                            self.fourthKilometer = false
                            self.fifthKilometer = false
                            
                            self.kilometerSelected = true
                            self.firstKilometer = true
                            
                            self.kilometer = 0
                            
                        }) {
                            VStack {
                                Text("0")
                                    .font(.system(size: 18, weight: Font.Weight.medium))
                                    .foregroundColor(Color(self.firstKilometer ? "white" : "black"))
                                Text("Kilometer")
                                    .font(.subheadline)
                                    .fixedSize()
                                    .foregroundColor(Color(self.firstKilometer ? "white" : "black"))
                                    .multilineTextAlignment(.center)
                                    .padding(5)
                            }.frame(height: 60)
                                .padding(2)
                                .padding(.horizontal, 5)
                                .background(Color(firstKilometer ? "blue" : "transparent"))
                                .cornerRadius(15)
                            
                        }
                        Button(action: {
                            impact(style: .medium)
                            self.firstKilometer = false
                            self.thirdKilometer = false
                            self.fourthKilometer = false
                            self.fifthKilometer = false
                            
                            self.kilometerSelected = true
                            self.secondKilometer = true
                            
                            self.kilometer = 1
                        }) {
                            VStack {
                                Text("1-10")
                                    .font(.system(size: 18, weight: Font.Weight.medium))
                                    .foregroundColor(Color(self.secondKilometer ? "white" : "black"))
                                Text("Kilometer")
                                    .font(.footnote)
                                    .fixedSize()
                                    .foregroundColor(Color(self.secondKilometer ? "white" : "black"))
                                    .multilineTextAlignment(.center)
                                    .padding(5)
                            }.frame(height: 60)
                                .padding(2)
                                .padding(.horizontal, 5)
                                .background(Color(secondKilometer ? "blue" : "transparent"))
                                .cornerRadius(15)
                            
                        }
                        Button(action: {
                            impact(style: .medium)
                            self.firstKilometer = false
                            self.secondKilometer = false
                            self.fourthKilometer = false
                            self.fifthKilometer = false
                            
                            self.kilometerSelected = true
                            self.thirdKilometer = true
                            
                            self.kilometer = 2
                        }) {
                            VStack {
                                Text("11-20")
                                    .font(.system(size: 18, weight: Font.Weight.medium))
                                    .foregroundColor(Color(self.thirdKilometer ? "white" : "black"))
                                Text("Kilometer")
                                    .font(.footnote)
                                    .fixedSize()
                                    .foregroundColor(Color(self.thirdKilometer ? "white" : "black"))
                                    .multilineTextAlignment(.center)
                                    .padding(5)
                            }.frame(height: 60)
                                .padding(2)
                                .padding(.horizontal, 5)
                                .background(Color(thirdKilometer ? "blue" : "transparent"))
                                .cornerRadius(15)
                        }
                    }.padding(.bottom, 10)
                    HStack (spacing: 30) {
                        Button(action: {
                            impact(style: .medium)
                            self.firstKilometer = false
                            self.secondKilometer = false
                            self.thirdKilometer = false
                            self.fifthKilometer = false
                            
                            self.kilometerSelected = true
                            self.fourthKilometer = true
                            
                            self.kilometer = 3
                        }) {
                            VStack {
                                VStack {
                                    Text("21-50")
                                        .font(.system(size: 18, weight: Font.Weight.medium))
                                        .foregroundColor(Color(self.fourthKilometer ? "white" : "black"))
                                    Text("Kilometer")
                                        .font(.footnote)
                                        .fixedSize()
                                        .foregroundColor(Color(self.fourthKilometer ? "white" : "black"))
                                        .multilineTextAlignment(.center)
                                        .padding(5)
                                }.frame(height: 60)
                                    .padding(2)
                                    .padding(.horizontal, 5)
                                    .background(Color(fourthKilometer ? "blue" : "transparent"))
                                    .cornerRadius(15)
                            }
                        }
                        Button(action: {
                            impact(style: .medium)
                            self.firstKilometer = false
                            self.secondKilometer = false
                            self.thirdKilometer = false
                            self.fourthKilometer = false
                            
                            self.kilometerSelected = true
                            self.fifthKilometer = true
                            
                            self.kilometer = 4
                        }) {
                            VStack {
                                VStack {
                                    Text("50+")
                                        .font(.system(size: 18, weight: Font.Weight.medium))
                                        .foregroundColor(Color(self.fifthKilometer ? "white" : "black"))
                                    Text("Kilometer")
                                        .font(.footnote)
                                        .fixedSize()
                                        .foregroundColor(Color(self.fifthKilometer ? "white" : "black"))
                                        .multilineTextAlignment(.center)
                                        .padding(5)
                                }.frame(height: 60)
                                    .padding(2)
                                    .padding(.horizontal, 5)
                                    .background(Color(fifthKilometer ? "blue" : "transparent"))
                                    .cornerRadius(15)
                            }
                        }
                    }
                    HStack {
                        NavigationLink (destination: ContentView().navigationBarBackButtonHidden(true)
                            .navigationBarTitle("")
                            .navigationBarHidden(true)){
                                Image(systemName: "arrow.right")
                                    .font(.headline)
                                    .accentColor(Color(kilometerSelected ? "white" :"white"))
                                    .padding(5)
                                    .frame(width: 80, height: 40)
                                    .background(Color(kilometerSelected ? "blue" : "blueDisabled"))
                                    .cornerRadius(15)
                        }.opacity(0)
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

struct AddTagebuchCard1_Previews: PreviewProvider {
    static var previews: some View {
        AddTagebuchCard1()
    }
}
