//
//  AddTippView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 05.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI
import UIKit

struct AddFact: Codable, Hashable, Identifiable {
    let id: UUID
    let category: String
    var name: String
    var quelle: String
}

struct AddFactView: View {
    
    @State var id = UserDefaults.standard.string(forKey: "id")
    
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var levelEnv: UserLevel
    @EnvironmentObject var overlay: Overlay
    @EnvironmentObject var myUrl: ApiUrl
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @Binding var showAddFacts: Bool
    @State var isReponder: Bool? = false
    @State var isReponder2: Bool? = false
    
    @State var isSuccess = false
    @State var isLoading = false
    @State var isError = false
    @State var show = false
    @State var posted = false
    
    @State var optionSelected: [Int] = [-1, -1, -1, 1, 1]
    
    @State var category: String = "Transport"
    @State var level: String = "Leicht"
    @State var name: String = ""
    @State var quelle: String = ""
    
    @State var offsets: [CGFloat] = [0, UIScreen.main.bounds.width, UIScreen.main.bounds.width, UIScreen.main.bounds.width, UIScreen.main.bounds.width]
    
    @State var step = 1
    
    var body: some View {
        ZStack {
            if #available(iOS 14, *) {
                VStack (spacing: 0) {
                    
                    HStack {
                        Text("Fakt posten")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.leading, 20)
                        
                        Spacer()
                        Button(action: {
                            self.showAddFacts = false
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
                                Text("\(step)/4").bold().padding(20).foregroundColor(Color.secondary)
                            }
                            Spacer()
                        }
                        AddFact1(category: $category, categorySelected: $optionSelected[0])
                            .offset(x: offsets[0])
                        AddFact3(category: $name, categorySelected: $optionSelected[1], firstResponder: $isReponder)
                            .offset(x: offsets[1])
                        AddFact4(category: $quelle, categorySelected: $optionSelected[2], firstResponder: $isReponder2)
                            .offset(x: offsets[2])
                        AddFact5(category: $category, level: $level, title: $name, quelle: $quelle, categorySelected: $optionSelected[3])
                            .offset(x: offsets[3])
                            .padding(.bottom)
                    }
                    HStack {
                        Button (action: {
                            if (step != 3) {
                                self.hideKeyboard()
                            }
                            
                            self.step -= 1
                            
                            if (step == 3){
                                self.isReponder2 = true
                            }
                            else if (step == 2) {
                                self.isReponder2 = false
                                self.isReponder = true
                            }
                            else if (step == 1) {
                                self.isReponder = false
                            }
                            
                            self.back(i: self.step-1)
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.headline)
                                .padding(5)
                                .frame(width: 80, height: 40)
                        }.opacity(step > 1 ? 1 : 0)
                        Spacer()
                        Button(action: {
                            if (step < 4){
                                impact(style: .medium)
                                
                                if (step != 2) {
                                    self.hideKeyboard()
                                    print("self.hideKeyboard()")
                                }
                                
                                self.step += 1
                                
                                if (step == 2) {
                                    self.isReponder = true
                                }
                                else if (step == 3) {
                                    self.isReponder2 = true
                                    self.isReponder = false
                                }
                                else if (step == 4) {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        self.hideKeyboard()
                                        self.isReponder2 = false
                                        self.isReponder = false
                                    }
                                }
                                
                                self.next(i: self.step-1)
                            }
                            else {
                                self.posted = true
                                self.overlay.overlayLog = true
                                self.isLoading = true
                                self.show = true
                                self.postFact()
                            }
                        }) {
                            if (step < 4) {
                                Image(systemName: "arrow.right")
                                    .font(.headline)
                                    .accentColor(Color(optionSelected[step-1] > -1 ? "white" :"white"))
                                    .padding(5)
                                    .frame(width: 80, height: 40)
                                    .background(Color(optionSelected[step-1] > -1 ? "blue" : "blueDisabled"))
                                    .cornerRadius(15)
                            } else {
                                HStack {
                                    Image(systemName: "arrow.up.doc")
                                        .font(.headline)
                                    Text("Posten")
                                        .font(.headline)
                                }
                                .accentColor(Color("white"))
                                .frame(width: 140, height: 50)
                                .background(Color("blue"))
                                .cornerRadius(15)
                            }
                        }.disabled(optionSelected[step-1] < 0 || posted)
                    }
                    .animation(.linear)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 20)
                }
                .blur(radius: isLoading || isSuccess || isError ? 4 : 0)
            } else {
                VStack (spacing: 0) {
                    
                    HStack {
                        Text("Fakt posten")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.leading, 20)
                        
                        Spacer()
                        Button(action: {
                            self.showAddFacts = false
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
                                Text("\(step)/4").bold().padding(20).foregroundColor(Color.secondary)
                            }
                            Spacer()
                        }
                        AddFact1(category: $category, categorySelected: $optionSelected[0])
                            .offset(x: offsets[0])
                        AddFact3(category: $name, categorySelected: $optionSelected[1], firstResponder: $isReponder)
                            .offset(x: offsets[1])
                        AddFact4(category: $quelle, categorySelected: $optionSelected[2], firstResponder: $isReponder2)
                            .offset(x: offsets[2])
                        AddFact5(category: $category, level: $level, title: $name, quelle: $quelle, categorySelected: $optionSelected[3])
                            .offset(x: offsets[3])
                            .padding(.bottom)
                    }
                    HStack {
                        Button (action: {
                            if (step != 3) {
                                self.hideKeyboard()
                            }
                            
                            self.step -= 1
                            
                            if (step == 3){
                                self.isReponder2 = true
                            }
                            else if (step == 2) {
                                self.isReponder2 = false
                                self.isReponder = true
                            }
                            else if (step == 1) {
                                self.isReponder = false
                            }
                            
                            self.back(i: self.step-1)
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.headline)
                                .padding(5)
                                .frame(width: 80, height: 40)
                        }.opacity(step > 1 ? 1 : 0)
                        Spacer()
                        Button(action: {
                            if (step < 4){
                                impact(style: .medium)
                                
                                if (step != 2) {
                                    self.hideKeyboard()
                                    print("self.hideKeyboard()")
                                }
                                
                                self.step += 1
                                
                                if (step == 2) {
                                    self.isReponder = true
                                }
                                else if (step == 3) {
                                    self.isReponder2 = true
                                    self.isReponder = false
                                }
                                else if (step == 4) {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        self.hideKeyboard()
                                        self.isReponder2 = false
                                        self.isReponder = false
                                    }
                                }
                                
                                self.next(i: self.step-1)
                            }
                            else {
                                self.posted = true
                                self.overlay.overlayLog = true
                                self.isLoading = true
                                self.show = true
                                self.postFact()
                            }
                        }) {
                            if (step < 4) {
                                Image(systemName: "arrow.right")
                                    .font(.headline)
                                    .accentColor(Color(optionSelected[step-1] > -1 ? "white" :"white"))
                                    .padding(5)
                                    .frame(width: 80, height: 40)
                                    .background(Color(optionSelected[step-1] > -1 ? "blue" : "blueDisabled"))
                                    .cornerRadius(15)
                            } else {
                                HStack {
                                    Text("Posten")
                                        .font(.headline)
                                    Image(systemName: "arrow.up.doc")
                                        .font(.headline)
                                }
                                .accentColor(Color("white"))
                                .padding(5)
                                .frame(width: 120, height: 40)
                                .background(Color("blue"))
                                .cornerRadius(15)
                            }
                        }.disabled(optionSelected[step-1] < 0 || posted)
                    }
                    .animation(.linear)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, keyboard.currentHeight / 2)
                .offset(y: -keyboard.currentHeight / 2)
                .blur(radius: isLoading || isSuccess || isError ? 4 : 0)
            }
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
                    VStack {
                        Text("Fehler beim Posten. Versuche es erneut")
                            .font(.headline)
                            .offset(y: 20)
                        Text("Okay")
                            .padding()
                    }
                }.frame(width: 200, height: 130)
                .background(Color("white"))
                .cornerRadius(20)
                .shadow(radius: 20)
                .offset(x: show ? 0 : -UIScreen.main.bounds.width, y: -50)
                .opacity(show ? 1 : 0)
                .scaleEffect(show ? 1 : 0)
                .onTapGesture {
                    self.posted = false
                    self.show = false
                    self.isSuccess = false
                    self.overlay.overlayLog = false
                }
                .animation(.spring())
            }
            
            if isSuccess {
                SuccessView()
                    .onTapGesture {
                        self.showAddFacts = false
                        self.isSuccess = false
                        self.overlay.overlayLog = false
                    }
            }
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
    
    func postFact(){
        let factData = PostFact(title: self.name, source: self.quelle, category: self.category, postedBy: id ?? "error", official: "Community")
        
        guard let encoded = try? JSONEncoder().encode(factData) else {
            print("Failed to encode order")
            return
        }
        guard let url = URL(string: myUrl.facts) else { return }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                return
            }
            guard let decoded = try? JSONDecoder().decode(Message.self, from: data) else {
                print("Failed to encode order")
                self.posted = false
                self.show = false
                self.isSuccess = false
                self.overlay.overlayLog = false
                return
            }
            if (decoded.message.contains("erfolgreich")){
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    haptic(type: .success)
                    self.levelEnv.level += 35
                    UserDefaults.standard.set(self.levelEnv.level, forKey: "userLevel")
                    self.isLoading = false
                    self.isSuccess = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 15, execute: {
                    self.showAddFacts = false;
                    self.isSuccess = false
                    self.overlay.overlayLog = false
                })
            } else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                self.posted = false
                self.show = false
                self.isSuccess = false
                self.overlay.overlayLog = false
                return
            }
        }.resume()
    }
}

struct PostFact: Codable {
    let title: String
    let source: String
    let category: String
    let postedBy: String
    let official: String?
}


struct AddFactView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddFactView(showAddFacts: .constant(true))
                .previewDevice(PreviewDevice(rawValue: "iPod touch (7th generation))"))
                .previewDisplayName("iPod touch (7th generation)")
            //
            AddFactView(showAddFacts: .constant(true))
                .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
                .previewDisplayName("iPhone 11")
        }
    }
}

struct AddFact1: View {
    
    @Binding var category: String
    @Binding var categorySelected: Int
    
    var screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        VStack {
            Image("Categories")
                .resizable()
                .scaledToFit()
            Text("Wähle eine Kategorie für den Fakt")
                .font(.system(size: screenWidth < 500 ? screenWidth * 0.06 : 24))
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
            
            HStack (spacing: 20) {
                SelectButton(categorySelected: $categorySelected, category: $category, selectAmount: 0, categoryLocal: "Ernährung", icon: "Fruits")
                SelectButton(categorySelected: $categorySelected, category: $category, selectAmount: 1, categoryLocal: "Transport", icon: "Transport")
                SelectButton(categorySelected: $categorySelected, category: $category, selectAmount: 2, categoryLocal: "Haushalt", icon: "Haushalt")
            }
            HStack {
                SelectButton(categorySelected: $categorySelected, category: $category, selectAmount: 3, categoryLocal: "Ressourcen", icon: "Ressourcen")
            }
        }
        .accentColor(Color("black"))
    }
}


struct AddFact3: View {
    
    @Binding var category: String
    @Binding var categorySelected: Int
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @Binding var firstResponder: Bool?
    
    var screen = UIScreen.main.bounds
    
    var body: some View {
        
        let binding = Binding<String>(get: {
            self.category
        }, set: {
            self.category = $0
            categorySelected = self.category.count
        })
        
        return VStack {
            Image("HappyTab")
                .resizable()
                .scaledToFit()
            Text("Gebe den Fact ein")
                .font(.system(size: screen.width < 500 ? screen.width * 0.06 : 24))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
            
            VStack {
                HStack (alignment: .center){
                    Section {
                        ZStack{
                            MultilineTextView(text: binding, isFirstResponder: $firstResponder, maxLength: 70)
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Text("\(category.count)/70")
                                        .padding(5)
                                        .font(.system(size: screen.width < 500 ? screen.width * 0.03 : 12))
                                        .opacity(0.5)
                                }
                            }
                        }.frame(height: UIScreen.main.bounds.width * 0.25)
                        .frame(maxWidth: UIScreen.main.bounds.width - 30)
                    }
                }
            }.padding(.horizontal)
            .edgesIgnoringSafeArea(.bottom)
            .animation(.easeInOut)
            Spacer()
        }
        .onTapGesture {
            self.firstResponder = false
            self.hideKeyboard()
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct AddFact4: View {
    
    @Binding var category: String
    @Binding var categorySelected: Int
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @Binding var firstResponder: Bool?
    
    var screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        
        let binding = Binding<String>(get: {
            self.category
        }, set: {
            self.category = $0
            categorySelected = self.category.count
        })
        
        return VStack {
            Image("Research")
                .resizable()
                .scaledToFit()
            Text("Gebe eine Quelle für den Fakt an")
                .font(.system(size: screenWidth < 500 ? screenWidth * 0.06 : 24))
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
            
            VStack {
                HStack (alignment: .center){
                    Section {
                        //                        CustomTextField(text: binding,
                        //                                        nextResponder: .constant(false),
                        //                                        isResponder: $firstResponder,
                        //                                        isSecured: false,
                        //                                        keyboard: .default)
                        //                            .frame(height: 40)
                        MultilineTextView(text: binding, isFirstResponder: $firstResponder, maxLength: 1000, fontSize: 0.04)
                            .frame(height: 50)
                            .frame(maxWidth: UIScreen.main.bounds.width - 30)
                        
//                        CustomTextField2(text: binding, isFirstResponder: $firstResponder, maxLength: 5)
//                            .frame(height: 40)
//                            .frame(maxWidth: UIScreen.main.bounds.width - 30)
                        
                        //                        TextField("Dein Tipp", text: binding)
                        //                            .font(.system(size: 18))
                        //                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
            }.padding(.horizontal)
            .edgesIgnoringSafeArea(.bottom)
            .animation(.easeInOut)
            Spacer()
        }
        .onTapGesture {
            self.firstResponder = false
            self.hideKeyboard()
        }
        .accentColor(Color("black"))
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}

struct AddFact5: View {
    
    @Binding var category: String
    @Binding var level: String
    @Binding var title: String
    @Binding var quelle: String
    @Binding var categorySelected: Int
    
    var screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        VStack {
            Text("Vorschau")
                .font(.system(size: screenWidth < 500 ? screenWidth * 0.045 : 20))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()
            
            ZStack {
                VStack{
                    Spacer()
                    Image("I"+category)
                        .resizable()
                        .scaledToFit()
                        .frame(minHeight: 100, maxHeight: 200)
                    Text(title)
                        .font(.system(size: screenWidth < 500 ? screenWidth * 0.07  - CGFloat(title.count / 25) : 26, weight: .medium))
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(Color("alwaysblack"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    Button(action: {
                    }) {
                        Text("Quelle")
                            .foregroundColor(.gray)
                            .font(.system(size: screenWidth * 0.03, weight: .medium))
                            .multilineTextAlignment(.center)
                            .padding(5)
                    }
                    Spacer()
                    HStack {
                        Image(systemName: "plus")
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
                .frame(width: UIScreen.main.bounds.width > 600 ? 600 : UIScreen.main.bounds.width - 40)
                .frame(minHeight: 200, maxHeight: 400)
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
                            .padding(.leading, 15)
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
                }.frame(width: UIScreen.main.bounds.width > 600 ? 600 : UIScreen.main.bounds.width - 40)
                .frame(minHeight: 200, maxHeight: 400)
            }
        }
        .accentColor(Color("black"))
    }
}
