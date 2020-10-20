//
//  SourceTextView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 15.10.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI
import MobileCoreServices

struct SourceTextView: View {
    
    @State var copied: Bool = false
    
    @State var source: String
    @Binding var show: Bool
    var color: String
    
    var body: some View {
        ZStack {
            VStack (alignment: .leading, spacing: 10){
                HStack {
                    Text("Quelle")
                        .fontWeight(.medium)
                        .foregroundColor(Color("alwaysblack"))
                    Spacer()
                    Image(systemName: "xmark")
                        .foregroundColor(.black).opacity(0.2)
                        .padding(10)
                        .onTapGesture(){
                            self.show = false
                        }
                }
                HStack {
                    Text(source)
                        .font(.system(size: UIScreen.main.bounds.width < 500 ? UIScreen.main.bounds.width * 0.04 : 18))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .onTapGesture(count: 2) {
                            UIPasteboard.general.setValue(source,
                                                          forPasteboardType: kUTTypePlainText as String)}
                    Spacer()
                    Button(action: {
                        impact(style: .medium)
                        self.copied = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.copied = false
                        }
                        UIPasteboard.general.setValue(source, forPasteboardType: kUTTypePlainText as String)
                    }) {
                        Image(systemName: "doc.on.doc")
                            .font(.system(size: 14))
                            .foregroundColor(Color("blue"))
                            .padding(8)
                            .padding(.horizontal, 2)
                            .background(Color(color))
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0.0, y: 0.0)
                    }
                }
            }
            .padding(.leading, 10)
            .padding()
            .background(Color.black.opacity(0.05))
            .background(Color(color))
            .cornerRadius(25)
            .padding()
            if(copied){
                Text("Kopiert")
                    .foregroundColor(.black)
                    .font(.system(size: 14, weight: .medium))
                    .padding(8)
                    .background(Color.black.opacity(0.05))
                    .background(Color(color))
                    .cornerRadius(10)
                    .shadow(radius: 3)
            }
        }
        
//        ZStack {
//                VStack{
//                    Spacer()
//                    Image("I" + tipp.category)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(minHeight: 100, idealHeight: 200, maxHeight: 300)
//                        .padding(20)
//                    Text(tipp.title)
//                        .font(.system(size: UIScreen.main.bounds.width < 500 ? UIScreen.main.bounds.width * 0.07 : 26, weight: .medium))
//                        .foregroundColor(.black)
//                        .multilineTextAlignment(.center)
//                        .padding()
//                    Spacer()
//                }
//                .background(Color(color))
//                .cornerRadius(15)
//                .shadow(color: Color(.black).opacity(0.1), radius: 10, x: 8, y: 6)
//        }.padding(20)
//                .padding(.vertical, 10)
        }
}

struct SourceTextView_Previews: PreviewProvider {
    static var previews: some View {
        SourceTextView(source: "", show: .constant(true), color: "cardgreen2")
    }
}
