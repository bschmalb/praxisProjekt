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
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
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
                    Image(uiImage: #imageLiteral(resourceName: "Working"))
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
                    NavigationLink (destination: AddTippCard5(category: category, level: level, tippTitel: tippTitel, quelle: quelle)){
                        Image(systemName: "arrow.right")
                            .font(.headline)
                            .accentColor(Color(!quelle.isEmpty ? "white" :"white"))
                            .padding(5)
                            .frame(width: 80, height: 40)
                            .background(Color(!quelle.isEmpty ? "blue" : "blueDisabled"))
                            .cornerRadius(15)
                    }.disabled(quelle.isEmpty)
                }.offset(y: isFocused2 ? -300 : 0)
                .animation(.easeInOut)
                .padding(20)
            }.accentColor(Color("black"))
        }.onTapGesture {
            self.isFocused2 = false
            self.hideKeyboard()
        }
    }
}

struct AddTippCard4_Previews: PreviewProvider {
    static var previews: some View {
        AddTippCard4(category: "Nahrung", level: "Level", tippTitel: "Titel")
    }
}
