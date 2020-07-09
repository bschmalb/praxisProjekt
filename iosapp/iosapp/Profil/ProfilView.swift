//
//  ProfilView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 03.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct ProfilView: View {
    
    @State var offsetChangeName = -UIScreen.main.bounds.height
    @State var offsetLevel = -UIScreen.main.bounds.height
    @ObservedObject var userStore = UserDataStore()
    
    @Binding var isDark: Bool
    @Binding var appearenceDark: Bool
    
    @EnvironmentObject var overlay: Overlay
    
    
    @State private var userName: String = UserDefaults.standard.string(forKey: "userName") ?? "Nutzer"
    
    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    ZStack {
                        Color("background")
                            .edgesIgnoringSafeArea(.all)
                    }
                    
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                self.offsetLevel = -UIScreen.main.bounds.height / 20
                                self.overlay.overlayLog = true
                            })
                            {
                            LevelView(frameWidth: 60, frameHeight: 60)
                                .padding(30)
                                .offset(y: -5)
                            }
                        }
                        Spacer()
                    }.zIndex(1)
                    
                    VStack {
                        HStack {
                            Button(action: {
                                self.offsetChangeName = -UIScreen.main.bounds.height / 20
                                self.overlay.overlayLog = true
                            })
                            {
                                VStack (alignment: .leading){
                                    Text("Hallo \(userName)")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .padding(.leading, 20)
                                        .padding(.vertical, 5)
                                        .frame(width: UIScreen.main.bounds.width / 1.4, height: 40, alignment: .leading)
                                    Text("Wilkommen in deinem Profil")
                                        .font(.callout)
                                        .padding(.leading, 20)
                                }
                                Spacer()
                            }.accentColor(Color("black"))
                        }
                        .padding(.top, 10.0)
                        .offset(y: 10)
                        
                        ProfilHomeView(isDark: $isDark, appearenceDark: $appearenceDark, offsetChangeName: $offsetChangeName, offsetLevel: $offsetLevel)
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                            .navigationBarBackButtonHidden(true)
                    }
                    .animation(.spring())
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                }
            }
            .padding(.top, 1)
            .padding(.bottom, UIScreen.main.bounds.height / 12)
//            .overlay(Color("black").opacity(overlay.overlay ? 0.4 : 0))
            .blur(radius: overlay.overlayLog ? 2 : 0)
            .edgesIgnoringSafeArea(.all)
            .animation(.spring())
            
            
            ChangeNameView(offsetChangeName: $offsetChangeName, userName: $userName)
            
            ProfileLevelView(offsetLevel: $offsetLevel)
                .onTapGesture {
                    self.offsetLevel = -UIScreen.main.bounds.height / 1.5
                }
            
            
            
        }.gesture(DragGesture()
                    .onChanged({ value in
                        if (value.translation.height < 0) {
                            if (value.translation.height < 20) {
                                UserDefaults.standard.set(self.userName, forKey: "userName")
                                self.offsetChangeName = -UIScreen.main.bounds.height / 1.5
                                self.offsetLevel = -UIScreen.main.bounds.height / 1
                                self.overlay.overlayLog = false
                                self.hideKeyboard()
                            }
                        }
                    })
        )
        .padding(.top, 1)
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ProfilView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilView(isDark: .constant(false), appearenceDark: .constant(false)).environmentObject(UserLevel()).environmentObject(Overlay())
    }
}

struct ChangeNameView: View {
    
    @Binding var offsetChangeName : CGFloat
    @Binding var userName: String
    
    @EnvironmentObject var overlay: Overlay
    
    var body: some View {
        VStack {
            HStack {
                TextField("Gib deinen Namen ein", text: $userName)
                    .padding(.leading, 50)
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: 50)
                Button(action: {
                    UserDefaults.standard.set(self.userName, forKey: "userName")
                    self.offsetChangeName = -UIScreen.main.bounds.height / 1.5
                    self.hideKeyboard()
                    self.overlay.overlayLog = false
                })
                {
                    Image(systemName: "xmark.circle")
                        .offset(y: -20)
                        .font(.system(size: 20))
                        .foregroundColor(.secondary)
                        .padding(15)
                        .padding(.trailing, 30)
                }
            }
            .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            .frame(width: UIScreen.main.bounds.width * 0.9)
            Button(action: {
                UserDefaults.standard.set(self.userName, forKey: "userName")
                self.offsetChangeName = -UIScreen.main.bounds.height / 1.5
                self.overlay.overlayLog = true
                self.hideKeyboard()
                self.overlay.overlayLog = false
            })
            {
                Text("Ändern")
                    .font(.body)
                    .foregroundColor(Color("white")).bold()
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(Color("blue"))
                    .cornerRadius(15)
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 5)
        .background(Color("buttonWhite"))
        .cornerRadius(15)
        .shadow(radius: 10)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: Color.black.opacity(0.2), radius: 30, x: 0, y: 30)
        .offset(y: offsetChangeName)
        .animation(.spring())
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ProfileLevelView: View {
    
    @Binding var offsetLevel: CGFloat
    
    @EnvironmentObject var levelEnv: UserLevel
    @EnvironmentObject var overlay: Overlay
    @State var userLevelLocal = UserDefaults.standard.integer(forKey: "userLevel")
    
    var color1 = Color("blue")
    var color2 = Color(.blue).opacity(0.7)
    var frameWidth: CGFloat = 100
    var frameHeight: CGFloat = 100
    var percent: CGFloat = 10
    
    var body: some View {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumIntegerDigits = 2
        
        let progress = 1 - CGFloat(Int(numberFormatter.string(for: levelEnv.level) ?? "2") ?? 10) / 100
        
        return VStack (spacing: 30) {
            HStack {
                Text("Level \((levelEnv.level/100)+1)")
                    .font(.system(size: 28))
                    .bold()
                    .foregroundColor(Color("black"))
                Spacer()
                ZStack {
                    Circle()
                        .stroke(Color(.black).opacity(0.1), style: StrokeStyle(lineWidth: 8))
                        .frame(width: frameWidth, height: frameHeight)
                    Circle()
                        .trim(from: progress, to: 1)
                        .stroke(
                            LinearGradient(gradient: Gradient(colors: [color1, color2]), startPoint: .topTrailing, endPoint: .bottomLeading),
                            style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [20, 0], dashPhase: 0
                            )
                        )
                        .rotationEffect(Angle(degrees: 90))
                        .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
                        .frame(width: frameWidth, height: frameHeight)
                        .shadow(color: Color("blue").opacity(0.1), radius: 3, x: 0, y: 3)
                    VStack (spacing: -5){
                        Text("\(numberFormatter.string(for: levelEnv.level) ?? "0")/100")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 16))
                            .frame(width: 60)
                            .foregroundColor(Color("black").opacity(0.8))
                    }.offset(y: 2)
                }
            }
            .padding(.horizontal, 40)
            Text("Level weiter hoch indem du Tipps abhakst und an Challenges teilnimmst.\n\nDeinen Fortschritt kannst du jederzeit in deinem Profil ansehen.")
                .padding(.horizontal, 40)
        }
        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 2.3)
        .background(Color("buttonWhite"))
        .cornerRadius(25)
        .shadow(radius: 10)
        .offset(y: offsetLevel)
        .onTapGesture {
            self.offsetLevel = -UIScreen.main.bounds.height / 1.2
            self.overlay.overlayLog = false
        }
    }
}
