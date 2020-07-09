//
//  SuccessView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 15.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct SuccessView: View {
    @State var show = false
    
    var body: some View {
        ZStack {
            VStack {
                LottieView(filename: "success", loop: false)
                    .frame(width: 300, height: 300)
                    .offset(y: -30 )
                    .opacity(self.show ? 1 : 0)
                    .animation(Animation.linear(duration: 1).delay(0.2))
            }
            VStack {
                Text("Dein Tipp wurde erfolgreich erstellt")
                    .font(.system(size: 24))
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal ,10)
                    .opacity(self.show ? 1 : 0)
                    .animation(Animation.linear(duration: 1).delay(0.1))
                Text("Tipps die von der Community gepostet werden, müssen erst von der Community bewertet werden. Erst dann werden diese allen Nutzer angezeigt.")
                    .multilineTextAlignment(.center)
                    .padding(10)
                    .padding(.top, 150)
                    .opacity(self.show ? 1 : 0)
                    .animation(Animation.linear(duration: 1).delay(0.4))
            }
        }
        .frame(width: 300, height: 400)
        .padding(10)
        .background(Color("white"))
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: Color.black.opacity(0.2), radius: 30, x: 0, y: 30)
        .scaleEffect(self.show ? 1 : 0.5)
        .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
        .onAppear{
            self.show = true
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(show ? 0.5 : 0))
        .animation(.linear(duration: 0.5))
        .edgesIgnoringSafeArea(.all)
    }
}

struct SuccessView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessView()
    }
}
