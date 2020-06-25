//
//  RateTippView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 09.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct RateTippView: View {
    
    @ObservedObject var store2 = RateTippDataStore()
    
    //    var bewertenTipps: [Tipp] = store.tipps
    
    @State private var showAddTipps2 = false
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var counter = 0
    @State var thumbUp = false
    @State var thumbDown = false
    @State var endReached = false
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("background").edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        Button (action: {
                            self.mode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "arrow.left.circle")
                                .accentColor(.primary)
                                .font(.title)
                                .padding(10)
                                .padding(.leading, 15)
                        }
                        Spacer()
                        Text("Tipps bewerten")
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                        Button(action: {
                            self.showAddTipps2.toggle()
                        }) {
                            Image(systemName: "plus.circle")
                                .accentColor(.primary)
                                .font(.title)
                                .padding(10)
                                .padding(.trailing, 15)
                        }.sheet(isPresented: $showAddTipps2, content: { AddTippView(showAddTipps: self.$showAddTipps2)})
                    }
                    .padding(.top, 20.0)
                    
                    HStack {
                        Text("Wenn ein Tipp von der Community gutes Feedback bekommt, wird dieser für alle Nutzer angezeigt")
                    }.padding()
                    
                    if (!endReached && !store2.rateTipps.isEmpty) {
                        if (store2.rateTipps[counter].score < 20) {
                            TippCard(isChecked: self.$store2.rateTipps[counter].isChecked, isBookmarked: self.$store2.rateTipps[counter].isBookmarked, tipp: store2.rateTipps[counter])
                                .animation(.spring())
                        }
                    }
                    else if (!store2.rateTipps.isEmpty) {
                        TippCard(isChecked: .constant(false), isBookmarked: .constant(false), tipp: Tipp(id: "123", title: "Vorerst keine weiteren Tipps mehr zum bewerten verfügbar", source: "", level: "", category: "Success Work", score: 0))
                            .animation(.spring())
                    }
                    else {
                        NoConnectionCard()
                    }
                        
                    if !endReached {
                        HStack {
                            Button(action: {
                                
                            }) {
                                Image(systemName: "hand.thumbsup")
                                    .font(.title)
                                    .accentColor(Color("black"))
                                    .padding(10)
                                    .frame(width: UIScreen.main.bounds.width / 2 - 25, height: 50)
                                    .background(Color("buttonWhite"))
                                    .cornerRadius(15)
                                    .shadow(color: Color(.green).opacity(thumbUp ? 0.5 : 0.1), radius: 5, x: 4, y: 3)
                                    .scaleEffect(thumbUp ? 1.1 : 1)
                                    .gesture(
                                        LongPressGesture().onChanged{ value in
                                            patchScore(id: self.store2.rateTipps[self.counter].id, thumb: "up")
                                            if (self.counter < self.store2.rateTipps.count - 1){
                                                withAnimation(){self.counter += 1}
                                            }
                                            else {
                                                withAnimation(){self.endReached = true}
                                            }
                                            self.thumbUp = true
                                            impact(style: .medium)
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                                self.thumbUp = false
                                            }
                                        }
                                )
                            }
                            Button(action: {
                                
                            }) {
                                Image(systemName: "hand.thumbsdown")
                                    .font(.title)
                                    .accentColor(Color("black"))
                                    .padding(10)
                                    .frame(width: UIScreen.main.bounds.width / 2 - 25, height: 50)
                                    .background(Color("buttonWhite"))
                                    .cornerRadius(15)
                                    .shadow(color: Color(.red).opacity(thumbDown ? 0.3 : 0.05), radius: 5, x: 4, y: 3)
                                    .scaleEffect(thumbDown ? 1.1 : 1)
                                    .gesture(
                                        LongPressGesture().onChanged(){ value in
                                            patchScore(id: self.store2.rateTipps[self.counter].id, thumb: "down")
                                            if (self.counter < self.store2.rateTipps.count - 1){
                                                withAnimation(){self.counter += 1}
                                            }
                                            else {
                                                withAnimation(){self.endReached = true}
                                            }
                                            self.thumbDown = true
                                            impact(style: .medium)
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                                self.thumbDown = false
                                            }
                                        }
                                )
                            }
                        }.padding(.top, 10)
                        .animation(.spring())
                    }
                    
                    Spacer()
                }
                    .navigationBarTitle("")
                .navigationBarHidden(true)
            }
        }
        .gesture(DragGesture()
        .onChanged({ (value) in
            if (value.translation.width > 0) {
                if (value.translation.width > 50) {
                    self.mode.wrappedValue.dismiss()
                }
            }
        }))
        .onAppear(){
                impact(style: .medium)
        }
    }
}

func patchScore(id: String, thumb: String) {
    guard let url = URL(string: "http://bastianschmalbach.ddns.net/tipps/" + id + "?thumb=" + thumb) else { return }
    var request = URLRequest(url: url)
    request.httpMethod = "PATCH"
    print(url)
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        
    }.resume()
}

struct RateTippView_Previews: PreviewProvider {
    static var previews: some View {
        RateTippView()
    }
}
