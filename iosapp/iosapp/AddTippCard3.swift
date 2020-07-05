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
                        Text("3/5").bold().padding(20).foregroundColor(Color.secondary)
                    }
                    Spacer()
                }
                VStack {
                    VStack {
                        Image(uiImage: #imageLiteral(resourceName: "Woman Carrying Browser Tab"))
                            .resizable()
                            .scaledToFit()
                            .animation(.easeInOut)
                        Text("Gebe deinen Tipp ein")
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
                    }.offset(y: isFocused ? -150 : 0)
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
                        NavigationLink (destination: AddTippCard4(category: category, level: level, tippTitel: tippTitle, showAddTipps: $showAddTipps)
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
                    }.offset(y: isFocused ? -UIScreen.main.bounds.height / 2.7 : 0)
                        .animation(.easeInOut)
                        .padding(20)
                }.accentColor(Color("black"))
            }.onTapGesture {
                self.isFocused = false
                self.hideKeyboard()
            }
        }.animation(.spring())
        .gesture(DragGesture()
        .onChanged({ (value) in
            if (value.translation.width > 0) {
                if (value.translation.width > 30) {
                    self.mode.wrappedValue.dismiss()
                }
            }
        }))
        .onAppear {
            impact(style: .medium)
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
        AddTippCard3(level: "Level", category: "Nahrung", showAddTipps: .constant(true))
    }
}
