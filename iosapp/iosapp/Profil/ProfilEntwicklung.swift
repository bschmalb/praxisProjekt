//
//  ProfilEntwicklung.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 28.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct ProfilEntwicklung: View {
    
    @State var id = UserDefaults.standard.string(forKey: "id")
    
    @EnvironmentObject var myUrl: ApiUrl
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State var loading2: Bool = true
    
    @Binding var tabViewSelected: Int
    var screenWidth = UIScreen.main.bounds.width
    
    let paddingBot = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    
    @State var user: User = User(_id: "", phoneId: "", checkedTipps: [], savedTipps: [], savedFacts: [], log: [])
    
    var body: some View {
        ZStack {
            Color("background")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if (user.log.count < 1) {
                    VStack {
                        Button(action: {
                            self.mode.wrappedValue.dismiss()
                            impact(style: .medium)
                        }) {
                            HStack (spacing: 10){
                                Image(systemName: "arrow.left")
                                    .font(.system(size: screenWidth < 500 ? screenWidth * 0.040 : 18, weight: .medium))
                                    .foregroundColor(Color("black"))
                                Text("Deine Entwicklung")
                                    .font(.system(size: screenWidth < 500 ? screenWidth * 0.040 : 18, weight: .medium))
                                    .foregroundColor(Color("black"))
                                Spacer()
                            }
                            .padding(.leading, 20)
                            .padding(.vertical, 10)
                        }
                        Spacer()
                        Image("Research")
                            .resizable()
                            .scaledToFit()
                        Text("Um dein Entwicklung zu sehen musst du erst Tagebucheinträge erstellen. Dafür musst du nur ein paar Fragen beantworten. :)")
                            .font(.system(size: 15))
                            .lineSpacing(3)
                            .multilineTextAlignment(.center)
                            .padding()
                        if #available(iOS 14.0, *) {
                            Button(action: {
                                impact(style: .medium)
                                tabViewSelected = 2
                            }){
                                Text("Zu deinem Tagebuch")
                                    .font(.headline)
                                    .accentColor(Color("white"))
                                    .padding(20)
                                    .frame(width: UIScreen.main.bounds.width - 90, height: 50)
                                    .background(Color("blue"))
                                    .cornerRadius(15)
                            }
                            Spacer()
                        } else {
                            Spacer()
                            HStack {
                                Spacer()
                                Spacer()
                                VStack {
                                    Text("Zu deinem\nTagebuch")
                                        .font(.system(size: 14))
                                        .padding()
                                        .multilineTextAlignment(.center)
                                        .fixedSize(horizontal: false, vertical: true)
                                    Image(systemName: "arrow.down")
                                        .font(.system(size: 24, weight: Font.Weight.medium))
                                }
                                Spacer()
                            }
                            .padding(.bottom, 30 + paddingBot)
                        }
                    }
                    .opacity(loading2 ? 0.01 : 1)
                } else {
                    ScrollView (.vertical) {
                        
                        Button(action: {
                            self.mode.wrappedValue.dismiss()
                            impact(style: .medium)
                        }) {
                            HStack (spacing: 10){
                                Image(systemName: "arrow.left")
                                    .font(.system(size: screenWidth < 500 ? screenWidth * 0.040 : 18, weight: .medium))
                                    .foregroundColor(Color("black"))
                                Text("Deine Entwicklung")
                                    .font(.system(size: screenWidth < 500 ? screenWidth * 0.040 : 18, weight: .medium))
                                    .foregroundColor(Color("black"))
                                Spacer()
                            }
                            .padding(.leading, 20)
                            .padding(.vertical, 10)
                        }
                        VStack (spacing: 30) {
                            EntwicklungGraphView(user: user, graphColor: "cardgreen2", graphTitle: "Gefahrene Kilometer", graphCategory: 0)
                            EntwicklungGraphView(user: user, graphColor: "cardblue2", graphTitle: "Fleischkonsum", graphCategory: 1)
                            EntwicklungGraphView(user: user, graphColor: "cardgreen2", graphTitle: "Essen gekauft", graphCategory: 2)
                            EntwicklungGraphView(user: user, graphColor: "cardpurple2", graphTitle: "Essen weggeschmissen", graphCategory: 3)
                            EntwicklungGraphView(user: user, graphColor: "cardyellow2", graphTitle: "Getränke gekauft", graphCategory: 4)
                            EntwicklungGraphView(user: user, graphColor: "cardturqouise2", graphTitle: "Duschzeit", graphCategory: 5)
                            EntwicklungGraphView(user: user, graphColor: "cardred2", graphTitle: "Mülltrennung", graphCategory: 6)
                                .padding(.bottom, 15)
                        }
                        .padding(.leading, 10)
                        .opacity(loading2 ? 0.01 : 1)
                    }
                }
            }
            VStack {
                if (loading2) {
                    VStack{
                        LottieView(filename: "loadingCircle", loop: true)
                            .frame(width: 50, height: 50)
                    }
                }
            }
        }
        .gesture(DragGesture()
                    .onChanged({ (value) in
                        if value.translation.width > 40 {
                            self.mode.wrappedValue.dismiss()
                        }
                    }))
        .onAppear {
            getUser()
        }
    }
    
    func getUser() {
        guard let url = URL(string: myUrl.users + (id ?? "")) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            if let data = data {
                if let user = try? JSONDecoder().decode(User.self, from: data) {
                    DispatchQueue.main.async {
                        self.user = user
                        self.loading2 = false
                    }
                    return
                }
            }
        }
        .resume()
    }
}

struct ProfilEntwicklung_Previews: PreviewProvider {
    static var previews: some View {
        ProfilEntwicklung(tabViewSelected: .constant(3)).environmentObject(ApiUrl())
    }
}
