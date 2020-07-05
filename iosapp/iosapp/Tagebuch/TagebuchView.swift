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
    
//    @State var tbSelected = false
    @Binding var tabViewSelected: Int
    
    
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
                            AddTagebuchCard1(tabViewSelected: $tabViewSelected)
                        }
//                        HStack (spacing: 40) {
//                            Button(action: {
//                                self.tbSelected = true
//
//                                impact(style: .soft)
//                            }){
//                                Text("Tagebuch")
//                                    .font(.headline)
//                                    .foregroundColor(tbSelected ? Color("black") : .secondary)
//                                    .multilineTextAlignment(.center)
//                                    .frame(width: 150)
//                            }
//                            Button(action: {
//                                self.tbSelected = false
//
//                                impact(style: .soft)
//                            }){
//                                Text("Deine Entwicklung")
//                                    .font(.headline)
//                                    .foregroundColor(tbSelected ? .secondary : Color("black"))
//                                    .multilineTextAlignment(.center)
//                                    .frame(width: 150)
//                            }
//                        }.padding(.top)
//                        Capsule()
//                            .fill(Color("black"))
//                            .frame(width: tbSelected ? 80 : 150, height: 2)
//                            .offset(x: tbSelected ? -95 : 94, y: -8)
//                        ZStack {
//                            AddTagebuchCard1()
//                                .offset(x: tbSelected ? 0 : -UIScreen.main.bounds.width)
//                                .gesture(DragGesture()
//                                    .onEnded({ (value) in
//                                        self.tbSelected.toggle()
//                                    }))
//                                .animation(.spring())
//                            EntwicklungTabView()
//                                .offset(x: tbSelected ? UIScreen.main.bounds.width : 0)
//                                .gesture(DragGesture()
//                                    .onEnded({ (value) in
//                                        self.tbSelected.toggle()
//                                    }))
//                        }
                    }
                    
                    Spacer()
                }
                .animation(.spring())
                .navigationBarTitle("")
                .navigationBarHidden(true)
            }
        }
    }
}

struct TagebuchView_Previews: PreviewProvider {
    static var previews: some View {
        TagebuchView(tabViewSelected: .constant(2))
    }
}
