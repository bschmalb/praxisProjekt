//
//  AddTippCard2.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 07.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct AddTippCard2: View {
    
    var category: String
    
    @State var leichtSelected: Bool = false
    @State var mittelSelected: Bool = false
    @State var schwerSelected: Bool = false
    @State var levelSelected: Bool = false
    @State var level: String = ""
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Environment(\.presentationMode) private var presentationMode
    
    @Binding var showAddTipps: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("Tipp posten")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.leading, 20)
                
                Spacer()
                Button(action: {
                    self.showAddTipps = false
                }) {
                    Image(systemName: "xmark.circle")
                        .font(.title)
                        .padding(10)
                        .padding(.trailing, 15)
                }
            }
            .padding(.top, 30)
            ZStack {
                VStack {
                    HStack {
                        Spacer()
                        Text("2/5").bold().padding(20).foregroundColor(Color.secondary)
                    }
                    Spacer()
                }
                VStack {
                    Image(uiImage:  #imageLiteral(resourceName: "Success"))
                        .resizable()
                        .scaledToFit()
                    Text("Wähle eine Niveaustufe für deinen Tipp")
                        .font(.title)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    HStack (spacing: 20) {
                        
                        Button(action: {
                            haptic(type: .success)
                            
                            self.mittelSelected = false
                            self.schwerSelected = false
                            self.levelSelected = true
                            
                            self.leichtSelected = true
                            
                            self.level = "Leicht"
                        }) {
                            VStack {
                                Image("blackStar")
                                    .resizable()
                                    .scaledToFit()
                                    .accentColor(Color(self.leichtSelected ? "white" : "black"))
                                Text("Leicht")
                                    .font(.subheadline).fontWeight(.medium)
                                    .foregroundColor(Color(self.leichtSelected ? "white" : "black"))
                                    .multilineTextAlignment(.center)
                                    .padding(.vertical, 5)
                            }.frame(width: 90, height: 80)
                                .background(Color(leichtSelected ? "blue" : "transparent"))
                                .cornerRadius(15)
                            
                        }
                        Button(action: {
                            haptic(type: .success)
                            
                            self.leichtSelected = false
                            self.schwerSelected = false
                            self.levelSelected = true
                            
                            self.mittelSelected = true
                            
                            self.level = "Mittel"
                        }) {
                            VStack {
                                ZStack {
                                    Image("blackHalfStar")
                                        .resizable()
                                        .scaledToFit()
                                        .accentColor(Color(self.mittelSelected ? "white" : "black"))
                                    Image("blackStar")
                                        .resizable()
                                        .scaledToFit()
                                        .accentColor(Color(self.mittelSelected ? "white" : "black"))
                                }
                                Text("Mittel")
                                    .font(.subheadline).fontWeight(.medium)
                                    .foregroundColor(Color(self.mittelSelected ? "white" : "black"))
                                    .multilineTextAlignment(.center)
                                    .padding(.vertical, 5)
                            }.frame(width: 90, height: 80)
                                .background(Color(mittelSelected ? "blue" : "transparent"))
                                .cornerRadius(15)
                            
                        }
                        Button(action: {
                            haptic(type: .success)
                            
                            self.leichtSelected = false
                            self.mittelSelected = false
                            self.levelSelected = true
                            
                            self.schwerSelected = true
                            
                            self.level = "Schwer"
                        }) {
                            VStack {
                                Image("blackStarFilled")
                                    .resizable()
                                    .scaledToFit()
                                    .accentColor(Color(self.schwerSelected ? "white" : "black"))
                                Text("Schwer")
                                    .font(.subheadline).fontWeight(.medium)
                                    .foregroundColor(Color(self.schwerSelected ? "white" : "black"))
                                    .multilineTextAlignment(.center)
                                    .padding(5)
                            }.frame(width: 90, height: 80)
                                .background(Color(schwerSelected ? "blue" : "transparent"))
                                .cornerRadius(15)
                        }
                    }
                    Spacer()
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
                        NavigationLink (destination: AddTippCard3(level: level, category: category, showAddTipps: $showAddTipps)
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                            .navigationBarBackButtonHidden(true)){
                                Image(systemName: "arrow.right")
                                    .font(.headline)
                                    .accentColor(Color(levelSelected ? "white" :"white"))
                                    .padding(5)
                                    .frame(width: 80, height: 40)
                                    .background(Color(levelSelected ? "blue" : "blueDisabled"))
                                    .cornerRadius(15)
                        }.disabled(!levelSelected)
                    }.padding(20)
                }.accentColor(Color("black"))
            }.onAppear(){
                //            if (self.nahrungSelected) {
                //                self.category = "Nahrung"
                //            }
                //            if (self.transportSelected) {
                //                self.category = "Transport"
                //            }
                //            if (self.recyclingSelected) {
                //                self.category = "Recycling"
                //            }
                //            if (self.ressourcenSelected) {
                //                self.category = "Ressourcen"
                //            }
                //            print(self.category)
                
            }
            Spacer()
        }.accentColor(Color("black"))
        .animation(.spring())
        
        
    }
}

struct AddTippCard2_Previews: PreviewProvider {
    static var previews: some View {
        AddTippCard2(category: "", showAddTipps: .constant(true))
    }
}
