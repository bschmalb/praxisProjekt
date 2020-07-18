//
//  AddTagebuchCard2.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 20.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct AddTagebuchCard7: View {
    
    @Binding var tabViewSelected: Int
    
    var kilometer: Int
    var meat: Int
    var cooked: Int
    var foodWaste: Int
    var drinks: Int
    var shower: Int
    
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var levelEnv: UserLevel
    
    @State var firstBinWaste: Bool = false
    @State var secondBinWaste: Bool = false
    @State var thirdBinWaste: Bool = false
    @State var binWasteSelected: Bool = false
    
    @State var selection: Int? = 0
    
    @State var binWaste: Int = 1
    
    @State var userLevelLocal = 0
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color("background")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Spacer()
                        Text("7/7").bold().padding(20).foregroundColor(Color.secondary)
                    }
                    Spacer()
                }
                VStack (spacing: 20){
                    Image("People Shopping")
                        .resizable()
                        .scaledToFit()
                        .frame(minHeight: 100, idealHeight: 200, maxHeight: 300)
                        .shadow(radius: 2)
                    Text("Hast du gestern auf die Mülltrennung geachtet?")
                        .font(.system(size: 20, weight: Font.Weight.medium))
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    HStack (spacing: 40) {
                        
                        Button(action: {
                            impact(style: .medium)
                            self.secondBinWaste = false
                            self.thirdBinWaste = false
                            
                            self.binWasteSelected = true
                            self.firstBinWaste = true
                            
                            self.binWaste = 0
                            
                        }) {
                            VStack {
                                Text("Ja")
                                    .font(.system(size: 18, weight: Font.Weight.medium))
                                    .foregroundColor(Color(self.firstBinWaste ? "white" : "black"))
                            }.frame(height: 50)
                            .padding(2)
                            .padding(.horizontal, 13)
                            .background(Color(firstBinWaste ? "blue" : "transparent"))
                            .cornerRadius(15)
                            
                        }
                        Button(action: {
                            impact(style: .medium)
                            self.firstBinWaste = false
                            self.thirdBinWaste = false
                            
                            self.binWasteSelected = true
                            self.secondBinWaste = true
                            
                            self.binWaste = 1
                        }) {
                            VStack {
                                Text("Teilweise")
                                    .font(.system(size: 18, weight: Font.Weight.medium))
                                    .foregroundColor(Color(self.secondBinWaste ? "white" : "black"))
                            }.frame(height: 50)
                            .padding(2)
                            .padding(.horizontal, 13)
                            .background(Color(secondBinWaste ? "blue" : "transparent"))
                            .cornerRadius(15)
                            
                        }
                        Button(action: {
                            impact(style: .medium)
                            self.firstBinWaste = false
                            self.secondBinWaste = false
                            
                            self.binWasteSelected = true
                            self.thirdBinWaste = true
                            
                            self.binWaste = 2
                        }) {
                            VStack {
                                Text("Nein")
                                    .font(.system(size: 18, weight: Font.Weight.medium))
                                    .foregroundColor(Color(self.thirdBinWaste ? "white" : "black"))
                            }.frame(height: 50)
                            .padding(2)
                            .padding(.horizontal, 13)
                            .background(Color(thirdBinWaste ? "blue" : "transparent"))
                            .cornerRadius(15)
                        }
                    }.padding(.bottom, 10)
                    
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
                        NavigationLink(destination: AddTagebuchSuccess(tabViewSelected: $tabViewSelected)
                                        .navigationBarTitle("")
                                        .navigationBarHidden(true)
                                        .navigationBarBackButtonHidden(true)
                                       , tag: 1, selection: $selection) {
                            Button(action: {
                                haptic(type: .success)
                                self.levelEnv.level += 35
                                UserDefaults.standard.set(self.levelEnv.level, forKey: "userLevel")
                                self.binWasteSelected = false
                                self.postLog()
                                self.selection = 1
                            }) {
                                HStack {
                                    Image(systemName: "folder.badge.plus")
                                        .font(.headline)
                                        .accentColor(Color(binWasteSelected ? "white" :"white"))
                                        .padding(0)
                                    Text("Speichern")
                                        .font(.headline)
                                        .accentColor(Color(binWasteSelected ? "white" :"white"))
                                        .padding(0)
                                }
                                .padding(20)
                                .frame(height: 50)
                                .background(Color(binWasteSelected ? "blue" : "blueDisabled"))
                                .cornerRadius(15)
                            }
                        }.disabled(!binWasteSelected)
//                        Spacer()
//                        Button(action: {
//                            binWasteSelected = false
//                            postLog()
//                        })
//                        {
//                            Image(systemName: "arrow.right")
//                                .font(.headline)
//                                .accentColor(Color(binWasteSelected ? "white" :"white"))
//                                .padding(5)
//                                .frame(width: 80, height: 40)
//                                .background(Color(binWasteSelected ? "blue" : "blueDisabled"))
//                                .cornerRadius(15)
//                        }
//                        .disabled(!binWasteSelected)
                        
                    }
                    .padding(20)
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .accentColor(Color("black"))
            }
        }
    }
    
    func postLog(){
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            
            let today = Date()
            let formatter1 = DateFormatter()
            formatter1.dateStyle = .short
            let date = formatter1.string(from: today)
            
            UserDefaults.standard.set(date, forKey: "logDate")
            
            let logData = LogAdd(log: Log(id: UUID().uuidString, kilometer: kilometer, meat: meat, cooked: cooked, foodWaste: foodWaste, drinks: drinks, shower: shower, binWaste: binWaste, date: date))
            
            guard let encoded = try? JSONEncoder().encode(logData) else {
                print("Failed to encode order")
                return
            }
            guard let url = URL(string: "http://bastianschmalbach.ddns.net/users/" + uuid) else { return }
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "PATCH"
            request.httpBody = encoded
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                    return
                }
//                print(data)
                
                UserDefaults.standard.set(date, forKey: "logDate")
//                self.isSuccess = true
//                DispatchQueue.main.asyncAfter(deadline: .now() + 7, execute: {
//                    self.showAddTipps = false;
//                    self.isSuccess = false
//                })
            }.resume()
        }
    }
}

struct LogAdd : Encodable{
    var log: Log
}

struct AddTagebuchCard7_Previews: PreviewProvider {
    static var previews: some View {
        AddTagebuchCard7(tabViewSelected: .constant(2), kilometer: 0, meat: 0, cooked: 0, foodWaste: 0, drinks: 0, shower: 0)
    }
}
