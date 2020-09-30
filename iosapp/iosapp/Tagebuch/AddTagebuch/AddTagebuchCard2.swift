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
    
    var screenWidth = UIScreen.main.bounds.width
    
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
                        .font(.system(size: screenWidth < 500 ? screenWidth * 0.06 : 26, weight: .medium))
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    HStack (spacing: 40) {
                        Button(action: {
                            impact(style: .medium)
                            self.meat = 0
                        }) {
                            TagebuchButton(name: "0", einheit: "Mal", selected: meat, selectedAmount: 0)
                        }
                        Button(action: {
                            impact(style: .medium)
                            self.meat = 1
                        }) {
                            TagebuchButton(name: "1", einheit: "Mal", selected: meat, selectedAmount: 1)
                        }
                        Button(action: {
                            impact(style: .medium)
                            self.meat = 2
                        }) {
                            TagebuchButton(name: "2", einheit: "Mal", selected: meat, selectedAmount: 2)
                        }
                    }.padding(.bottom, 10)
                    HStack (spacing: 40) {
                        Button(action: {
                            impact(style: .medium)
                            self.meat = 3
                        }) {
                            TagebuchButton(name: "3", einheit: "Mal", selected: meat, selectedAmount: 3)
                        }
                        Button(action: {
                            impact(style: .medium)
                            self.meat = 4
                        }) {
                            TagebuchButton(name: "4+", einheit: "Mal", selected: meat, selectedAmount: 4)
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
                                    .font(.system(size: screenWidth < 500 ? screenWidth * 0.035 : 14, weight: .light))
                                    .foregroundColor(.secondary)
                        }
                        Spacer()
                        NavigationLink (destination: AddTagebuchCard3(tabViewSelected: $tabViewSelected, kilometer: kilometer, meat: meat).navigationBarBackButtonHidden(true)
                            .navigationBarTitle("")
                            .navigationBarHidden(true)){
                                Image(systemName: "arrow.right")
                                    .font(.headline)
                                    .accentColor(Color(meat == -1 ? "white" :"white"))
                                    .padding(5)
                                    .frame(width: 80, height: 40)
                                    .background(Color(meat == -1 ? "blue" : "blueDisabled"))
                                    .cornerRadius(15)
                        }.disabled(meat == -1)
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

struct AddTagebuchCard2_Previews: PreviewProvider {
    static var previews: some View {
        AddTagebuchCard2(tabViewSelected: .constant(2), kilometer: 0)
    }
}
