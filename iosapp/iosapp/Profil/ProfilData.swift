//
//  ProfilData.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 23.09.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct ProfilData: View {
    
    @State var id = UserDefaults.standard.string(forKey: "id")
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @State var firstResponder: Bool? = false
    
    @State var optionSelected: Int = 1
    
    @State var user: User = User(_id: "", phoneId: "", level: 2, checkedTipps: [], savedTipps: [], savedFacts: [], log: [])
    
    @State var posting: Bool = false
    
    @EnvironmentObject var user2: UserObserv
    @EnvironmentObject var myUrl: ApiUrl
    
//    @State var name: String = UserDefaults.standard.string(forKey: "userName") ?? "User123"
    @State var age: String = ""
    @State var gender: String = ""
    @State var hideInfo: Bool = UserDefaults.standard.bool(forKey: "hideInfo")
    
    @State var ages: [String] = ["12-17", "18-25", "26-35", "36-50", "51-70", "71+"]
    @State var genders: [String] = ["Männlich", "Weiblich", "Divers"]
    @State var isSelected: [Bool] = [false, false, false, false, false, false]
    @State var isSelectedGender: [Bool] = [false, false, false]
    
    @Binding var isChanged: Bool
    
    var screen = UIScreen.main.bounds
    
    var body: some View {
        
        let binding = Binding<String>(get: {
            self.user2.name
        }, set: {
            self.user2.name = $0
            UserDefaults.standard.set(user2.name, forKey: "userName")
            if (user.name !=  $0){
                self.isChanged = true
            }
        })
        
        return ZStack {
            Color("background")
                .edgesIgnoringSafeArea(.all)
            VStack{
                Button(action: {
                    self.mode.wrappedValue.dismiss()
                    impact(style: .medium)
                }) {
                    HStack (spacing: 10){
                        Image(systemName: "arrow.left")
                            .font(.system(size: screen.width < 500 ? screen.width * 0.040 : 18, weight: .medium))
                            .foregroundColor(Color("black"))
                        Text("Deine Daten")
                            .font(.system(size: screen.width < 500 ? screen.width * 0.040 : 18, weight: .medium))
                            .foregroundColor(Color("black"))
                        Spacer()
                    }
                    .padding(.leading, 20)
                    .padding(.top, 15)
                }
                
                Spacer()
                
                VStack {
                    Text("Name:")
                        .font(.system(size: 16, weight: Font.Weight.medium))
                        .onTapGesture(perform: {
                            self.hideKeyboard()
                        })
                    ZStack{
                        MultilineTextView2(text: binding, isFirstResponder: $firstResponder, maxLength: 13)
                            .frame(height: 40)
                        VStack {
                            HStack {
                                Spacer()
                                Text("\(user2.name.count)/\(13)")
                                    .padding(10)
                                    .font(.system(size: screen.width < 500 ? screen.width * 0.03 : 12))
                                    .opacity(0.5)
                            }
                        }.frame(height: 40)
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width < 500 ? UIScreen.main.bounds.width - 30 : 450)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    if ((!(firstResponder ?? true)) && !(keyboard.currentHeight > 100)) {
                        Text("Alter")
                            .font(.system(size: 16, weight: Font.Weight.medium))
                            .onTapGesture(perform: {
                                self.hideKeyboard()
                            })
                            .onAppear(){
                                getUser()
                            }
                        ScrollView (.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(ages.indices, id: \.self) { index in
                                    Button(action: {
                                        self.age = ages[index]
                                        impact(style: .medium)
                                        for (i, _) in isSelected.enumerated() {
                                            isSelected[i] = false
                                        }
                                        self.isSelected[index] = true
                                        
                                        if (ages[index] != user.age){
                                            self.isChanged = true
                                        }
                                    }){
                                        Text(ages[index])
                                            .font(.system(size: 14))
                                            .padding(UIScreen.main.bounds.height < 600 ? 10 : 15)
                                            .foregroundColor(Color(isSelected[index] ? "white" : "black"))
                                            .background(Color(isSelected[index] ? "blue" : "background"))
                                            .cornerRadius(15)
                                    }
                                }
                            }.padding(.horizontal)
                        }
                        .opacity(hideInfo ? 0.5 : 1)
                        
                        Spacer()
                        Text("Geschlecht")
                            .font(.system(size: 16, weight: Font.Weight.medium))
                        HStack {
                            ForEach(genders.indices, id: \.self) { index in
                                Button(action: {
                                    self.gender = genders[index]
                                    impact(style: .medium)
                                    for (i, _) in isSelectedGender.enumerated() {
                                        isSelectedGender[i] = false
                                    }
                                    self.isSelectedGender[index] = true
                                    
                                    if (genders[index] != user.gender){
                                        self.isChanged = true
                                    }
                                }){
                                    Text(genders[index])
                                        .font(.system(size: 14))
                                        .padding(UIScreen.main.bounds.height < 600 ? 10 : 15)
                                        .foregroundColor(Color(isSelectedGender[index] ? "white" : "black"))
                                        .background(Color(isSelectedGender[index] ? "blue" : "background"))
                                        .cornerRadius(15)
                                }
                            }
                        }
                        .padding(.vertical, 10)
                        .opacity(hideInfo ? 0.5 : 1)
                        
                        Spacer()
                        
                        Toggle("Diese Angaben Online verstecken", isOn: $hideInfo)
                            .onReceive([self.hideInfo].publisher.first()) { (value) in
                                UserDefaults.standard.set(value, forKey: "hideInfo")
                                if (hideInfo != user.hideInfo){
                                    self.isChanged = true
                                }
                            }
                            .font(.footnote)
                            .padding()
                    } else {
                        Image(systemName: "ellipsis")
                            .frame(width: 40, height: 20)
                            .background(Color(.black).opacity(0.1))
                            .cornerRadius(10)
                            .padding()
                    }
                    
                    Spacer()
                    
                    if #available(iOS 14, *) {
                        Button(action: {
                            self.posting = true
                            self.isChanged = true
                            self.firstResponder = false
                            self.hideKeyboard()
                            self.firstResponder = false
                            self.postUserData()
                        }){
                            HStack (spacing: 15) {
                                if (posting) {
                                    LottieView(filename: "loadingWhite", loop: true)
                                        .frame(width: 20, height: 20)
                                        .scaleEffect(3)
                                } else {
                                    Image(systemName: isChanged ? "doc" : "checkmark")
                                        .font(.headline)
                                        .padding(.leading, 5)
                                }
                                Text(isChanged ? "Speichern" : "Gespeichert")
                                    .font(.system(size: screen.width < 500 ? screen.width * 0.050 : 18, weight: .medium))
                                    .padding(.trailing, 3)
                            }
                            .accentColor(Color("white"))
                            .padding(UIScreen.main.bounds.height < 600 ? 10 : 15)
                            .background(Color("blue"))
                            .cornerRadius(15)
                        }
                        .disabled(!isChanged)
                    } else {
                        Button(action: {
                            self.posting = true
                            self.isChanged = true
                            self.firstResponder = false
                            self.hideKeyboard()
                            self.firstResponder = false
                            self.postUserData()
                        }){
                            HStack (spacing: 15) {
                                if (posting) {
                                    LottieView(filename: "loadingWhite", loop: true)
                                        .frame(width: 20, height: 20)
                                        .scaleEffect(3)
                                } else {
                                    Image(systemName: isChanged ? "doc" : "checkmark")
                                        .font(.headline)
                                        .padding(.leading, 5)
                                }
                                Text(isChanged ? "Speichern" : "Gespeichert")
                                    .font(.system(size: screen.width < 500 ? screen.width * 0.050 : 18, weight: .medium))
                                    .padding(.trailing, 3)
                            }
                            .accentColor(Color("white"))
                            .padding(screen.height < 600 ? 10 : 15)
                            .background(Color("blue"))
                            .cornerRadius(15)
                        }
                        .padding(.bottom, keyboard.currentHeight)
                        .disabled(!isChanged)
                    }
                    Spacer()
                }
                .accentColor(.primary)
                .background(Color("background"))
                .animation(.spring())
                .onTapGesture(perform: {
                    self.firstResponder = false
                    self.hideKeyboard()
                })
                Spacer()
            }
        }
        .gesture(DragGesture()
                    .onChanged({ (value) in
                        if value.translation.width > 40 {
                            self.mode.wrappedValue.dismiss()
                        }
                    })
        )
    }
    
    func getUser() {
        guard let url = URL(string: myUrl.users + (id ?? "")) else { return }
            
            URLSession.shared.dataTask(with: url) { (data, _, _) in
                
                if let data = data {
                    if let user = try? JSONDecoder().decode(User.self, from: data) {
                        // we have good data – go back to the main thread
                        DispatchQueue.main.async {
                            // update our UI
                            self.user = user
                            if let i = self.ages.firstIndex(of: user.age ?? ""){
                                self.isSelected[i] = true
                                self.age = user.age ?? ""
                            }
                            if let i = self.genders.firstIndex(of: user.gender ?? ""){
                                self.isSelectedGender[i] = true
                                self.gender = user.gender ?? ""
                            }
                            if (user.hideInfo ?? false){
                                self.hideInfo = true
                            }
                            self.isChanged = false
                        }
                        
                        // everything is good, so we can exit
                        return
                    }
                }
            }
            .resume()
    }
    
    func postUserData(){
        let patchData = UserNameAgeGen(name: user2.name, age: age, gender: gender, hideInfo: hideInfo)
        
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
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.user.name = user2.name
                self.user.age = age
                self.user.gender = gender
                self.user.hideInfo = hideInfo
                self.isChanged = false
                self.posting = false
                self.getUser()
            }
        }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ProfilData_Previews: PreviewProvider {
    static var previews: some View {
        ProfilData(isChanged: .constant(false)).environmentObject(UserObserv())
    }
}
