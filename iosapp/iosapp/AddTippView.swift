//
//  AddTippView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 05.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct AddTipp: Codable, Hashable, Identifiable {
    let id: UUID
    let category: String
    let difficulty: String
    var name: String
    var quelle: String
}

struct AddTippView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                Text("Tipp posten")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.leading, 20)
                
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle")
                        .font(.title)
                        .padding(10)
                        .padding(.trailing, 15)
                }
            }
            .padding(.top, 30)
            AddTippCards()
            Spacer()
        }.accentColor(Color("black"))
    }
}

struct AddTippView_Previews: PreviewProvider {
    static var previews: some View {
        AddTippView()
    }
}
