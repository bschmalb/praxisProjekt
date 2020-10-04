//
//  AddTagebuchView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 25.09.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI


struct AddTagebuchView: View {
    
    @Binding var tabViewSelected: Int
    
    @State var id = UserDefaults.standard.string(forKey: "id")
    
    @EnvironmentObject var levelEnv: UserLevel
    @EnvironmentObject var myUrl: ApiUrl
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @State var isSuccess = false
    @State var isLoading = false
    @State var isError = false
    @State var posted = false
    
    @State var posting = true
    
    @State var loading: Bool = false
    @State var loadingAnimation: Bool = false
    @State var success: Bool = false
    @State var successScale: Bool = false
    
    @State var optionSelected: [Int] = [-1, -1, -1, -1, -1, -1, -1, -1]
    
    @State var offsets: [CGFloat] = [0, UIScreen.main.bounds.width, UIScreen.main.bounds.width, UIScreen.main.bounds.width, UIScreen.main.bounds.width, UIScreen.main.bounds.width, UIScreen.main.bounds.width, UIScreen.main.bounds.width]
    
    @State var tagebuch1titel = "Wie viele Kilometer bist du gestern mit dem Auto gefahren?"
    @State var tagebuch1image = "Kilometer"
    @State var tagebuch1einheit = "Kilometer"
    @State var tagebuch1options = ["0", "1-10", "11-20", "21-50", "51+"]
    
    @State var tagebuch2titel = "Wie oft hast du gestern Fleisch gegessen?"
    @State var tagebuch2image = "IErnährung"
    @State var tagebuch2einheit = "Mal"
    @State var tagebuch2options = ["0", "1", "2", "3", "4+"]
    
    @State var tagebuch3titel = "Wie viele Mahlzeiten hast du gestern gekauft?"
    @State var tagebuch3image = "Woman Cooking"
    @State var tagebuch3einheit = "Mal"
    @State var tagebuch3options = ["0", "1", "2", "3", "4+"]
    
    @State var tagebuch4titel = "Bei wie vielen Malzeiten hast du Reste weggeschmissen?"
    @State var tagebuch4image = "IRecycling"
    @State var tagebuch4einheit = "Mal"
    @State var tagebuch4options = ["0", "1", "2", "3", "4+"]
    
    @State var tagebuch5titel = "Wie viel Liter gekaufte Getränke hast du gestern getrunken?"
    @State var tagebuch5image = "Person drinking tea-2"
    @State var tagebuch5einheit = "Mal"
    @State var tagebuch5options = ["0", "1", "2", "3", "4+"]
    
    @State var tagebuch6titel = "Wie lange hast du gestern geduscht?"
    @State var tagebuch6image = "Person in the summer"
    @State var tagebuch6einheit = "Minuten"
    @State var tagebuch6options = ["0", "5", "10", "15", "20+"]
    
    @State var tagebuch7titel = "Hast du gestern auf die Mülltrennung geachtet?"
    @State var tagebuch7image = "People Shopping"
    @State var tagebuch7einheit = ""
    @State var tagebuch7options = ["Ja", "Teilweise", "Nein"]
    
    @State var step = 1
    
    @State var selection: Int? = 0
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
//                    NavigationLink(destination: AddTagebuchSuccess(tabViewSelected: $tabViewSelected), tag: 1, selection: $selection) {
//                        EmptyView()
//                    }
                    VStack {
                        HStack {
                            Spacer()
                            Text("\(step)/7").bold().padding(20).foregroundColor(Color.secondary)
                        }
                        Spacer()
                    }
                    AddTagebuch1(optionsSelected: $optionSelected[0], titel: tagebuch1titel, image: tagebuch1image, einheit: tagebuch1einheit, options: tagebuch1options)
                        .offset(x: offsets[0])
                        .opacity(step == 1 ? 1 : 0)
                    AddTagebuch1(optionsSelected: $optionSelected[1], titel: tagebuch2titel, image: tagebuch2image, einheit: tagebuch2einheit, options: tagebuch2options)
                        .offset(x: offsets[1])
                        .opacity(step == 2 ? 1 : 0)
                    AddTagebuch1(optionsSelected: $optionSelected[2], titel: tagebuch3titel, image: tagebuch3image, einheit: tagebuch3einheit, options: tagebuch3options)
                        .offset(x: offsets[2])
                        .opacity(step == 3 ? 1 : 0)
                    AddTagebuch1(optionsSelected: $optionSelected[3], titel: tagebuch4titel, image: tagebuch4image, einheit: tagebuch4einheit, options: tagebuch4options)
                        .offset(x: offsets[3])
                        .opacity(step == 4 ? 1 : 0)
                    AddTagebuch1(optionsSelected: $optionSelected[4], titel: tagebuch5titel, image: tagebuch5image, einheit: tagebuch5einheit, options: tagebuch5options)
                        .offset(x: offsets[4])
                        .opacity(step == 5 ? 1 : 0)
                    AddTagebuch1(optionsSelected: $optionSelected[5], titel: tagebuch6titel, image: tagebuch6image, einheit: tagebuch6einheit, options: tagebuch6options)
                        .offset(x: offsets[5])
                        .opacity(step == 6 ? 1 : 0)
                    AddTagebuch1(optionsSelected: $optionSelected[6], titel: tagebuch7titel, image: tagebuch7image, einheit: tagebuch7einheit, options: tagebuch7options)
                        .offset(x: offsets[6])
                        .opacity(step == 7 ? 1 : 0)
                    AddTagebuchSuccess(tabViewSelected: $tabViewSelected)
                        .offset(x: offsets[7])
                        .opacity(step == 8 ? 1 : 0)
                }
                if (posting) {
                HStack {
                    Button (action: {
                        if (step != 4) {
                            self.hideKeyboard()
                        }
                        
                        self.step -= 1
                        
                        self.back(i: self.step-1)
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.headline)
                            .padding(5)
                            .frame(width: 80, height: 40)
                    }.opacity(step > 1 ? 1 : 0)
                    Spacer()
                    Button(action: {
                        if (step < 7){
                            impact(style: .medium)
                            
                            if (step != 3) {
                                self.hideKeyboard()
                            }
                            
                            self.step += 1
                            
                            self.next(i: self.step-1)
                        }
                        else {
                            self.posted = true
                            self.isLoading = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                self.loadingAnimation = true
                            }
                            self.postLog()
                        }
                    }) {
                        if (step < 7) {
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
                .padding(20)
                }
            }
            .blur(radius: step == 7 && isLoading ? 4 : 0)
            .animation(.spring())
            if (isLoading) {
                ZStack {
                    if (isSuccess) {
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
                    if (!isSuccess) {
                        VStack {
                            LottieView(filename: "loadingCircle", loop: true)
                                .frame(width: 80, height: 80)
                                .background(Color("white"))
                                .cornerRadius(50)
                        }
                        .onAppear(){
                            print(successScale)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.isSuccess = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                self.step += 1
                                
                                self.next(i: self.step-1)
                                
                                self.posting = false
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                self.isLoading = false
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
                .offset(x: offsets[6])
            }
        }.accentColor(Color("black"))
        .animation(.spring())
    }
    
    func postLog(){
        let today = Date()
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        let date = formatter1.string(from: today)
        
        UserDefaults.standard.set(date, forKey: "logDate")
        
        let logData = LogAdd(log: Log(kilometer: optionSelected[0], meat: optionSelected[1], cooked: optionSelected[2], foodWaste: optionSelected[3], drinks: optionSelected[4], shower: optionSelected[5], binWaste: optionSelected[6], date: date))
        
        guard let encoded = try? JSONEncoder().encode(logData) else {
            print("Failed to encode order")
            return
        }
        guard let url = URL(string: myUrl.users + (id ?? "")) else { return }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PATCH"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard data != nil else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            UserDefaults.standard.set(date, forKey: "logDate")
            haptic(type: .success)
            self.levelEnv.level += 70
            UserDefaults.standard.set(self.levelEnv.level, forKey: "userLevel")
        }.resume()
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

struct AddTagebuch1: View {
    
    var screenWidth = UIScreen.main.bounds.width
    
    @Binding var optionsSelected: Int
    var titel: String
    var image: String
    var einheit: String
    var options: [String]
    
    var body: some View {
        VStack (spacing: screenWidth < 350 ? 10 : 20) {
            Image(image)
                .resizable()
                .scaledToFit()
                .shadow(radius: 2)
                .frame(minHeight: 80, idealHeight: 200, maxHeight: 300)
            Text(titel)
                .font(.system(size: screenWidth < 500 ? screenWidth * 0.055 : 24, weight: .medium))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
            
            HStack (spacing: screenWidth < 350 ? 15 : 35) {
                
                Button(action: {
                    impact(style: .medium)
                    self.optionsSelected = 0
                    
                }) {
                    TagebuchButton(name: options[0], einheit: einheit, selected: optionsSelected, selectedAmount: 0)
                }
                Button(action: {
                    impact(style: .medium)
                    self.optionsSelected = 1
                }) {
                    TagebuchButton(name: options[1], einheit: einheit, selected: optionsSelected, selectedAmount: 1)
                }
                Button(action: {
                    impact(style: .medium)
                    self.optionsSelected = 2
                }) {
                    TagebuchButton(name: options[2], einheit: einheit, selected: optionsSelected, selectedAmount: 2)
                }
            }.padding(.bottom, 10)
            if (options.count == 5) {
                HStack (spacing: screenWidth < 350 ? 15 : 35) {
                    Button(action: {
                        impact(style: .medium)
                        self.optionsSelected = 3
                    }) {
                        TagebuchButton(name: options[3], einheit: einheit, selected: optionsSelected, selectedAmount: 3)
                    }
                    Button(action: {
                        impact(style: .medium)
                        self.optionsSelected = 4
                    }) {
                        TagebuchButton(name: options[4], einheit: einheit, selected: optionsSelected, selectedAmount: 4)
                    }
                }
            }
        }
        .accentColor(Color("black"))
    }
}

//struct AddTagebuchView: View {
//    @Environment(\.presentationMode) private var presentationMode
//
//    @State var selection: Int? = 0
//
//    @Binding var tabViewSelected: Int
//
//    @State var kilometer: Int = -1
//
//    var screenWidth = UIScreen.main.bounds.width
//
//    var body: some View {
//
//        NavigationView {
//            ZStack {
//                Color("background")
//                    .edgesIgnoringSafeArea(.all)
//                VStack {
//                    HStack {
//                        Spacer()
//                        Text("1/7").bold().padding(20).foregroundColor(Color.secondary)
//                    }
//                    Spacer()
//                }
//                VStack (spacing: 20){
//                    Image("Kilometer")
//                        .resizable()
//                        .scaledToFit()
//                        .shadow(radius: 2)
//                        .frame(minHeight: 100, idealHeight: 200, maxHeight: 300)
//                    Text("Wie viele Kilometer bist du gestern mit dem Auto gefahren?")
//                        .font(.system(size: screenWidth < 500 ? screenWidth * 0.06 : 26, weight: .medium))
//                        .fontWeight(.medium)
//                        .multilineTextAlignment(.center)
//                        .padding()
//
//                    HStack (spacing: 20) {
//
//                        Button(action: {
//                            impact(style: .medium)
//                            self.kilometer = 0
//
//                        }) {
//                            TagebuchButton(name: "0", einheit: "Kilometer", selected: kilometer, selectedAmount: 0)
//                        }
//                        Button(action: {
//                            impact(style: .medium)
//                            self.kilometer = 1
//                        }) {
//                            TagebuchButton(name: "1-10", einheit: "Kilometer", selected: kilometer, selectedAmount: 1)
//                        }
//                        Button(action: {
//                            impact(style: .medium)
//                            self.kilometer = 2
//                        }) {
//                            TagebuchButton(name: "11-20", einheit: "Kilometer", selected: kilometer, selectedAmount: 2)
//                        }
//                    }.padding(.bottom, 10)
//                    HStack (spacing: 30) {
//                        Button(action: {
//                            impact(style: .medium)
//                            self.kilometer = 3
//                        }) {
//                            TagebuchButton(name: "21-50", einheit: "Kilometer", selected: kilometer, selectedAmount: 3)
//                        }
//                        Button(action: {
//                            impact(style: .medium)
//                            self.kilometer = 4
//                        }) {
//                            TagebuchButton(name: "50+", einheit: "Kilometer", selected: kilometer, selectedAmount: 4)
//                        }
//                    }
//                    HStack {
//                        NavigationLink (destination: ContentView().navigationBarBackButtonHidden(true)
//                                            .navigationBarTitle("")
//                                            .navigationBarHidden(true)){
//                            Image(systemName: "arrow.right")
//                                .font(.headline)
//                                .accentColor(Color(kilometer > -1 ? "white" :"white"))
//                                .padding(5)
//                                .frame(width: 80, height: 40)
//                                .background(Color(kilometer > -1 ? "blue" : "blueDisabled"))
//                                .cornerRadius(15)
//                        }.opacity(0)
//                        Spacer()
//                        NavigationLink (destination: AddTagebuchCard2(tabViewSelected: $tabViewSelected, kilometer: kilometer).navigationBarBackButtonHidden(true)
//                                            .navigationBarTitle("")
//                                            .navigationBarHidden(true)){
//                            Text("Überspringen")
//                                .font(.system(size: screenWidth < 500 ? screenWidth * 0.035 : 14, weight: .light))
//                                .foregroundColor(.secondary)
//                        }
//                        Spacer()
//                        NavigationLink (destination: AddTagebuchCard2(tabViewSelected: $tabViewSelected, kilometer: kilometer).navigationBarBackButtonHidden(true)
//                                            .navigationBarTitle("")
//                                            .navigationBarHidden(true)
//                                        , tag: 1, selection: $selection) {
//                            Button(action: {
//                                impact(style: .medium)
//                                self.selection = 1
//                            }) {
//                                Image(systemName: "arrow.right")
//                                    .font(.headline)
//                                    .accentColor(Color(kilometer > -1 ? "white" :"white"))
//                                    .padding(5)
//                                    .frame(width: 80, height: 40)
//                                    .background(Color(kilometer > -1 ? "blue" : "blueDisabled"))
//                                    .cornerRadius(15)
//                            }
//                                        }.disabled(kilometer == -1)
//                    }
//                    .padding(20)
//                }
//                .navigationBarTitle("")
//                .navigationBarHidden(true)
//                .accentColor(Color("black"))
//            }
//        }.navigationViewStyle(StackNavigationViewStyle())
//    }
//}

struct TagebuchButton: View {
    
    
    var name: String
    var einheit: String
    var selected: Int
    var selectedAmount: Int
    
    var screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        VStack (spacing: 7){
            Text(name)
                .font(.system(size: screenWidth < 500 ? screenWidth * 0.045 : 18, weight: .medium))
                .foregroundColor(Color(self.selected == selectedAmount ? "white" : "black"))
            if einheit.count > 0 {
                Text(einheit)
                    .font(.system(size: screenWidth < 500 ? screenWidth * 0.03 : 14))
                    .fixedSize()
                    .foregroundColor(Color(self.selected == selectedAmount ? "white" : "black"))
                    .multilineTextAlignment(.center)
                    .frame(minWidth: 35)
            }
        }
        .padding(8)
        .padding(.horizontal, 5)
        .background(Color(selected == selectedAmount ? "blue" : "transparent"))
        .cornerRadius(15)
    }
}

struct AddTagebuchView_Previews: PreviewProvider {
    static var previews: some View {
        AddTagebuchView(tabViewSelected: .constant(3))
    }
}
