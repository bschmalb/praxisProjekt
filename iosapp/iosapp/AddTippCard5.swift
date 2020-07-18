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
    let postedBy: String
    let official: String?
}

struct AddTippCard5: View {
    
    @State var isSuccess = false
    @State var isLoading = false
    @State var isError = false
    @State var show = false
    @State var posted = false
    @Binding var showAddTipps: Bool
    @State var userLevelLocal = 0
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var levelEnv: UserLevel
    @EnvironmentObject var overlay: Overlay
    
    @ObservedObject private var keyboard2 = KeyboardResponder()
    
    let category: String
    var level: String
    var tippTitel: String
    var quelle: String
    
    
    var body: some View {
        ZStack {
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
                            Text("5/5").bold().padding(20).foregroundColor(Color.secondary)
                        }
                        Spacer()
                    }
                    VStack {
                        Spacer()
                        
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
                                Button(action: {
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
                                self.posted = true
                                self.overlay.overlayLog = true
                                self.isLoading = true
                                self.show = true
                                self.postTipp()
                            })
                            {
                                HStack {
                                    Text("Posten")
                                        .font(.headline)
                                        .accentColor(Color("white"))
                                    Image(systemName: "arrow.up.doc")
                                        .font(.system(size: 16, weight: Font.Weight.medium))
                                        .accentColor(Color("white"))
                                }.frame(width: 120, height: 45)
                                    .background(Color("blue"))
                                    .cornerRadius(15)
                            }.disabled(posted)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }.accentColor(Color("black"))
                }.modifier(DismissingKeyboard())
            }
            .animation(.spring())
            .onAppear {
                impact(style: .medium)
            }
            .gesture(DragGesture()
            .onChanged({ (value) in
                if (value.translation.width > 0) {
                    if (value.translation.width > 30) {
                        self.mode.wrappedValue.dismiss()
                    }
                }
            }))
                .blur(radius: overlay.overlayLog ? 2 : 0)
                .edgesIgnoringSafeArea(.all)
                .animation(.spring())
            if isLoading {
                ZStack {
                    VStack {
                        LottieView(filename: "loading2", loop: true)
                            .frame(width: 200, height: 200)
                            .offset(y: -15)
                    }
                    Text("Loading")
                        .font(.headline)
                        .offset(y: 20)
                }.frame(width: 200, height: 130)
                    .background(Color("white"))
                    .cornerRadius(20)
                    .shadow(radius: 20)
                    .offset(x: show ? 0 : -UIScreen.main.bounds.width, y: -50)
                    .opacity(show ? 1 : 0)
                    .scaleEffect(show ? 1 : 0)
                .animation(.spring())
            }
            
            if isError {
                ZStack {
                    VStack {
                        LottieView(filename: "loading2", loop: true)
                            .frame(width: 200, height: 200)
                            .offset(y: -15)
                    }
                    Text("Loading")
                        .font(.headline)
                        .offset(y: 20)
                }.frame(width: 200, height: 130)
                    .background(Color("white"))
                    .cornerRadius(20)
                    .shadow(radius: 20)
                    .offset(x: show ? 0 : -UIScreen.main.bounds.width, y: -50)
                    .opacity(show ? 1 : 0)
                    .scaleEffect(show ? 1 : 0)
                .animation(.spring())
            }
            
            if isSuccess {
                SuccessView()
                    .onTapGesture {
                        self.showAddTipps = false
                        self.isSuccess = false
                        self.overlay.overlayLog = false
                }
            }
        }
    }
    
    func postTipp(){
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            let tippData = PostTipp(id: UUID(), title: self.tippTitel, source: self.quelle, category: self.category, level: self.level, score: 0, postedBy: uuid, official: "Community")
            
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 6, execute: {
                        self.isLoading = false
                        self.overlay.overlayLog = false
//                        self.isError = true
                    })
                    return
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    print(data)
                    haptic(type: .success)
                    self.levelEnv.level += 35
                    UserDefaults.standard.set(self.levelEnv.level, forKey: "userLevel")
                    self.isLoading = false
                    self.isSuccess = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 7, execute: {
                    self.showAddTipps = false;
                    self.isSuccess = false
                    self.overlay.overlayLog = false
                })
            }.resume()
        }
    }
}

struct AddTippCard5_Previews: PreviewProvider {
    static var previews: some View {
        AddTippCard5(showAddTipps: .constant(true), category: "Nahrung", level: "Leicht", tippTitel: "Nutze waschbare Gemüsenetze anstatt Plastiktüten", quelle: "Quelle").environmentObject(UserLevel()).environmentObject(Overlay())
    }
}
