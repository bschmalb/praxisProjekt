//
//  AddTippView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 05.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct AddTipp: Codable, Hashable, Identifiable {
    let id: UUID
    let category: String
    let difficulty: String
    var name: String
    var quelle: String
}

struct AddTippView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var levelEnv: UserLevel
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @Binding var showAddTipps: Bool
    
    @State var optionSelected: [Int] = [-1, -1, -1, -1]
    
    @State var category: String = ""
    @State var level: String = ""
    @State var name: String = ""
    @State var quelle: String = ""
    
    @State var offsets: [CGFloat] = [0, UIScreen.main.bounds.width, UIScreen.main.bounds.width, UIScreen.main.bounds.width]
    
    @State var step = 1
    
    var body: some View {
        VStack {
            VStack {
                
                HStack {
                    Text("Tipp posten")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.leading, 20)
                    
                    Spacer()
                    Button(action: {
                        self.showAddTipps = false
                        impact(style: .medium)
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 24, weight: Font.Weight.medium))
                            .padding(25)
                    }
                }
                .padding(.top, 20)
                
                ZStack {
                    VStack {
                        HStack {
                            Spacer()
                            Text("\(step)/5").bold().padding(20).foregroundColor(Color.secondary)
                        }
                        Spacer()
                    }
                    AddTipp1(category: $category, categorySelected: $optionSelected[0])
                        .offset(x: offsets[0])
                    AddTipp2(category: $level, categorySelected: $optionSelected[1])
                        .offset(x: offsets[1])
                    AddTipp3(category: $name, categorySelected: $optionSelected[2])
                        .offset(x: offsets[2])
                    AddTipp3(category: $quelle, categorySelected: $optionSelected[3])
                        .offset(x: offsets[3])
                }
                HStack {
                    Button (action: {
                        self.step -= 1
                        
                        self.back(i: self.step-1)
                        
                        self.hideKeyboard()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.headline)
                            .padding(5)
                            .frame(width: 80, height: 40)
                    }.opacity(step > 1 ? 1 : 0)
                    Spacer()
                    Button(action: {
                        impact(style: .medium)
                        self.step += 1
                        
                        self.next(i: self.step-1)
                        
                        self.hideKeyboard()
                    }) {
                        Image(systemName: "arrow.right")
                            .font(.headline)
                            .accentColor(Color(optionSelected[step-1] > -1 ? "white" :"white"))
                            .padding(5)
                            .frame(width: 80, height: 40)
                            .background(Color(optionSelected[step-1] > -1 ? "blue" : "blueDisabled"))
                            .cornerRadius(15)
                    }.disabled(optionSelected[step-1] < 0 && !(name.count > 0))
                }
                .animation(.linear)
                .padding(20)
                .padding(.bottom, keyboard.currentHeight)
            }
            Spacer()
        }.accentColor(Color("black"))
            .animation(.spring())
    }
    
    func next(i: Int) {
        self.offsets[i] = 0
        self.offsets[i-1] = -UIScreen.main.bounds.width
    }
    func back(i: Int) {
        self.offsets[i] = 0
        self.offsets[i+1] = UIScreen.main.bounds.width
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct AddTippView_Previews: PreviewProvider {
    static var previews: some View {
        AddTippView(showAddTipps: .constant(true))
    }
}

struct AddTipp1: View {
    
    @Binding var category: String
    @Binding var categorySelected: Int
    
    var body: some View {
        VStack {
            Image(uiImage: #imageLiteral(resourceName: "kategorie"))
                .resizable()
                .scaledToFit()
            Text("Wähle eine Kategorie für deinen Tipp")
                .font(.title)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding()
            
            HStack (spacing: 20) {
                
                SelectButton(categorySelected: $categorySelected, category: $category, selectAmount: 0, categoryLocal: "Nahrung", icon: "blackPie")
                SelectButton(categorySelected: $categorySelected, category: $category, selectAmount: 1, categoryLocal: "Transport", icon: "blackTransport")
                SelectButton(categorySelected: $categorySelected, category: $category, selectAmount: 2, categoryLocal: "Recycling", icon: "blackRecycle")
            }
            HStack {
                SelectButton(categorySelected: $categorySelected, category: $category, selectAmount: 3, categoryLocal: "Ressourcen", icon: "blackRessourcen")
            }
        }
        .accentColor(Color("black"))
    }
}

struct AddTipp2: View {
    
    @Binding var category: String
    @Binding var categorySelected: Int
    
    var body: some View {
        VStack {
            Image(uiImage: #imageLiteral(resourceName: "Success"))
                .resizable()
                .scaledToFit()
            Text("Wähle eine Niveaustufe für deinen Tipp")
                .font(.title)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding()
            
            HStack (spacing: 30) {
                SelectButton(categorySelected: $categorySelected, category: $category, selectAmount: 0, categoryLocal: "Leicht", icon: "blackStar")
                SelectButton(categorySelected: $categorySelected, category: $category, selectAmount: 1, categoryLocal: "Mittel", icon: "blackHalfStar")
                SelectButton(categorySelected: $categorySelected, category: $category, selectAmount: 2, categoryLocal: "Schwer", icon: "blackStarFilled")
            }
        }
        .accentColor(Color("black"))
    }
}

struct AddTipp3: View {
    
    @Binding var category: String
    @Binding var categorySelected: Int
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @State var isFocused = false
    
    var body: some View {
        VStack {
            Image(uiImage: #imageLiteral(resourceName: "Woman Carrying Browser Tab"))
                .resizable()
                .scaledToFit()
            Text("Gebe deinen Tipp ein")
                .font(.title)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding()
            
            VStack {
                HStack (alignment: .center){
                    Section {
                        TextField("Dein Tipp", text: $category)
                            .tag(1)
                            .id(1)
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
                .onAppear(){
                    self.isFocused = true
            }
            Spacer()
        }
        .onTapGesture {
            self.isFocused = false
            self.hideKeyboard()
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct AddTipp4: View {
    
    @Binding var category: String
    @Binding var categorySelected: Int
    
    var body: some View {
        VStack {
            Image(uiImage: #imageLiteral(resourceName: "kategorie"))
                .resizable()
                .scaledToFit()
            Text("Wähle eine Kategorie für deinen Tipp")
                .font(.title)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding()
            
            HStack (spacing: 20) {
                
                SelectButton(categorySelected: $categorySelected, category: $category, selectAmount: 0, categoryLocal: "Nahrung", icon: "blackPie")
                SelectButton(categorySelected: $categorySelected, category: $category, selectAmount: 1, categoryLocal: "Transport", icon: "blackTransport")
                SelectButton(categorySelected: $categorySelected, category: $category, selectAmount: 2, categoryLocal: "Recycling", icon: "blackRecycle")
            }
            HStack {
                SelectButton(categorySelected: $categorySelected, category: $category, selectAmount: 3, categoryLocal: "Ressourcen", icon: "blackRessourcen")
            }
        }
        .accentColor(Color("black"))
    }
}

struct AddTipp5: View {
    
    @Binding var category: String
    @Binding var categorySelected: Int
    
    var body: some View {
        VStack {
            Image(uiImage: #imageLiteral(resourceName: "kategorie"))
                .resizable()
                .scaledToFit()
            Text("Wähle eine Kategorie für deinen Tipp")
                .font(.title)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding()
            
            HStack (spacing: 20) {
                
                SelectButton(categorySelected: $categorySelected, category: $category, selectAmount: 0, categoryLocal: "Nahrung", icon: "blackPie")
                SelectButton(categorySelected: $categorySelected, category: $category, selectAmount: 1, categoryLocal: "Transport", icon: "blackTransport")
                SelectButton(categorySelected: $categorySelected, category: $category, selectAmount: 2, categoryLocal: "Recycling", icon: "blackRecycle")
            }
            HStack {
                SelectButton(categorySelected: $categorySelected, category: $category, selectAmount: 3, categoryLocal: "Ressourcen", icon: "blackRessourcen")
            }
        }
        .accentColor(Color("black"))
    }
}

struct SelectButton: View {
    
    @Binding var categorySelected: Int
    @Binding var category: String
    var selectAmount: Int
    var categoryLocal: String
    var icon: String
    
    var body: some View {
        Button(action: {
            impact(style: .medium)
            self.categorySelected = self.selectAmount
            
            self.category = self.categoryLocal
            
        }) {
            VStack {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .accentColor(Color(self.categorySelected == selectAmount ? "white" : "black"))
                    .offset(y: 3)
                Text(categoryLocal)
                    .font(.subheadline).fontWeight(.medium)
                    .fixedSize()
                    .foregroundColor(Color(self.categorySelected == selectAmount ? "white" : "black"))
                    .multilineTextAlignment(.center)
                    .padding(5)
            }.frame(height: 80)
                .padding(2)
                .padding(.horizontal, 10)
                .background(Color(categorySelected == selectAmount ? "blue" : "transparent"))
                .cornerRadius(15)
            
        }
    }
}
