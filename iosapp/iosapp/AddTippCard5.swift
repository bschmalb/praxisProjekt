//
//  AddTippCard5.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 07.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct AddTippCard5: View {
    @ObservedObject private var keyboard2 = KeyboardResponder()
    
    var cardColors3: [String]  = [
        "cardgreen", "cardblue", "cardyellow", "cardpurple", "cardorange"
    ]
    
    let category: String
    var level: String
    var tippTitel: String
    var quelle: String
    
    struct data {
        let title: String
        let source: String
        let category: String
        let level: String
        let score: Int16
    }
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Text("5/5").bold().padding(20).foregroundColor(Color.secondary)
                }
                Spacer()
            }
            VStack {
                Spacer()
//                Text("Wenn du einen Tipp postest, wird dieser von anderen Nutzern bewertet und dann allen angezeigt.")
//                    .padding(20)
                Text("Hier ist dein Tipp:")
                    .font(.title)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .animation(.spring())
                
                ZStack {
                    VStack{
                        Spacer()
                        Image("I"+category)
                            .resizable()
                            .scaledToFit()
                            .frame(minHeight: 150, maxHeight: 200)
                        Text(tippTitel)
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .onTapGesture {
                                self.mode.wrappedValue.dismiss()
                                self.mode.wrappedValue.dismiss()
                        }
                        Button(action: {
                            self.mode.wrappedValue.dismiss()
                        }) {
                            Text(quelle)
                                .font(.footnote)
                                .multilineTextAlignment(.center)
                                .padding(5)
                        }
                        Spacer()
                        HStack {
                            Image(systemName: "checkmark")
                                .font(.system(size: 25))
                                .foregroundColor(.secondary)
                                .padding(.bottom, 30)
                                .padding(.leading, 60)
                            Spacer()
                            Image(systemName: "bookmark")
                                .font(.system(size: 25))
                                .foregroundColor(.secondary)
                                .padding(.bottom, 30)
                                .padding(.trailing, 60)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width - 40, height:
                        375)
                        .background(Color("cardgreen"))
                        .cornerRadius(15)
                        .shadow(radius: 5)
                    VStack {
                        HStack(alignment: .top) {
                            Image(category)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .opacity(0.1)
                                .padding(.leading, 30)
                                .padding(.vertical)
                            Image(level)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .opacity(0.1)
                                .padding(.vertical)
                            Spacer()
                        }
                        Spacer()
                    }.frame(width: UIScreen.main.bounds.width - 40, height:
                        375)
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
                    Button (action: { 
                        let tippData: data =
                            .init(title: self.tippTitel, source: self.quelle, category: self.category, level: self.level, score: 0)
                        print(tippData)
//                        postTipp(data: data)
                        
                    })
                    {
                        Text("Posten!")
                            .font(.headline)
                            .accentColor(Color("white"))
                            .padding(5)
                            .frame(width: 100, height: 40)
                            .background(Color("blue"))
                            .cornerRadius(15)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }.accentColor(Color("black"))
        }.modifier(DismissingKeyboard())
    }
    
    func postTipp(data: String){
        
    }
}

struct AddTippCard5_Previews: PreviewProvider {
    static var previews: some View {
        AddTippCard5(category: "Nahrung", level: "Leicht", tippTitel: "Nutze waschbare Gemüsenetze anstatt Plastiktüten", quelle: "Quelle")
    }
}
