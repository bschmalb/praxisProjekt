//
//  ProfilSpende.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 19.10.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct ProfilSpende: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        ZStack {
            Color("background")
                .edgesIgnoringSafeArea(.all)
            VStack {
                Button(action: {
                    self.mode.wrappedValue.dismiss()
                    impact(style: .medium)
                }) {
                    HStack (spacing: 10){
                        Image(systemName: "arrow.left")
                            .font(.system(size: screenWidth < 500 ? screenWidth * 0.040 : 18, weight: .medium))
                            .foregroundColor(Color("black"))
                        Text("Einstellungen")
                            .font(.system(size: screenWidth < 500 ? screenWidth * 0.040 : 18, weight: .medium))
                            .foregroundColor(Color("black"))
                        Spacer()
                    }
                    .padding(.leading, 20)
                    .padding(.vertical, 10)
                }
                Spacer()
                VStack (spacing: 10) {
                    Image("Pay")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 50)
                        .padding(.vertical, 20)
                    Text("Da die App kostenlos zur Verfügung gestellt und betrieben wird, sind wir auf Spenden angewiesen.")
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 14))
                    Text("Wir freuen uns über jede Unterstützung. 😊")
                        .padding(.bottom)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 14))
                    HStack (spacing: 5){
                        Image("Paypal")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Text("Auf Paypal spenden")
                            .font(.system(size: UIScreen.main.bounds.width < 500 ? UIScreen.main.bounds.width * 0.045 : 20))
                            .fontWeight(.medium)
                    }
                    .padding(8)
                    .padding(.horizontal, 8)
                    .foregroundColor(.white)
                    .background(Color("blue"))
                    .cornerRadius(15)
                    .onTapGesture(perform: {
                        UIApplication.shared.open(URL(string: "https://paypal.me/sustainableapp")!)
                    })
                }
                Spacer()
            }
        }
        .gesture(DragGesture()
                    .onChanged(){ value in
                        if value.translation.width > 30 {
                            self.mode.wrappedValue.dismiss()
                        }
                    })
    }
}

struct ProfilSpende_Previews: PreviewProvider {
    static var previews: some View {
        ProfilSpende()
    }
}
