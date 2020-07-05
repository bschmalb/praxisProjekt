//
//  ProfilFilter.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 29.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct ProfilFilter: View {
    
    @State var filter = filterData
    
    @State var isSelected = true
    
    var body: some View {
        VStack{
            ScrollView(.vertical, showsIndicators: false) {
                VStack (alignment: .leading, spacing: 10) {
                    Text("Filter:")
                        .font(.title)
                    ForEach(filter.indices, id: \.self) { index in
                        HStack (spacing: 10){
                            Toggle("", isOn: self.$isSelected)
                                .frame(width: 100, height: 30)
                            Image(self.filter[index].icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 30, alignment: .center)
                            Text(self.filter[index].name)
                            
//                            FilterView(isSelected: self.$filter[index].isSelected, filter: self.filter[index])
//                                .onTapGesture {
//                                    self.filter[index].isSelected.toggle()
////                                    self.filterTipps(filterName: self.filter[index].name)
//                                    impact(style: .heavy)
//                                }
                        }
                    }
                }
                .padding(.vertical, UIScreen.main.bounds.height / 81)
            }.accentColor(Color("black"))
        }
    }
}

struct ProfilFilter_Previews: PreviewProvider {
    static var previews: some View {
        ProfilFilter()
    }
}
