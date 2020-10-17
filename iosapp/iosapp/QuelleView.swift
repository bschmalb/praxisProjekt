//
//  QuelleView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 15.09.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct QuelleView: View {
    
    var quelle: String
    
    @Binding var quelleShowing: Bool
    
    var body: some View {
        VStack (spacing: 0){
            HStack {
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
            
            WebLinkView(url: quelle)
                .edgesIgnoringSafeArea(.all)
        }.edgesIgnoringSafeArea(.all)
    }
}

struct QuelleView_Previews: PreviewProvider {
    static var previews: some View {
        QuelleView(quelle: "http://www.duschbrocken.de", quelleShowing: .constant(true))
    }
}
