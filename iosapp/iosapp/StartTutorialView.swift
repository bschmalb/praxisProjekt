//
//  StartTutorialView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 21.09.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI
import Combine

struct StartTutorialView: View {
    
    @Binding var show: Bool
    @Binding var animation: Bool
    @ObservedObject var filter: FilterData2
    
    @State var id: String = UserDefaults.standard.string(forKey: "id") ?? ""
    
    @EnvironmentObject var user: UserObserv
    @EnvironmentObject var myUrl: ApiUrl
    
    @State var firstResponder: Bool? = false
    @State var name: String = ""
    @State var nameLength = 0
    @State var age: String = ""
    @State var gender: String = ""
    @State var hideInfo: Bool = UserDefaults.standard.bool(forKey: "hideInfo")
    @State var categories: [String] = UserDefaults.standard.stringArray(forKey: "notCategory") ?? []
    @State var difficulties: [String] = UserDefaults.standard.stringArray(forKey: "notDifficulty") ?? []
    
    @State var loading: Bool = false
    @State var loadingAnimation: Bool = false
    @State var success: Bool = false
    @State var successScale: Bool = false
    
    @Binding var launchScreen: Bool
    
    @State var firstCapsule: CGFloat = 0
    @State var secondCapsule: CGFloat = 2
    @State var thirdCapsule: CGFloat = 8
    
    @State var offsets: [CGFloat] = [0, UIScreen.main.bounds.width, UIScreen.main.bounds.width, UIScreen.main.bounds.width, UIScreen.main.bounds.width]
    @State var optionSelected: [Int] = [-1, -1, 1, 1, 1]
    @State var step: Int = 0
    
    @ObservedObject var keyboard = KeyboardResponder()
    
    var body: some View {
        
        return ZStack {
            Color("background")
                .edgesIgnoringSafeArea(.all)
                .onTapGesture(perform: {
                    self.firstResponder = false
                    self.hideKeyboard()
                })
            VStack{
                HStack {
                    Spacer()
                    Button(action: {
                        self.firstResponder = false
                        self.hideKeyboard()
                        self.postUserData()
                        self.animation = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            self.show = true
                        }
                    }){
                        Image(systemName: "xmark")
                            .padding(30)
                            .opacity(0.1)
                    }
                }
                Spacer()
            }
            VStack {
                ZStack {
                    Intro1(name: $name, nameLength: $optionSelected[0], firstResponder: $firstResponder)
                        .offset(x: offsets[0])
                        .opacity(step == 0 ? 1 : 0)
                    Intro2(age: $age, gender: $gender, hideInfo: $hideInfo, optionSelected: $optionSelected[step], firstResponder: $firstResponder)
                        .offset(x: offsets[1])
                        .opacity(step == 1 ? 1 : 0)
                    Intro3(optionSelected: $optionSelected[step], filter: filter).environmentObject(FilterData2())
                        .offset(x: offsets[2])
                        .opacity(step == 2 ? 1 : 0)
                    Intro4(filter: filter, categories: $categories, optionSelected: $optionSelected[step])
                        .offset(x: offsets[3])
                        .opacity(step == 3 ? 1 : 0)
                    Intro5(optionSelected: $optionSelected[step])
                        .offset(x: offsets[4])
                        .opacity(step == 4 ? 1 : 0)
                }
//                .frame(height: (firstResponder ?? false) ? UIScreen.main.bounds.height / 3 : .infinity)
                .offset(y: (firstResponder ?? false) ? -UIScreen.main.bounds.height / 3.5 : 0)
                HStack (spacing: 5) {
                    Capsule()
                        .frame(width: (UIScreen.main.bounds.width - 50) / 35 * firstCapsule, height: 12)
                        .foregroundColor(Color("black")).opacity(0.1)
                    Capsule()
                        .frame(width: (UIScreen.main.bounds.width - 50) / 35 * secondCapsule, height: 12)
                        .foregroundColor(Color("blue"))
                    Capsule()
                        .frame(width: (UIScreen.main.bounds.width - 50) / 35 * thirdCapsule, height: 12)
                        .foregroundColor(Color("black")).opacity(0.1)
                }
                .padding(.top)
                .padding(.bottom, 5)
                .animation(.spring())
                .offset(y: (firstResponder ?? false) ? -UIScreen.main.bounds.height / 2.5 : 0)
                HStack {
                    Button (action: {
                        
                        if (step == 1) {
//                            self.firstResponder = true
                            self.secondCapsule -= 1
                            self.thirdCapsule += 1
                        }
                        else if (step == 2) {
                            self.secondCapsule += 1
                            self.thirdCapsule -= 1
                        }
                        
                        impact(style: .medium)
                        self.step -= 1
                        self.firstCapsule -= 2
                        self.thirdCapsule += 2
                        
                        self.back(i: step)
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.primary)
                            .font(.headline)
                            .padding(5)
                            .frame(width: 80, height: 40)
                    }.disabled(firstCapsule < 2)
                    .opacity(step == 0 ? 0 : 1)
                    Spacer()
                    Button(action: {
                        impact(style: .medium)
                        
                        if (step == 0) {
                            self.user.name = self.name
                            UserDefaults.standard.set(self.name, forKey: "userName")
                            self.hideKeyboard()
                            self.firstResponder = false
                            self.hideKeyboard()
                            self.secondCapsule += 1
                            self.thirdCapsule -= 1
                        } else if (step == 1) {
                            self.secondCapsule -= 1
                            self.thirdCapsule += 1
                        } else if (step == 3){
                            UserDefaults.standard.set(self.categories, forKey: "notCategory")
                        }
                        
                        if (step < 4) {
                            self.step += 1
                            self.firstCapsule += 2
                            self.thirdCapsule -= 2
                            
                            self.next(i: step)
                        } else if (step == 4) {
                            self.loading = true
                            self.postUserData()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                self.loadingAnimation = true
                            }
                        }
                    }) {
                        Image(systemName: step == 4 ? "checkmark" : "arrow.right")
                            .font(.headline)
                            .accentColor(Color(optionSelected[step] > 0 ? "white" :"white"))
                            .padding(5)
                            .frame(width: 80, height: 40)
                            .background(Color(optionSelected[step] > 0 ? "blue" : "blueDisabled"))
                            .cornerRadius(15)
                    }.disabled(optionSelected[step] < 1)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
                .offset(y: (firstResponder ?? false) ? -UIScreen.main.bounds.height / 2.5 : 0)
                Spacer()
            }
//            .offset(y: -keyboard.currentHeight)
            //                .padding(.bottom, keyboard.currentHeight)
            .blur(radius: loading ? 5 : 0)
            .scaleEffect(CGSize(width: launchScreen ? 0.7 : 0.95, height: launchScreen ? 0.7 : 0.95))
            .animation(.spring())
            .accentColor(.black)
            if (loading) {
                ZStack {
                    if (success) {
                        VStack {
                            LottieView(filename: "success", loop: false)
                                .frame(width: successScale ? 250 : 180, height: successScale ? 250 : 180)
                                .animation(.spring())
                        }
                        .onAppear(){
                            haptic(type: .success)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                self.successScale = true
                            }
                        }
                    }
                    if (!success) {
                        VStack {
                            LottieView(filename: "loadingCircle", loop: true)
                                .frame(width: 80, height: 80)
                                .background(Color("white"))
                                .cornerRadius(50)
                        }
                        .onAppear(){
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.success = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                self.animation = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    self.show = true
                                    UserDefaults.standard.set(show, forKey: "showTutorial")
                                    impact(style: .medium)
                                }
                            }
                        }
                    }
                }
                .frame(width: successScale ? 200 : 150, height: successScale ? 200 : 150)
                .background(Color("white"))
                .cornerRadius(50)
                .scaleEffect(loadingAnimation ? 1 : 0.5)
                .shadow(radius: 5)
                .animation(.spring())
            }
        }
    }
    
    func postUserData(){
        let patchData = UserNameAgeGen(name: name, age: age, gender: gender, hideInfo: hideInfo)
        print(patchData)
        
        guard let encoded = try? JSONEncoder().encode(patchData) else {
            print("Failed to encode order")
            return
        }
        
        guard let url = URL(string: myUrl.users + id) else { return }
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
    
    func next(i: Int) {
        self.offsets[i] = 0
        self.offsets[i-1] = -UIScreen.main.bounds.width
    }
    func back(i: Int) {
        self.offsets[i] = 0
        self.offsets[i+1] = UIScreen.main.bounds.width
    }
}

struct UserNameAgeGen: Encodable, Decodable {
    var name: String
    var age: String
    var gender: String
    var hideInfo: Bool
}

struct StartTutorialView_Previews: PreviewProvider {
    static var previews: some View {
        StartTutorialView(show: .constant(false), animation: .constant(false), filter: FilterData2(), launchScreen: .constant(true)).environmentObject(UserObserv()).environmentObject(ChangeFilter()).environmentObject(FilterString())
    }
}

struct Intro1: View {
    
    @Binding var name: String
    @Binding var nameLength: Int
    @Binding var firstResponder: Bool?
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @EnvironmentObject var user: UserObserv
    
    var screen = UIScreen.main.bounds
    
    var maxLength = 13
    
    var body: some View {
        
        let binding = Binding<String>(get: {
            self.name
        }, set: {
            self.user.name = String($0.prefix(maxLength))
            self.name = String($0.prefix(maxLength))
            UserDefaults.standard.set(String($0.prefix(maxLength)), forKey: "userName")
            nameLength = self.name.count
        })
        
        return VStack {
            Spacer()
            Image("ProfileImage")
                .resizable()
                .scaledToFit()
            Text("Hallo!")
                .font(.title)
                .padding(.vertical)
            Text("Gebe ein paar Daten zu deiner Person an, damit andere Nutzer dich Online erkennen können wenn du Fakten oder Tipps postest.")
                .frame(maxWidth: 612)
                .multilineTextAlignment(.center)
                .font(.footnote)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 40)
            Text("Gebe deinen Namen ein:")
                .multilineTextAlignment(.center)
                .font(.footnote)
            Section {
                
                ZStack{
                    MultilineTextView2(text: binding, isFirstResponder: $firstResponder, maxLength: maxLength)
                        .frame(height: 40)
                    
//                    TextField("", text: binding, onEditingChanged: { (editingchanged) in
//                        if (editingchanged) {
//                            self.firstResponder = true
//                        } else {
//                            self.firstResponder = false
//                        }
//
//                    } , onCommit: {
//                        user.name = user.name
//                        self.firstResponder = false
//                        UserDefaults.standard.set(user.name, forKey: "userName")
//
//                    })
//                    .lineLimit(1)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    VStack {
                        HStack {
                            Spacer()
                            Text("\(name.count)/\(maxLength)")
                                .padding(10)
                                .font(.system(size: screen.width < 500 ? screen.width * 0.03 : 12))
                                .opacity(0.5)
                        }
                    }.frame(height: 40)
                }
                .frame(maxWidth: UIScreen.main.bounds.width < 500 ? UIScreen.main.bounds.width - 30 : 450)
                .padding(.horizontal)
            }
            Spacer()
        }
        .padding(.horizontal)
        .onTapGesture(perform: {
            self.firstResponder = false
            self.hideKeyboard()
        })
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct Intro2 : View {
    
    @Binding var age: String
    @Binding var gender: String
    @Binding var hideInfo: Bool
    @Binding var optionSelected: Int
    @Binding var firstResponder: Bool?
    
    @State var ages: [String] = ["12-17", "18-25", "26-35", "36-50", "51-70", "71+"]
    @State var genders: [String] = ["Männlich", "Weiblich", "Divers"]
    @State var isSelected: [Bool] = [false, false, false, false, false, false]
    @State var isSelectedGender: [Bool] = [false, false, false]
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    var body: some View {
        
        VStack {
            Spacer()
            VStack {
                Image("Family")
                    .resizable()
                    .scaledToFit()
                    .frame(minHeight: 100, idealHeight: 300, maxHeight: 600)
                    .layoutPriority(1)
                Text("Gebe dein Geschlecht und Alter")
                    .font(.system(size: 20, weight: Font.Weight.medium))
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .padding()
                Text("Alter")
                    .font(.system(size: 16, weight: Font.Weight.medium))
            }
            .onTapGesture(perform: {
                self.firstResponder = false
                self.hideKeyboard()
            })
            if (keyboard.currentHeight < 10) {
                GeometryReader { bounds in
                    ScrollView (.horizontal, showsIndicators: false) {
                        HStack {
                            Spacer()
                            ForEach(ages.indices, id: \.self) { index in
                                Button(action: {
                                    self.age = ages[index]
                                    impact(style: .medium)
                                    for (i, _) in isSelected.enumerated() {
                                        isSelected[i] = false
                                    }
                                    self.isSelected[index] = true
                                    
                                    if (gender.count > 0) {
                                        self.optionSelected = 1
                                    }
                                }){
                                    Text(ages[index])
                                        .font(.system(size: 14))
                                        .padding()
                                        .foregroundColor(Color(isSelected[index] ? "white" : "black"))
                                        .background(Color(isSelected[index] ? "blue" : "background"))
                                        .cornerRadius(15)
                                }
                            }
                            Spacer()
                        }.frame(minWidth: bounds.size.width)
                    }
                }
                .frame(maxHeight: 50)
                .opacity(hideInfo ? 0.5 : 1)
            }
            Spacer()
                .frame(minHeight: 5, idealHeight: 15, maxHeight: 25)
            Text("Geschlecht")
                .font(.system(size: 16, weight: Font.Weight.medium))
            HStack {
                Spacer()
                ForEach(genders.indices, id: \.self) { index in
                    Button(action: {
                        self.gender = genders[index]
                        impact(style: .medium)
                        for (i, _) in isSelectedGender.enumerated() {
                            isSelectedGender[i] = false
                        }
                        self.isSelectedGender[index] = true
                        
                        if (age.count > 0) {
                            self.optionSelected = 1
                        }
                    }){
                        Text(genders[index])
                            .font(.system(size: 14))
                            .padding()
                            .foregroundColor(Color(isSelectedGender[index] ? "white" : "black"))
                            .background(Color(isSelectedGender[index] ? "blue" : "background"))
                            .cornerRadius(15)
                    }
                }
                Spacer()
            }
            .padding(.vertical, 10)
            .opacity(hideInfo ? 0.5 : 1)
            Spacer()
                .frame(minHeight: 5, idealHeight: 15, maxHeight: 25)
            Toggle("Diese Angaben Online verstecken", isOn: $hideInfo)
                .onReceive([self.hideInfo].publisher.first()) { (value) in
                    UserDefaults.standard.set(value, forKey: "hideInfo")
                }
                .font(.footnote)
                .padding()
                .frame(width: 300)
            Spacer()
        }
        .animation(.spring())
        .onTapGesture(perform: {
            self.hideKeyboard()
            self.firstResponder = false
        })
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct Intro3 : View {
    
    @State var difficulties: [String] = []
    @Binding var optionSelected: Int
    
    //    @EnvironmentObject var filter: FilterData2
    //    @ObservedObject var filter = FilterData2()
    @ObservedObject var filter: FilterData2
    
    var body: some View {
        
        VStack {
            Spacer()
            Image("Success")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 40)
            Text("Wähle Schwierigkeitsstufen ab für welche du keine Tipps bekommen möchtest")
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .font(.system(size: 20, weight: Font.Weight.medium))
                .padding()
            HStack (spacing: 15) {
                difficultyButton(filter: filter, difficulty: "Leicht", difficulties: $difficulties, optionSelected: $optionSelected, isSelected: true)
                difficultyButton(filter: filter, difficulty: "Mittel", difficulties: $difficulties, optionSelected: $optionSelected, isSelected: true)
                difficultyButton(filter: filter, difficulty: "Schwer", difficulties: $difficulties, optionSelected: $optionSelected, isSelected: true)
            }
            .padding(.bottom, 10)
            Spacer()
        }
        .animation(.spring())
        .onTapGesture(perform: {
            self.hideKeyboard()
        })
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct Intro4 : View {
    
    @ObservedObject var filter: FilterData2
    
    @Binding var categories: [String]
    @Binding var optionSelected: Int
    
    var body: some View {
        
        VStack {
            Spacer()
            Image("kategorie")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 40)
            Text("Wähle Kategorien ab, die dich nicht betreffen oder interessieren")
                .multilineTextAlignment(.center)
                .font(.system(size: 20, weight: Font.Weight.medium))
                .fixedSize(horizontal: false, vertical: true)
                .padding()
            ScrollView (.vertical, showsIndicators: false) {
                HStack (spacing: 15) {
                    categoryButton(filter: filter, category: "Ernährung", categories: $categories, isSelected: true, optionSelected: $optionSelected)
                    categoryButton(filter: filter, category: "Transport", categories: $categories, isSelected: true, optionSelected: $optionSelected)
                    categoryButton(filter: filter, category: "Haushalt", categories: $categories, isSelected: true, optionSelected: $optionSelected)
                }
                .padding(.bottom, 10)
                HStack {
                    categoryButton(filter: filter, category: "Ressourcen", categories: $categories, isSelected: true, optionSelected: $optionSelected)
                }
            }
        }
        .animation(.spring())
        .onTapGesture(perform: {
            self.hideKeyboard()
        })
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct Intro5 : View {
    
    @State private var appearenceDark = UserDefaults.standard.bool(forKey: "appearenceDark")
    @State var model = ToggleModel()
    @Binding var optionSelected: Int
    @State var isSelected: Bool = false
    
    var body: some View {
        
        VStack {
            Spacer()
            Text("Willst du die App lieber im Darkmode nutzen?")
                .multilineTextAlignment(.center)
                .font(.system(size: 20, weight: Font.Weight.medium))
                .fixedSize(horizontal: false, vertical: true)
                .padding()
            HStack {
                Button(action: {
                    self.model.isDark = false
                    self.appearenceDark = false
                    UserDefaults.standard.set(self.model.isDark, forKey: "appearenceDark")
                    impact(style: .medium)
                }){
                    VStack {
                        Image("screenLight")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(15)
                            .shadow(radius: 5)
                            .padding(.horizontal, 10)
                        Image(systemName: model.isDark ? "sun.max" : "sun.max.fill")
                            .padding()
                    }.opacity(model.isDark ? 0.5 : 1)
                }
                .foregroundColor(Color("black"))
                Button(action: {
                    self.model.isDark = true
                    self.appearenceDark = true
                    UserDefaults.standard.set(self.model.isDark, forKey: "appearenceDark")
                    impact(style: .medium)
                }){
                    VStack {
                        Image("screenDark")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(15)
                            .shadow(radius: 5)
                            .padding(.horizontal, 10)
                        Image(systemName: model.isDark ? "moon.fill" : "moon")
                            .padding()
                    }.opacity(model.isDark ? 1 : 0.5)
                }
                .foregroundColor(Color("black"))
            }
            .padding()
            Spacer()
        }
        .animation(.spring())
        .onTapGesture(perform: {
            self.hideKeyboard()
        })
        .onAppear(){
            if self.appearenceDark {
                self.model.isDark = true
            }else{
                self.model.isDark = false
            }
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct categoryButton: View {
    
    @EnvironmentObject var user: UserObserv
    @EnvironmentObject var changeFilter: ChangeFilter
    @EnvironmentObject var filterString: FilterString
    @ObservedObject var filter: FilterData2
    
    var category: String
    @Binding var categories: [String]
    @State var isSelected: Bool
    @Binding var optionSelected: Int
    
    var categoriesArray = ["Ernährung", "Transport", "Haushalt", "Ressourcen"]
    
    var body: some View {
        Button(action: {
            impact(style: .medium)
            
            if isSelected {
                self.filterString.filterString.removeAll(where: {$0 == category})
                
                if let i = self.filter.filter.firstIndex(where: { $0.name == category }) {
                    self.filter.filter[i].isSelected = false
                }
                self.isSelected = false
            } else {
                self.filterString.filterString.append(category)
                
                if let i = self.filter.filter.firstIndex(where: { $0.name == category }) {
                    self.filter.filter[i].isSelected = true
                }
                self.isSelected = true
            }
            if filterString.filterString.contains(where: categoriesArray.contains) {
                self.optionSelected = 1
            } else {
                self.optionSelected = -1
            }
            
            changeFilter.changeFilter = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                changeFilter.changeFilter = false
            }
        }){
            VStack {
                Image(category)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40)
                Text(category)
                    .font(.system(size: 14))
                    .padding(.horizontal)
                    .fixedSize()
            }
            .padding(.vertical, 5)
            .frame(width: 90, height: 80)
            .foregroundColor(Color(isSelected ? "white" : "black"))
            .background(Color(isSelected ? "blue" : "background"))
            .cornerRadius(15)
        }
        .onAppear(){
            if (filterString.filterString.contains(category)){
                self.isSelected = true
            } else {
                self.isSelected = false
            }
        }
    }
}

struct difficultyButton: View {
    
    @EnvironmentObject var user: UserObserv
    @EnvironmentObject var changeFilter: ChangeFilter
    @EnvironmentObject var filterString: FilterString
    @ObservedObject var filter: FilterData2
    
    var difficulty: String
    @Binding var difficulties: [String]
    @Binding var optionSelected: Int
    @State var isSelected: Bool
    
    var levelArray = ["Leicht", "Mittel", "Schwer"]
    
    var body: some View {
        Button(action: {
            impact(style: .medium)
            if isSelected {
                self.filterString.filterString.removeAll(where: {$0 == difficulty})
                
                if let i = self.filter.filter.firstIndex(where: { $0.name == difficulty }) {
                    self.filter.filter[i].isSelected = false
                }
                self.isSelected = false
            } else {
                self.filterString.filterString.append(difficulty)
                
                if let i = self.filter.filter.firstIndex(where: { $0.name == difficulty }) {
                    self.filter.filter[i].isSelected = true
                }
                self.isSelected = true
            }
            if filterString.filterString.contains(where: levelArray.contains) {
                self.optionSelected = 1
            } else {
                self.optionSelected = -1
            }
            
            changeFilter.changeFilter = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                changeFilter.changeFilter = false
            }
        }){
            VStack {
                Image(difficulty)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40)
                Text(difficulty)
                    .font(.system(size: 14))
                    .padding(.horizontal)
                    .fixedSize()
            }
            .padding(.vertical, 5)
            .frame(width: 90, height: 80)
            .foregroundColor(Color(isSelected ? "white" : "black"))
            .background(Color(isSelected ? "blue" : "background"))
            .cornerRadius(15)
        }
        .onAppear(){
            if (filterString.filterString.contains(difficulty)){
                self.isSelected = true
            } else {
                self.isSelected = false
            }
        }
    }
}

struct ProfilFilterView: View {
    
    @EnvironmentObject var user: UserObserv
    @EnvironmentObject var changeFilter: ChangeFilter
    @EnvironmentObject var filterString: FilterString
    @ObservedObject var filter: FilterData2
    
    var index: Int
    var category: String
    @Binding var categories: [String]
    @State var isSelected: Bool
    @Binding var optionSelected: Int
    
    var screen = UIScreen.main.bounds.width
    
    var categoriesArray = ["Ernährung", "Transport", "Haushalt", "Ressourcen"]
    
    var body: some View {
        Button(action: {
            impact(style: .medium)
            
            if isSelected {
                self.filterString.filterString.removeAll(where: {$0 == category})
                
                if let i = self.filter.filter.firstIndex(where: { $0.name == category }) {
                    self.filter.filter[i].isSelected = false
                }
                self.isSelected = false
            } else {
                self.filterString.filterString.append(category)
                
                if let i = self.filter.filter.firstIndex(where: { $0.name == category }) {
                    self.filter.filter[i].isSelected = true
                }
                self.isSelected = true
            }
            if filterString.filterString.contains(where: categoriesArray.contains) {
                self.optionSelected = 1
            } else {
                self.optionSelected = -1
            }
            
            changeFilter.changeFilter = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                changeFilter.changeFilter = false
            }
        }){
            HStack {
                HStack {
                    Image("\(filter.filter[index].icon)")
                        .resizable()
                        .scaledToFit()
                        .font(.title)
                        .frame(width: screen < 400 ? screen * 0.07 : 30, height: screen < 400 ? screen * 0.07 : 30)
                        .opacity(isSelected ? 1 : 0.3)
                    Text(filter.filter[index].name)
                        .font(.system(size: screen < 500 ? screen * 0.045 : 20))
                        .fontWeight(.medium)
                        .accentColor(Color("black"))
                        .opacity(isSelected ? 1 : 0.3)
                }.padding(.horizontal, 10)
                .padding(.vertical, 6)
            }
            .frame(width: screen < 400 ? screen / 2.3 : 170, height: screen < 400 ? screen * 0.12 : 70)
            .background(Color(isSelected ? "buttonWhite" : "transparent"))
            .cornerRadius(15)
            .shadow(color: isSelected ?Color("black").opacity(0.1) : Color("transparent"), radius: 5, x: 4, y: 4)
        }
        .onAppear(){
            if (filterString.filterString.contains(category)){
                self.isSelected = true
            } else {
                self.isSelected = false
            }
        }
    }
}
