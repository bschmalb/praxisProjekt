//
//  AddTippCard4.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 07.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct AddTippCard4: View {
    
    var category: String
    var level: String
    var tippTitel: String
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @State var quelle: String = ""
    @State var isFocused2 = false
    @Binding var showAddTipps: Bool
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                Text("Tipp posten:")
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
                        Text("4/5").bold().padding(20).foregroundColor(Color.secondary)
                    }
                    Spacer()
                }
                VStack {
                    VStack {
                        Image("Research")
                            .resizable()
                            .scaledToFit()
                            .animation(.easeInOut)
                        Text("Gebe wenn möglich eine Quelle für deinen Tipp an")
                            .font(.title)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                            .padding()
                            .animation(.easeInOut)
                        VStack {
                            HStack (alignment: .center){
                                Section {
                                    TextField("Quelle", text: $quelle)
                                        .keyboardType(.URL)
                                        .textContentType(.URL)
                                        .font(.system(size: 18))
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .onTapGesture {
                                            self.isFocused2 = true
                                    }
                                }
                            }
                        }.padding(.horizontal)
                            .edgesIgnoringSafeArea(.bottom)
                    }.offset(y: isFocused2 ? -140 : 0)
                        .animation(.easeInOut)
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
                        NavigationLink (destination: AddTippCard5(showAddTipps: $showAddTipps, category: category, level: level, tippTitel: tippTitel, quelle: quelle)
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                            .navigationBarBackButtonHidden(true)
                            ){
                            Image(systemName: "arrow.right")
                                .font(.headline)
                                .accentColor(Color("white"))
                                .padding(5)
                                .frame(width: 80, height: 40)
                                .background(Color("blue"))
                                .cornerRadius(15)
                        }
                    }.offset(y: isFocused2 ? -UIScreen.main.bounds.height / 2.7 : 0)
                        .animation(.easeInOut)
                        .padding(20)
                }
            }.accentColor(Color("black"))
        }.onTapGesture {
            self.isFocused2 = false
            self.hideKeyboard()
        }
        .gesture(DragGesture()
        .onChanged({ (value) in
            if (value.translation.width > 0) {
                if (value.translation.width > 30) {
                    self.mode.wrappedValue.dismiss()
                }
            }
        }))
        .animation(.spring())
        .onAppear {
            impact(style: .medium)
        }
    }
}

struct AddTippCard4_Previews: PreviewProvider {
    static var previews: some View {
        AddTippCard4(category: "Nahrung", level: "Level", tippTitel: "Titel", showAddTipps: .constant(true))
    }
}
