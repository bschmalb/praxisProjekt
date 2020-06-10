//
//  RateTippView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 09.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct RateTippView: View {
    
    @ObservedObject var store = TippDataStore()

    @State private var showAddTipps2 = false
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var counter = 0
    
    var body: some View {
        VStack {
            HStack {
                Button (action: {
                    self.mode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left.circle")
                        .accentColor(.primary)
                        .font(.title)
                        .padding(10)
                        .padding(.leading, 15)
                }
                Spacer()
                Text("Tipps bewerten")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    self.showAddTipps2.toggle()
                }) {
                    Image(systemName: "plus.circle")
                        .accentColor(.primary)
                        .font(.title)
                        .padding(10)
                        .padding(.trailing, 15)
                }.sheet(isPresented: $showAddTipps2, content: { AddTippView()})
            }
            .padding(.top, 20.0)
            
            HStack {
                Text("Wenn ein Tipp von der Community gutes Feedback bekommt, wird dieser für alle Nutzer angezeigt")
            }.padding()
            
            TippCard
            
            HStack {
                Button(action: {
                    
                }) {
                    Text("Daumen Hoch")
                }
            }
            
            
            Spacer()
        }
    }
}

struct RateTippView_Previews: PreviewProvider {
    static var previews: some View {
        RateTippView()
    }
}
