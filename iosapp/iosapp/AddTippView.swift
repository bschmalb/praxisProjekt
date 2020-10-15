//
//  AddTippView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 05.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI
import UIKit

struct AddTipp: Codable, Hashable, Identifiable {
    let id: UUID
    let category: String
    let difficulty: String
    var name: String
    var quelle: String
}

struct AddTippView: View {
    
    @State var id = UserDefaults.standard.string(forKey: "id")
    
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var levelEnv: UserLevel
    @EnvironmentObject var overlay: Overlay
    @EnvironmentObject var myUrl: ApiUrl
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @Binding var showAddTipps: Bool
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
                        AddTipp3(category: $name, categorySelected: $optionSelected[2], firstResponder: $isReponder)
                            .offset(x: offsets[2])
                        AddTipp4(category: $quelle, categorySelected: $optionSelected[3], firstResponder: $isReponder2)
                            .offset(x: offsets[3])
                        AddTipp5(category: $category, level: $level, title: $name, quelle: $quelle, categorySelected: $optionSelected[4])
                            .offset(x: offsets[4])
                            .padding(.bottom)
                    }
                    HStack {
                        Button (action: {
                            if (step != 4) {
                                self.hideKeyboard()
                            }
                            
                            self.step -= 1
                            
                            if (step == 4){
                                self.isReponder2 = true
                            }
                            else if (step == 3) {
                                self.isReponder2 = false
                                self.isReponder = true
                            }
                            else if (step == 2) {
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
                            if (step < 5){
                                impact(style: .medium)
                                
                                if (step != 3) {
                                    self.hideKeyboard()
                                    print("self.hideKeyboard()")
                                }
                                
                                self.step += 1
                                
                                if (step == 3) {
                                    self.isReponder = true
                                }
                                else if (step == 4) {
                                    self.isReponder2 = true
                                    self.isReponder = false
                                }
                                else if (step == 5) {
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
                                self.postTipp()
                            }
                        }) {
                            if (step < 5) {
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
                        AddTipp3(category: $name, categorySelected: $optionSelected[2], firstResponder: $isReponder)
                            .offset(x: offsets[2])
                        AddTipp4(category: $quelle, categorySelected: $optionSelected[3], firstResponder: $isReponder2)
                            .offset(x: offsets[3])
                        AddTipp5(category: $category, level: $level, title: $name, quelle: $quelle, categorySelected: $optionSelected[4])
                            .offset(x: offsets[4])
                            .padding(.bottom)
                    }
                    HStack {
                        Button (action: {
                            if (step != 4) {
                                self.hideKeyboard()
                            }
                            
                            self.step -= 1
                            
                            if (step == 4){
                                self.isReponder2 = true
                            }
                            else if (step == 3) {
                                self.isReponder2 = false
                                self.isReponder = true
                            }
                            else if (step == 2) {
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
                            if (step < 5){
                                impact(style: .medium)
                                
                                if (step != 3) {
                                    self.hideKeyboard()
                                    print("self.hideKeyboard()")
                                }
                                
                                self.step += 1
                                
                                if (step == 3) {
                                    self.isReponder = true
                                }
                                else if (step == 4) {
                                    self.isReponder2 = true
                                    self.isReponder = false
                                }
                                else if (step == 5) {
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
                                self.postTipp()
                            }
                        }) {
                            if (step < 5) {
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
                        self.showAddTipps = false
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
    
    func postTipp(){
        let tippData = PostTipp(title: self.name, source: self.quelle, category: self.category, level: self.level, score: 0, postedBy: id ?? "error", official: "Community")
        
        guard let encoded = try? JSONEncoder().encode(tippData) else {
            print("Failed to encode order")
            return
        }
        guard let url = URL(string: myUrl.tipps) else { return }
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
                    self.showAddTipps = false;
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

struct Message: Decodable {
    var message: String
}

struct AddTippView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddTippView(showAddTipps: .constant(true))
                .previewDevice(PreviewDevice(rawValue: "iPod touch (7th generation))"))
                .previewDisplayName("iPod touch (7th generation)")
            //
            AddTippView(showAddTipps: .constant(true))
                .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
                .previewDisplayName("iPhone 11")
        }
    }
}

struct AddTipp1: View {
    
    @Binding var category: String
    @Binding var categorySelected: Int
    
    var screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        VStack {
            Image(uiImage: #imageLiteral(resourceName: "kategorie"))
                .resizable()
                .scaledToFit()
            Text("Wähle eine Kategorie für deinen Tipp")
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

struct AddTipp2: View {
    
    @Binding var category: String
    @Binding var categorySelected: Int
    
    var screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        VStack {
            Image(uiImage: #imageLiteral(resourceName: "Success"))
                .resizable()
                .scaledToFit()
            Text("Wähle eine Niveaustufe für deinen Tipp")
                .font(.system(size: screenWidth < 500 ? screenWidth * 0.06 : 24))
                .multilineTextAlignment(.center)
                .padding()
            
            HStack (spacing: 30) {
                SelectButton(categorySelected: $categorySelected, category: $category, selectAmount: 0, categoryLocal: "Leicht", icon: "Star")
                SelectButton(categorySelected: $categorySelected, category: $category, selectAmount: 1, categoryLocal: "Mittel", icon: "HalfStar")
                SelectButton(categorySelected: $categorySelected, category: $category, selectAmount: 2, categoryLocal: "Schwer", icon: "StarFilled")
            }
        }
        .accentColor(Color("black"))
    }
}

struct AddTipp3: View {
    
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
            Image(uiImage: #imageLiteral(resourceName: "Woman Carrying Browser Tab"))
                .resizable()
                .scaledToFit()
            Text("Gebe deinen Tipp ein")
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

struct AddTipp4: View {
    
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
            Image(uiImage: #imageLiteral(resourceName: "Working"))
                .resizable()
                .scaledToFit()
            Text("Gebe wenn möglich eine Quelle für deinen Tipp an")
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

struct AddTipp5: View {
    
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

struct SelectButton: View {
    
    @Binding var categorySelected: Int
    @Binding var category: String
    var selectAmount: Int
    var categoryLocal: String
    var icon: String
    
    var screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        Button(action: {
            impact(style: .medium)
            self.categorySelected = self.selectAmount
            
            self.category = self.categoryLocal
            
        }) {
            VStack {
                Image(categoryLocal)
                    .resizable()
                    .scaledToFit()
                    .offset(y: 3)
                Text(categoryLocal)
                    .font(.system(size: screenWidth < 500 ? screenWidth * 0.04 : 18, weight: .medium))
                    .fixedSize()
                    .multilineTextAlignment(.center)
                    .padding(5)
            }.frame(height: screenWidth < 500 ? screenWidth / 5 : 80)
            .padding(2)
            .padding(.horizontal, 5)
            .foregroundColor(Color(self.categorySelected == selectAmount ? "white" : "black"))
            .background(Color(categorySelected == selectAmount ? "blue" : "transparent"))
            .cornerRadius(15)
            
        }
    }
}

struct CustomTextField: UIViewRepresentable {
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        @Binding var text: String
        @Binding var nextResponder : Bool?
        @Binding var isResponder : Bool?
        
        
        init(text: Binding<String>,nextResponder : Binding<Bool?> , isResponder : Binding<Bool?>) {
            _text = text
            _isResponder = isResponder
            _nextResponder = nextResponder
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.isResponder = true
            }
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.isResponder = false
                if self.nextResponder != nil {
                    self.nextResponder = true
                }
            }
        }
    }
    
    @Binding var text: String
    @Binding var nextResponder : Bool?
    @Binding var isResponder : Bool?
    
    var isSecured : Bool = false
    var keyboard : UIKeyboardType
    
    func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.isSecureTextEntry = isSecured
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .yes
        textField.keyboardType = keyboard
        textField.delegate = context.coordinator
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        return textField
    }
    
    func makeCoordinator() -> CustomTextField.Coordinator {
        return Coordinator(text: $text, nextResponder: $nextResponder, isResponder: $isResponder)
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomTextField>) {
        uiView.text = text
        if isResponder ?? false {
            uiView.becomeFirstResponder()
        }
    }
    
}

struct CustomTextField2: UIViewRepresentable {
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        @Binding var text: String
        @Binding var isFirstResponder: Bool?
        @State var maxLength: Int
        
        @State var didBecomeFirstResponder = false
        
        init(text: Binding<String>, isFirstResponder: Binding<Bool?>, maxLength: State<Int>) {
            _text = text
            _isFirstResponder = isFirstResponder
            _maxLength = maxLength
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            if let t: String = textField.text {
                textField.text = String(t.prefix(maxLength))
                text = textField.text!
            }
//            text = textField.text ?? ""
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.isFirstResponder = true
            }
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.isFirstResponder = false
            }
        }
    }
    
    @Binding var text: String
    @Binding var isFirstResponder: Bool?
    @State var maxLength: Int
    
    func makeUIView(context: UIViewRepresentableContext<CustomTextField2>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.bounds.size.width = UIScreen.main.bounds.width - 30
        return textField
    }
    
    func makeCoordinator() -> CustomTextField2.Coordinator {
        return Coordinator(text: $text, isFirstResponder: $isFirstResponder, maxLength: _maxLength)
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomTextField2>) {
        uiView.text = text
        if isFirstResponder ?? false && !context.coordinator.didBecomeFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        } else if (!(isFirstResponder ?? true) && context.coordinator.didBecomeFirstResponder){
            uiView.resignFirstResponder()
            context.coordinator.didBecomeFirstResponder = false
        }
        else if (!(isFirstResponder ?? true)){
            uiView.resignFirstResponder()
            context.coordinator.didBecomeFirstResponder = false
        }
    }
}

struct MultilineTextView: UIViewRepresentable {
    
    class Coordinator: NSObject, UITextViewDelegate {
        
        @Binding var text: String
        @Binding var isFirstResponder: Bool?
        @State var maxLength: Int
        
        @State var didBecomeFirstResponder = false
        
        init(text: Binding<String>, isFirstResponder: Binding<Bool?>, maxLength: State<Int>) {
            _text = text
            _isFirstResponder = isFirstResponder
            _maxLength = maxLength
        }
        
        func textViewDidChange(_ textField: UITextView) {
            if let t: String = textField.text {
                textField.text = String(t.prefix(maxLength))
                text = textField.text!
            }
        }
        
        func textViewDidBeginEditing(_ textField: UITextView) {
            DispatchQueue.main.async {
                self.isFirstResponder = true
            }
        }
        
        func textViewDidEndEditing(_ textField: UITextView) {
            DispatchQueue.main.async {
                self.isFirstResponder = false
            }
        }
    }
    
    @Binding var text: String
    @Binding var isFirstResponder: Bool?
    @State var maxLength: Int
    @State var fontSize: CGFloat = 0.055

    @State var didBecomeFirstResponder = false

    func makeCoordinator() -> MultilineTextView.Coordinator {
        return MultilineTextView.Coordinator(text: $text, isFirstResponder: $isFirstResponder, maxLength: _maxLength)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isScrollEnabled = true
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 5
        view.delegate = context.coordinator
        view.font = .systemFont(ofSize: UIScreen.main.bounds.width * fontSize)
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        if isFirstResponder ?? false && !context.coordinator.didBecomeFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        } else if (!(isFirstResponder ?? true) && context.coordinator.didBecomeFirstResponder){
            uiView.resignFirstResponder()
            context.coordinator.didBecomeFirstResponder = false
        }
        else if (!(isFirstResponder ?? true)){
            uiView.resignFirstResponder()
            context.coordinator.didBecomeFirstResponder = false
        }
    }
}

struct MultilineTextView2: UIViewRepresentable {
    
    class Coordinator: NSObject, UITextViewDelegate {
        
        @Binding var text: String
        @Binding var isFirstResponder: Bool?
        @State var maxLength: Int
        
        @State var didBecomeFirstResponder = false
        
        init(text: Binding<String>, isFirstResponder: Binding<Bool?>, maxLength: State<Int>) {
            _text = text
            _isFirstResponder = isFirstResponder
            _maxLength = maxLength
        }
        
        func textViewDidChange(_ textField: UITextView) {
            if let t: String = textField.text {
                textField.text = String(t.prefix(maxLength))
                text = textField.text!
            }
        }
        
        func textViewDidBeginEditing(_ textField: UITextView) {
            DispatchQueue.main.async {
                self.isFirstResponder = true
            }
        }
        
        func textViewDidEndEditing(_ textField: UITextView) {
            DispatchQueue.main.async {
                self.isFirstResponder = false
            }
        }
    }
    
    @Binding var text: String
    @Binding var isFirstResponder: Bool?
    @State var maxLength: Int

    @State var didBecomeFirstResponder = false

    func makeCoordinator() -> MultilineTextView2.Coordinator {
        return MultilineTextView2.Coordinator(text: $text, isFirstResponder: $isFirstResponder, maxLength: _maxLength)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isScrollEnabled = true
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        let myColor : UIColor = UIColor( red: 0.1, green: 0.1, blue: 0.1, alpha: 0.1 )
        view.layer.borderColor = myColor.cgColor
        view.delegate = context.coordinator
        view.font = .systemFont(ofSize: 18)
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}
