//
//  AddTagebuchCard1.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 20.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct AddTagebuchCard1: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State var selection: Int? = 0
    
    @Binding var tabViewSelected: Int
    
    @State var kilometer: Int = -1
    
    var screenWidth = UIScreen.main.bounds.width
    
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
                        .shadow(radius: 2)
                        .frame(minHeight: 100, idealHeight: 200, maxHeight: 300)
                    Text("Wie viele Kilometer bist du gestern mit dem Auto gefahren?")
                        .font(.system(size: screenWidth < 500 ? screenWidth * 0.06 : 26, weight: .medium))
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    HStack (spacing: 20) {
                        
                        Button(action: {
                            impact(style: .medium)
                            self.kilometer = 0
                            
                        }) {
                            TagebuchButton(name: "0", einheit: "Kilometer", selected: kilometer, selectedAmount: 0)
                        }
                        Button(action: {
                            impact(style: .medium)
                            self.kilometer = 1
                        }) {
                            TagebuchButton(name: "1-10", einheit: "Kilometer", selected: kilometer, selectedAmount: 1)
                        }
                        Button(action: {
                            impact(style: .medium)
                            self.kilometer = 2
                        }) {
                            TagebuchButton(name: "11-20", einheit: "Kilometer", selected: kilometer, selectedAmount: 2)
                        }
                    }.padding(.bottom, 10)
                    HStack (spacing: 30) {
                        Button(action: {
                            impact(style: .medium)
                            self.kilometer = 3
                        }) {
                            TagebuchButton(name: "21-50", einheit: "Kilometer", selected: kilometer, selectedAmount: 3)
                        }
                        Button(action: {
                            impact(style: .medium)
                            self.kilometer = 4
                        }) {
                            TagebuchButton(name: "50+", einheit: "Kilometer", selected: kilometer, selectedAmount: 4)
                        }
                    }
                    HStack {
                        NavigationLink (destination: ContentView().navigationBarBackButtonHidden(true)
                            .navigationBarTitle("")
                            .navigationBarHidden(true)){
                                Image(systemName: "arrow.right")
                                    .font(.headline)
                                    .accentColor(Color(kilometer > -1 ? "white" :"white"))
                                    .padding(5)
                                    .frame(width: 80, height: 40)
                                    .background(Color(kilometer > -1 ? "blue" : "blueDisabled"))
                                    .cornerRadius(15)
                        }.opacity(0)
                        Spacer()
                        NavigationLink (destination: AddTagebuchCard2(tabViewSelected: $tabViewSelected, kilometer: kilometer).navigationBarBackButtonHidden(true)
                            .navigationBarTitle("")
                            .navigationBarHidden(true)){
                                Text("Überspringen")
                                    .font(.system(size: screenWidth < 500 ? screenWidth * 0.035 : 14, weight: .light))
                                    .foregroundColor(.secondary)
                        }
                        Spacer()
                        NavigationLink (destination: AddTagebuchCard2(tabViewSelected: $tabViewSelected, kilometer: kilometer).navigationBarBackButtonHidden(true)
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                        , tag: 1, selection: $selection) {
                            Button(action: {
                                impact(style: .medium)
                                self.selection = 1
                            }) {
                                Image(systemName: "arrow.right")
                                    .font(.headline)
                                    .accentColor(Color(kilometer > -1 ? "white" :"white"))
                                    .padding(5)
                                    .frame(width: 80, height: 40)
                                    .background(Color(kilometer > -1 ? "blue" : "blueDisabled"))
                                    .cornerRadius(15)
                            }
                        }.disabled(kilometer == -1)
                    }
                    .padding(20)
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .accentColor(Color("black"))
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct AddTagebuchCard1_Previews: PreviewProvider {
    static var previews: some View {
        AddTagebuchCard1(tabViewSelected: .constant(2))
    }
}
