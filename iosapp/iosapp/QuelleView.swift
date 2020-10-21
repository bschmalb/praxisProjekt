//
//  QuelleView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 15.09.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI
import MobileCoreServices

struct QuelleView: View {
    
    var quelle: String
    
    var quelle2: URL = URL(string: "https://www.ecosia.org")!
    
    @Binding var quelleShowing: Bool
    
    var body: some View {
        
        let url = URL(string: quelle)
        let domain = url?.host
        
        return VStack (spacing: 0){
            HStack {
                Button(action: {
                    impact(style: .medium)
                    UIPasteboard.general.setValue(quelle, forPasteboardType: kUTTypePlainText as String)
                }) {
                    Image(systemName: "doc.on.doc")
                        .font(.system(size: 14))
                        .padding()
                }
                Spacer()
                Text(domain ?? quelle)
                    .font(.system(size: 12))
                Spacer()
                Button(action: {
                    self.quelleShowing = false
                }){
                    Image(systemName: "xmark")
                    .padding()
                }
                .accentColor(.primary)
            }
            .background(Color.secondary.opacity(0.1))
            
            Webview(url: URL(string: quelle) ?? quelle2)
                .edgesIgnoringSafeArea(.all)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct QuelleView_Previews: PreviewProvider {
    static var previews: some View {
        QuelleView(quelle: "http://www.duschbrocken.de", quelleShowing: .constant(true))
    }
}
