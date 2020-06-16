//
//  AddTippView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 05.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct AddTipp: Codable, Hashable, Identifiable {
    let id: UUID
    let category: String
    let difficulty: String
    var name: String
    var quelle: String
}

struct AddTippView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @Binding var showAddTipps: Bool
    
    @State var nahrungSelected: Bool = false
    @State var transportSelected: Bool = false
    @State var recyclingSelected: Bool = false
    @State var ressourcenSelected: Bool = false
    @State var categorySelected: Bool = false
    
    @State var category: String = ""
    
    var body: some View {
        NavigationView {
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
                            Text("1/5").bold().padding(20).foregroundColor(Color.secondary)
                        }
                        Spacer()
                    }
                    VStack {
                        Image(uiImage: #imageLiteral(resourceName: "kategorie"))
                            .resizable()
                            .scaledToFit()
                        Text("Wähle eine Kategorie für deinen Tipp")
                            .font(.title)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        HStack (spacing: 20) {
                            
                            Button(action: {
                                haptic(type: .success)
                                self.transportSelected = false
                                self.recyclingSelected = false
                                self.ressourcenSelected = false
                                self.categorySelected = true
                                
                                self.nahrungSelected = true
                                
                                self.category = "Nahrung"
                                
                            }) {
                                VStack {
                                    Image("blackPie")
                                        .resizable()
                                        .scaledToFit()
                                        .accentColor(Color(self.nahrungSelected ? "white" : "black"))
                                    Text("Nahrung")
                                        .font(.subheadline).fontWeight(.medium)
                                        .foregroundColor(Color(self.nahrungSelected ? "white" : "black"))
                                        .multilineTextAlignment(.center)
                                        .padding(5)
                                }.frame(height: 80)
                                    .padding(2)
                                    .padding(.horizontal, 10)
                                    .background(Color(nahrungSelected ? "blue" : "transparent"))
                                    .cornerRadius(15)
                                
                            }
                            Button(action: {
                                haptic(type: .success)
                                self.nahrungSelected = false
                                self.recyclingSelected = false
                                self.ressourcenSelected = false
                                self.categorySelected = true
                                
                                self.transportSelected = true
                                
                                self.category = "Transport"
                            }) {
                                VStack {
                                    Image(uiImage: #imageLiteral(resourceName: "blackTransport"))
                                        .resizable()
                                        .scaledToFit()
                                        .accentColor(Color(self.transportSelected ? "white" : "black"))
                                    Text("Transport")
                                        .font(.subheadline).fontWeight(.medium)
                                        .foregroundColor(Color(self.transportSelected ? "white" : "black"))
                                        .multilineTextAlignment(.center)
                                        .padding(.vertical, 5)
                                }.frame(height: 80)
                                    .padding(2)
                                    .padding(.horizontal, 10)
                                    .background(Color(transportSelected ? "blue" : "transparent"))
                                    .cornerRadius(15)
                                
                            }
                            Button(action: {
                                haptic(type: .success)
                                self.nahrungSelected = false
                                self.transportSelected = false
                                self.ressourcenSelected = false
                                self.categorySelected = true
                                
                                self.recyclingSelected = true
                                
                                self.category = "Recycling"
                            }) {
                                VStack {
                                    Image(uiImage: #imageLiteral(resourceName: "blackRecycle"))
                                        .resizable()
                                        .scaledToFit()
                                        .accentColor(Color(self.recyclingSelected ? "white" : "black"))
                                    Text("Recycling")
                                        .font(.subheadline).fontWeight(.medium)
                                        .foregroundColor(Color(self.recyclingSelected ? "white" : "black"))
                                        .multilineTextAlignment(.center)
                                        .padding(5)
                                }.frame(height: 80)
                                    .padding(2)
                                    .padding(.horizontal, 5)
                                    .background(Color(recyclingSelected ? "blue" : "transparent"))
                                    .cornerRadius(15)
                            }
                        }.padding(.bottom, 10)
                        HStack (spacing: 30) {
                            Button(action: {
                                haptic(type: .success)
                                self.nahrungSelected = false
                                self.transportSelected = false
                                self.recyclingSelected = false
                                self.categorySelected = true
                                
                                self.ressourcenSelected = true
                                
                                self.category = "Ressourcen"
                            }) {
                                VStack {
                                    Image(uiImage: #imageLiteral(resourceName: "blackRecycle"))
                                        .resizable()
                                        .scaledToFit()
                                        .accentColor(Color(self.ressourcenSelected ? "white" : "black"))
                                    Text("Ressourcen")
                                        .font(.subheadline).fontWeight(.medium)
                                        .foregroundColor(Color(self.ressourcenSelected ? "white" : "black"))
                                        .multilineTextAlignment(.center)
                                        .padding(5)
                                }.frame(height: 80)
                                    .padding(2)
                                    .padding(.horizontal, 10)
                                    .background(Color(ressourcenSelected ? "blue" : "transparent"))
                                    .cornerRadius(15)
                                
                            }
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            NavigationLink (destination: AddTippCard2(category: category, showAddTipps: $showAddTipps).navigationBarBackButtonHidden(true)
                                .navigationBarTitle("")
                                .navigationBarHidden(true)){
                                    Image(systemName: "arrow.right")
                                        .font(.headline)
                                        .accentColor(Color(categorySelected ? "white" :"white"))
                                        .padding(5)
                                        .frame(width: 80, height: 40)
                                        .background(Color(categorySelected ? "blue" : "blueDisabled"))
                                        .cornerRadius(15)
                            }.disabled(!categorySelected)
                        }
                        .padding(20)
                    }
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                    .accentColor(Color("black"))
                }
            }
            Spacer()
        }.accentColor(Color("black"))
        .animation(.spring())
    }
}

struct AddTippView_Previews: PreviewProvider {
    static var previews: some View {
        AddTippView(showAddTipps: .constant(true))
    }
}
