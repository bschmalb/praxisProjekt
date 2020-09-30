//
//  TagebuchView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 03.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct TagebuchView: View {
    
    static let taskDateFormat: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            return formatter
        }()
    
    @Binding var tabViewSelected: Int
    @State var show: Bool = false
    @EnvironmentObject var overlayLog: OverlayLog
    
    @State var firstUseLog = UserDefaults.standard.bool(forKey: "firstUseLog")
    @State private var logDate = UserDefaults.standard.string(forKey: "logDate")
    
    var body: some View {
        let today = Date()
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        let dateToday = formatter1.string(from: today)
        
        return NavigationView {
            ZStack {
                ZStack {
                    Color("background")
                        .edgesIgnoringSafeArea(.all)
                }
                
                VStack {
                    HStack {
                        Text("Dein Tagebuch")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.leading, 20)
                                .padding(.bottom, 5)
                        Spacer()
                    }
                    .padding(.top, 30.0)
                    
                    VStack {
                        if (dateToday == logDate) {
                            AddTagebuchSuccess(tabViewSelected: $tabViewSelected)
                        } else {
//                            AddTagebuchCard1(tabViewSelected: $tabViewSelected)
                            AddTagebuchView(tabViewSelected: $tabViewSelected)
                        }
                    }.blur(radius: overlayLog.overlayLog ? 2 : 0)
                    
                    Spacer()
                }
                if (!firstUseLog) {
                    VStack (spacing: 10) {
                        Image("Team")
                            .resizable()
                            .scaledToFit()
                        Text("Trage täglich deinen Fortschritt ein um diesen nachher in deiner Entwicklung anzusehen. Dadurch behältst du den Überblick wie nachhaltig du lebst.")
                            .font(.subheadline)
                        .lineSpacing(4)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 15)
                        Button(action: {
                            withAnimation {
                                self.show = false
                                self.overlayLog.overlayLog = false
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                                UserDefaults.standard.set(true, forKey: "firstUseLog")
                            })
                        }) {
                            Text("Dann los!")
                                .font(.headline)
                                .accentColor(Color("white"))
                                .padding(20)
                                .frame(width: UIScreen.main.bounds.width - 90, height: 50)
                                .background(Color("blue"))
                                .cornerRadius(15)
                        }
                    }
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 60)
                    .background(Color("white"))
                    .cornerRadius(20)
                    .shadow(radius: 20)
                    .opacity(show ? 1 : 0)
                    .scaleEffect(show ? 1 : 0.5)
                    .onTapGesture {
                        withAnimation {
                            self.show = false
                            self.overlayLog.overlayLog = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                            UserDefaults.standard.set(true, forKey: "firstUseLog")
                        })
                    }
                    .animation(.spring())
                }
            }
            .animation(.spring())
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .onAppear(){
                if (!self.firstUseLog) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        self.show = true
                        self.overlayLog.overlayLog = true
                    })
                }
            }
            .onTapGesture {
                if (!self.firstUseLog) {
                withAnimation {
                    self.show = false
                    self.overlayLog.overlayLog = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    UserDefaults.standard.set(true, forKey: "firstUseLog")
                })
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct TagebuchView_Previews: PreviewProvider {
    static var previews: some View {
        TagebuchView(tabViewSelected: .constant(2))
    }
}
