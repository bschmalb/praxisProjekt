//
//  TagebuchView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 03.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct TagebuchView: View {
    
    @State var tbSelected = true
    
    var body: some View {
        NavigationView {
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
                    .padding(.top, 20.0)
                    
                    VStack {
                        HStack (spacing: 40) {
                            Button(action: {
                                self.tbSelected = true
                            }){
                                Text("Tagebuch")
                                    .font(.headline)
                                    .foregroundColor(Color(tbSelected ? "blue" : "black"))
                                    .multilineTextAlignment(.center)
                                    .frame(width: 150)
                            }
                            Button(action: {
                                self.tbSelected = false
                            }){
                                Text("Deine Entwicklung")
                                    .font(.headline)
                                    .foregroundColor(Color(tbSelected ? "black" : "blue"))
                                    .multilineTextAlignment(.center)
                                    .frame(width: 150)
                            }
                        }.padding(.top)
                        Capsule()
                            .fill(Color("blue"))
                            .frame(width: tbSelected ? 80 : 150, height: 2)
                            .offset(x: tbSelected ? -95 : 94, y: -8)
                        ZStack {
                            AddTagebuchCard1()
                                .offset(x: tbSelected ? 0 : -UIScreen.main.bounds.width)
                                .gesture(DragGesture()
                                    .onEnded({ (value) in
                                        self.tbSelected.toggle()
                                    }))
                                .animation(.spring())
                            EntwicklungTabView()
                                .offset(x: tbSelected ? UIScreen.main.bounds.width : 0)
                                .gesture(DragGesture()
                                    .onEnded({ (value) in
                                        self.tbSelected.toggle()
                                    }))
                        }
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
        TagebuchView()
    }
}
