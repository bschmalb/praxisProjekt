//
//  AddTippCard5.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 07.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct PostTipp: Codable {
    let id: UUID
    let title: String
    let source: String
    let category: String
    let level: String
    let score: Int16
}

struct AddTippCard5: View {
    
    @State var isSuccess = false
    @Binding var showAddTipps: Bool
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Environment(\.presentationMode) private var presentationMode
    
    @ObservedObject private var keyboard2 = KeyboardResponder()
    
    let category: String
    var level: String
    var tippTitel: String
    var quelle: String
    
    
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
                        Text("5/5").bold().padding(20).foregroundColor(Color.secondary)
                    }
                    Spacer()
                }
                VStack {
                    Spacer()
                    Text("Hier ist eine Vorschau deines Tipp:")
                        .font(.system(size: 20))
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
                                .foregroundColor(Color("alwaysblack"))
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
                                    .foregroundColor(Color("alwaysblack"))
                                    .multilineTextAlignment(.center)
                                    .padding(5)
                            }
                            Spacer()
                            HStack {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 25))
                                    .foregroundColor(.black)
                                    .opacity(0.1)
                                    .padding(.bottom, 30)
                                    .padding(.leading, 60)
                                Spacer()
                                Image(systemName: "bookmark")
                                    .font(.system(size: 25))
                                    .foregroundColor(.black)
                                    .opacity(0.1)
                                    .padding(.bottom, 30)
                                    .padding(.trailing, 60)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width - 40, height:
                            375)
                            .background(Color("cardgreen2"))
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
                            self.postTipp()
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
                if isSuccess {
                    SuccessView()
                        .onTapGesture {
                            self.showAddTipps = false
                            self.isSuccess = false
                    }
                }
            }.modifier(DismissingKeyboard())
        }.animation(.spring())
    }
    
    func postTipp(){
        let tippData = PostTipp(id: UUID(), title: self.tippTitel, source: self.quelle, category: self.category, level: self.level, score: 0)
        
        guard let encoded = try? JSONEncoder().encode(tippData) else {
            print("Failed to encode order")
            return
        }
        guard let url = URL(string: "http://bastianschmalbach.ddns.net/tipps") else { return }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            print(data)
            
            self.isSuccess = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 7, execute: {
                self.showAddTipps = false;
                self.isSuccess = false
            })
        }.resume()
    }
}

struct AddTippCard5_Previews: PreviewProvider {
    static var previews: some View {
        AddTippCard5(showAddTipps: .constant(true), category: "Nahrung", level: "Leicht", tippTitel: "Nutze waschbare Gemüsenetze anstatt Plastiktüten", quelle: "Quelle")
    }
}
