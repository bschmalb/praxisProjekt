//
//  AddTagebuchSuccess.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 02.07.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct AddTagebuchSuccess: View {
    
    @Binding var tabViewSelected: Int
    
    @State var selection: Int? = 0
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Image("PersonSofa")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 35)
                    .shadow(radius: 2)
                Text("Du hast deinen Tagebucheintrag heute schon verfasst.\nSchaue hier morgen wieder vorbei!")
                    .foregroundColor(Color("black").opacity(0.9))
                    .padding(.horizontal, 20)
            }
            .padding(.vertical, 20)
            Spacer()
            NavigationLink (destination: TagebuchEntwicklung()
                .navigationBarBackButtonHidden(false)
                .navigationBarTitle("")
                .navigationBarHidden(true)
            , tag: 1, selection: $selection) {
                Button(action: {
                    impact(style: .rigid)
                    self.selection = 1
                }) {
                    HStack (spacing: 15){
                        Image(systemName: "arrow.up.right")
                            .font(.headline)
                            .accentColor(Color("white"))
                        Text("Zu deiner Entwicklung")
                            .font(.headline)
                            .accentColor(Color("white"))
                    }
                    .padding(20)
                    .frame(width: UIScreen.main.bounds.width - 70, height: 50)
                    .background(Color("blue"))
                    .cornerRadius(15)
                }
            }
                //            Button(action: {
                //                impact(style: .medium)
                //                self.tabViewSelected = 3
                //            })
                //            {
                //                HStack (spacing: 15){
                //                    Image(systemName: "arrow.up.right")
                //                        .font(.headline)
                //                        .accentColor(Color("white"))
                //                    Text("Zu deiner Entwicklung")
//                        .font(.headline)
//                        .accentColor(Color("white"))
//                }
//                .padding(20)
//                .frame(width: UIScreen.main.bounds.width - 70, height: 50)
//                .background(Color("blue"))
//                .cornerRadius(15)
//            }
            Spacer()
        }
        .background(Color("background"))
    }
}

struct AddTagebuchSuccess_Previews: PreviewProvider {
    static var previews: some View {
        AddTagebuchSuccess(tabViewSelected: .constant(4))
    }
}
