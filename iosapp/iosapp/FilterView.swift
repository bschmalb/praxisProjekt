//
//  FilterView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 03.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct FilterView: View {
    
    @State var filter = filterData
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack (spacing: 20) {
                Text("Filter:")
                    .font(.system(size: 20, weight: .medium))
                    .padding(.leading, 20)
                ForEach(filter.indices){index in
                    Button(action: {
                        self.filter[index].isSelected.toggle()
                    }) {
                        HStack {
                            Image("\(self.filter[index].icon)")
                            .resizable()
                            .scaledToFit()
                            .font(.title)
                            .frame(width: 30, height: 30)
                            Text(self.filter[index].name)
                                .font(.headline)
                                .fontWeight(.medium)
                                .accentColor(Color("black"))
                        }.padding(.horizontal, 10)
                            .padding(.vertical, 6)
                    }
                    .background(Color(self.filter[index].isSelected ? "buttonWhite" : "background"))
                    .cornerRadius(15)
                    .shadow(color: self.filter[index].isSelected ? Color(.black).opacity(0.2) : Color("transparent"), radius: 4, x: 4, y: 2)
                }
            }
            .padding(.vertical, 10)
        }.accentColor(Color("black"))
    }
}

struct Filter: Codable, Hashable, Identifiable {
    let id: UUID
    let icon: String
    let name: String
    var isSelected: Bool
}

var filterData: [Filter] = [
    .init(id: UUID(), icon: "blackFruits", name: "Nahrung", isSelected: true),
    .init(id: UUID(), icon: "blackTransport", name: "Transport", isSelected: true),
    .init(id: UUID(), icon: "blackRecycle", name: "Recycling", isSelected: true),
    .init(id: UUID(), icon: "blackArrow", name: "Anfänger", isSelected: true),
    .init(id: UUID(), icon: "blackArrow", name: "Fortgeschritten", isSelected: true),
    .init(id: UUID(), icon: "blackArrow", name: "Experte", isSelected: true),
    .init(id: UUID(), icon: "blackVerified", name: "Offiziell", isSelected: true),
    .init(id: UUID(), icon: "blackCommunity", name: "Community", isSelected: true)
]

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView()
    }
}
