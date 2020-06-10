//
//  TippCardsCustom.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 06.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct TippCardsCustom: View {

    @State var data = [
        Card(id: 0, name: "Tipp 1", quelle: "google", show: false),
        Card(id: 1, name: "Tipp 2", quelle: "google", show: false),
        Card(id: 2, name: "Tipp 3", quelle: "google", show: false),
        Card(id: 3, name: "Tipp 4", quelle: "google", show: false)
    ]
    
    
    @State var x : CGFloat = 0
    @State var count : CGFloat = 0
    @State var screen = UIScreen.main.bounds.width - 30
    @State var op : CGFloat = 0

    
    @State var tipps: [Tipp] = []
    
    var body: some View {
        HStack (spacing: 10){
            ForEach(data) { i in
                CardView(data: i)
                    .offset(x: self.x)
                    .highPriorityGesture(DragGesture()
                        .onChanged( { (value) in
                            if value.translation.width > 0 {
                                self.x = value.location.x
                            }
                            else {
                                self.x = value.location.x - self.screen
                            }
                            
                        })
                        .onEnded({ (value) in
                            if value.translation.width > 0 {

                                if value.translation.width > ((self.screen - 80)/2) && Int(self.count) != self.getMid(){
                                    self.count += 1
                                    self.updateHeight(value: Int(self.count))
                                    self.x = (self.screen + 10) * self.count
                                }
                                else {
                                    self.x = (self.screen + 10) * self.count
                                }
                            }
                            else {
                                if -value.translation.width > ((self.screen - 80)/2) && Int(self.count) != self.getMid(){
                                    self.count -= 1
                                    self.updateHeight(value: Int(self.count))
                                    self.x = (self.screen + 10) * self.count
                                }
                                else {
                                    self.x = (self.screen + 10) * self.count
                                }
                            }
                        })
                )
            }
        }
        .offset(x: self.op)
        .animation(.spring())
        .onAppear {
            self.op = ((self.screen + 15) * CGFloat(self.data.count / 2)) - (self.data.count % 2 == 0 ? ((self.screen + 15) / 2) : 0)
            self.data[0].show = true
//            Api().fetchTipps { (tipps) in
//                self.tipps = tipps
//            }
//            self.tipps[self.getMid()].show = true
        }
    }
    
    func getMid()->Int{
        return data.count / 2
    }
    func updateHeight(value: Int) {
        var id : Int
        if value < 0 {
            id = -value + getMid()
        }
        else {
            id = getMid() - value
        }

        for i in 0..<tipps.count {
            data[i].show = false
        }
        data[id].show = true
    }
}

struct Card : Identifiable {
    var id: Int
    var name: String
    var quelle: String
    var show: Bool
}

struct TippCardsCustom_Previews: PreviewProvider {
    static var previews: some View {
        TippCardsCustom()
    }
}

struct CardView : View {
    var data : Card
    var body: some View {
        VStack {
            Text(data.name).font(.title)
                .padding()
            Text(data.quelle).font(.headline)
            .padding()
        }.frame(width: UIScreen.main.bounds.width - 40, height: 400)
            .background(Color(.lightGray))
        .cornerRadius(15)
    }
}


struct Card2: View {
    var body: some View {
        VStack{
            Spacer()
            Image(uiImage: #imageLiteral(resourceName: "Navigating"))
                .resizable()
                .scaledToFit()
            Text("Benutze waschbare Gemüsenetzte anstatt Plastiktüten")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button(action: {
                // What to perform
            }) {
                Text("Quelle")
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding(5)
            }
            Spacer()
            HStack {
                Spacer()
                
                Button(action: {
                    
                }) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 25))
                        .foregroundColor(Color("black"))
                        .padding(30)
                        .padding(.trailing, 20)
                    
                }
                Spacer()
                Button(action: {
                    
                }) {
                    Image(systemName: "bookmark")
                        .font(.system(size: 25))
                        .foregroundColor(Color("black"))
                        .padding(30)
                        .padding(.leading, 20)
                }
                Spacer()
            }
        }
        .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height / 2.1)
        .background(Color("cardgreen"))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}
