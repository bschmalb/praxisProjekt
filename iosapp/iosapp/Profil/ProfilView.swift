//
//  ProfilView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 03.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct ProfilView: View {
    
    var body: some View {
        NavigationView {
            ZStack {
                ZStack {
                    Color("background")
                        .edgesIgnoringSafeArea(.all)
                }
                
                VStack {
                    HStack {
                        Spacer()
                        LevelView(frameWidth: 60, frameHeight: 60)
                            .padding(30)
                            .offset(y: -5)
                    }
                    Spacer()
                }.zIndex(1)
                
                VStack {
                    HStack {
                        VStack (alignment: .leading){
                            Text("Hallo Basti")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.leading, 20)
                                .padding(.bottom, 5)
                            Text("Wilkommen in deinem Profil")
                                .font(.callout)
                                .padding(.leading, 20)
                        }
                        Spacer()
                    }
                    .padding(.top, 10.0)
                    .offset(y: 10)
                    
                    ProfilHomeView()
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                }
                .animation(.spring())
                .navigationBarTitle("")
                .navigationBarHidden(true)
            }
        }
    }
}

struct ProfilView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilView()
    }
}
