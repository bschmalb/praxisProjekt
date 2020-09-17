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
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.quelleShowing = false
                }){
                    Text("Fertig")
                    .padding()
                }
            }
            .accentColor(.primary)
            .background(Color.secondary.opacity(0.2))
            WebLinkView(url: quelle)
        }
    }
}

struct QuelleView_Previews: PreviewProvider {
    static var previews: some View {
        QuelleView(quelle: "", quelleShowing: .constant(true))
    }
}
