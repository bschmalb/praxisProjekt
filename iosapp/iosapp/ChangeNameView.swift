//
//  ChangeNameView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 28.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct ChangeNameView: View {
    
    @State var name: String = ""
    @State var show: Bool = false
    @Binding var changeName: Bool
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.00001)
                .onTapGesture {
                    show = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        changeName = false
                    }
                }
            
            VStack {
                HStack {
                    TextField("Gib deinen Namen ein", text: $name)
                        .padding(.leading, 50)
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: 50)
                    Button(action: {
                        show = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            changeName = false
                        }
                    })
                    {
                        Image(systemName: "xmark.circle")
                        .offset(y: -20)
                        .font(.system(size: 20))
                        .foregroundColor(.secondary)
                        .padding(15)
                        .padding(.trailing, 30)
                    }
                }
                .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .frame(width: UIScreen.main.bounds.width * 0.9)
                Button(action: {
                    show = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        changeName = false
                    }
                })
                {
                    Text("Ändern")
                        .font(.body)
                        .foregroundColor(Color("white")).bold()
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .background(Color("blue"))
                        .cornerRadius(15)
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 5)
            .background(Color("white"))
            .cornerRadius(15)
            .shadow(radius: 10)
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color: Color.black.opacity(0.2), radius: 30, x: 0, y: 30)
            .scaleEffect(self.show ? 1 : 0.5)
            .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
            .onAppear{
                self.show = true
            }
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(show ? 0 : 0))
        .opacity(show ? 1 : 0)
        .animation(.linear(duration: 0.3))
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func patchName() {
        
    }
}

struct ChangeNameView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeNameView(changeName: .constant(true))
    }
}
