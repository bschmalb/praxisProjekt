//
//  ProfilView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 03.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct ProfilView: View {
    
    @State var id = UserDefaults.standard.string(forKey: "id")
    
    @State var offsetChangeName = -UIScreen.main.bounds.height
    @State var offsetLevel = -UIScreen.main.bounds.height
    @ObservedObject var userStore = UserDataStore()
    
    @Binding var tabViewSelected: Int
    @Binding var isDark: Bool
    @Binding var appearenceDark: Bool
    @Binding var selection: Int?
    @State var selectionProfil: Int?
    
    @EnvironmentObject var overlay: Overlay
    @EnvironmentObject var user: UserObserv
    @EnvironmentObject var myUrl: ApiUrl

    @ObservedObject var filter: FilterData2
    
    @State private var userName: String = UserDefaults.standard.string(forKey: "userName") ?? "Nutzer"
    
    @State var isChanged: Bool = false
    
    @State var showLevel: Bool = false
    
    var screen = UIScreen.main.bounds.width
    
    var body: some View {
        
        ZStack {
            ZStack {
                ZStack {
                    Color("background")
                        .edgesIgnoringSafeArea(.all)
                }
                
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            self.showLevel = true
                        })
                        {
                            LevelView(frameWidth: 60, frameHeight: 60)
                                .padding(10)
                                .offset(y: -5)
                        }
                    }
                    .padding(20)
                    Spacer()
                }.zIndex(1)
                
                VStack (alignment: .leading){
                    HStack {
                        VStack (alignment: .leading){
                            Text("Hallo \(user.name)")
//                                .font(.system(size: 24, weight: Font.Weight.semibold))
                                .font(.title)
                                .fontWeight(.bold)
                                .lineLimit(1)
                                .onTapGesture {
                                    impact(style: .medium)
                                    self.selection = 4
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                        self.selectionProfil = 1
                                    }
                                }
                            Text("Wilkommen in deinem Profil")
                                .font(.system(size: screen < 500 ? screen * 0.04 : 18))
                                .padding(.top, 1)
                        }
                        .padding(.leading, 20)
                        .padding(.top, 5)
                        Spacer()
                    }.frame(maxWidth: UIScreen.main.bounds.width / 1.4)
                    .padding(.top, 10.0)
                    .offset(y: 10)
                    
                    ProfilHomeView(tabViewSelected: $tabViewSelected, isDark: $isDark, appearenceDark: $appearenceDark, offsetChangeName: $offsetChangeName, offsetLevel: $offsetLevel, selection: $selection, selectionProfil: $selectionProfil, filter: filter, isChanged: $isChanged)
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                }
                .animation(.spring())
                .navigationBarTitle("")
                .navigationBarHidden(true)
            }
            .padding(.top, 1)
            .padding(.bottom, UIScreen.main.bounds.height / 12)
            .blur(radius: showLevel ? 4 : 0)
            .edgesIgnoringSafeArea(.all)
            .animation(.spring())
            
            //            ChangeNameView(offsetChangeName: $offsetChangeName, userName: $userName)
            
            ProfileLevelView()
                .offset(y: showLevel ? 0 : -UIScreen.main.bounds.height)
                .onTapGesture {
                    self.showLevel = false
                    self.overlay.overlayLog = false
                    impact(style: .medium)
                }
            
            
            
        }.gesture(DragGesture()
                    .onChanged({ value in
                        if (value.translation.height < 0) {
                            if (value.translation.height < 20) {
                                UserDefaults.standard.set(self.userName, forKey: "userName")
                                //                                self.postUserName()
                                //                                self.offsetChangeName = -UIScreen.main.bounds.height / 1.5
                                self.offsetLevel = -UIScreen.main.bounds.height / 1
                                self.overlay.overlayLog = false
                                self.hideKeyboard()
                            }
                        }
                    })
        )
        .padding(.top, 1)
    }
    
    func postUserName(){
        let patchData = UserNamePatch(name: user.name)
        
        guard let encoded = try? JSONEncoder().encode(patchData) else {
            print("Failed to encode order")
            return
        }
        
        guard let url = URL(string: myUrl.users + (id ?? "")) else { return }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PATCH"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
        }.resume()
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct UserNamePatch: Encodable, Decodable {
    var name: String
}

struct ProfilView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilView(tabViewSelected: .constant(3), isDark: .constant(false), appearenceDark: .constant(false), selection: .constant(0), selectionProfil: 1, filter: FilterData2()).environmentObject(UserLevel()).environmentObject(Overlay()).environmentObject(UserObserv())
    }
}

struct ChangeNameView: View {
    
    @State var id = UserDefaults.standard.string(forKey: "id")
    
    @Binding var offsetChangeName : CGFloat
    @Binding var userName: String
    
    @EnvironmentObject var user: UserObserv
    @EnvironmentObject var overlay: Overlay
    @EnvironmentObject var myUrl: ApiUrl
    
    var body: some View {
        VStack {
            HStack {
                TextField("Gib deinen Namen ein", text: $user.name)
                    .padding(.leading, 50)
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: 50)
                Button(action: {
                    UserDefaults.standard.set(self.user.name, forKey: "userName")
                    self.patchName(name: self.user.name)
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
                UserDefaults.standard.set(self.user.name, forKey: "userName")
                self.patchName(name: self.user.name)
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
    
    func patchName(name: String) {
        let patchUserName = Name(name: name)
        
        guard let encoded = try? JSONEncoder().encode(patchUserName) else {
            print("Failed to encode order")
            return
        }
        
        guard let url = URL(string: myUrl.users + (id ?? "")) else { return }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PATCH"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
        }.resume()
    }
}

struct Name: Encodable, Decodable {
    var name: String
}

struct ProfileLevelView: View {
    
    //    @Binding var offsetLevel: CGFloat
    
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
        
        return VStack {
            VStack (spacing: 30) {
                HStack {
                    Text("Level \((levelEnv.level/100)+1)")
                        .font(.system(size: 28))
                        .bold()
                        .foregroundColor(Color("black"))
                    Spacer()
                    ZStack {
                        Circle()
                            .stroke(Color(.gray).opacity(0.3), style: StrokeStyle(lineWidth: 8))
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
                Text("Durch das Hinzufügen, Speichern, selbst Erstellen und Eewerten von Tipps, sowie das Erstellen von Tagebucheinträgen sammelst du Punkte\n\nDeinen Fortschritt kannst du jederzeit in deinem Profil ansehen.")
                    .font(.system(size: 15))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 20)
                Text("Alles klar")
                    .font(.system(size: UIScreen.main.bounds.width * 0.040, weight: .medium))
                    .padding(15)
                    .opacity(0.9)
            }
            .padding(.vertical, 30)
            .background(Color("buttonWhite"))
            .cornerRadius(25)
            .shadow(radius: 10)
            .padding(.horizontal, 20)
        }
    }
}
//
//struct ProfileLevelView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileLevelView(offsetLevel: .constant(10)).environmentObject(UserLevel()).environmentObject(Overlay()).environmentObject(UserObserv())
//    }
//}
