//
//  AddTippCard3.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 07.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct AddTippCard3: View {
    @ObservedObject private var keyboard = KeyboardResponder()
    
    
    var level: String
    var category: String
    
    @State var tippTitle: String = ""
    @State var isFocused = false
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Text("3/5").bold().padding(20).foregroundColor(Color.secondary)
                }
                Spacer()
            }
            VStack {
                VStack {
                    Image(uiImage: #imageLiteral(resourceName: "Working"))
                        .resizable()
                        .scaledToFit()
                        .animation(.easeInOut)
                    Text("Wähle einen Titel für deinen Tipp")
                        .font(.title)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .padding()
                        .animation(.easeInOut)
                    VStack {
                        HStack (alignment: .center){
                            Section {
                                TextField("Dein Tipp", text: $tippTitle)
                                    .font(.system(size: 18))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .onTapGesture {
                                        self.isFocused = true
                                }
                            }
                        }
                    }.padding(.horizontal)
                        .edgesIgnoringSafeArea(.bottom)
                        .animation(.easeInOut)
                }.offset(y: isFocused ? -140 : 0)
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
                    NavigationLink (destination: AddTippCard4(category: category, level: level, tippTitel: tippTitle)
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)){
                            Image(systemName: "arrow.right")
                                .font(.headline)
                                .accentColor(Color(!tippTitle.isEmpty ? "white" :"white"))
                                .padding(5)
                                .frame(width: 80, height: 40)
                                .background(Color(!tippTitle.isEmpty ? "blue" : "blueDisabled"))
                                .cornerRadius(15)
                    }.disabled(tippTitle.isEmpty)
                }.offset(y: isFocused ? -300 : 0)
                    .animation(.easeInOut)
                    .padding(20)
            }.accentColor(Color("black"))
        }.onTapGesture {
            self.isFocused = false
            self.hideKeyboard()
        }
    }
}

struct DismissingKeyboard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                let keyWindow = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .map({$0 as? UIWindowScene})
                    .compactMap({$0})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first
                keyWindow?.endEditing(true)
        }
    }
}

struct AddTippCard3_Previews: PreviewProvider {
    static var previews: some View {
        AddTippCard3(level: "Level", category: "Nahrung")
    }
}
