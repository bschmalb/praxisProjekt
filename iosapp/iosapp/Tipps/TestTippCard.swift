//
//  TippCard2.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 14.09.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct TestTippCard: View {
    
    @State var id = UserDefaults.standard.string(forKey: "id")
    
    @State var user: User
    
    @Binding var isChecked: Bool
    @Binding var isBookmarked: Bool
    @State var isClicked: Bool = false
    @State var isClicked2: Bool = false
    @State var tipp: Tipp
    
    @State var user2: User = User(_id: "", phoneId: "", level: 2, checkedTipps: [], savedTipps: [], savedFacts: [], log: [])
    
    @State var userLevelLocal = 0
    
    @State var quelleShowing = false
    @State var showSourceTextView = false
    
    @State var options: Bool = false
    
    @State var reportClicked: Bool = false
    @State var likeClicked: Bool = false
    @State var dislikeClicked: Bool = false
    
    @State var correctUrl: String = ""
    
    @State var showYouSure: Bool = false
    
    var color: String
    
    var body: some View {
        
        ZStack {
            if (options) {
                GeometryReader { size in
                    VStack (spacing: 0){
                        HStack(alignment: .top) {
                            Spacer()
                            Button(action: {
                                impact(style: .medium)
                                self.options.toggle()
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: size.size.width < 500 ? size.size.width * 0.06 : 25, weight: Font.Weight.medium))
                                    .opacity(0.1)
                                    .padding(.top, 25)
                                    .padding(.trailing, 25)
                            }
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            VStack (spacing: 0){
                                Group {
                                    Spacer()
                                    Text("Geposted von:")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                        .multilineTextAlignment(.center)
                                    if user2.name != nil {
                                        Text("\(user2.name ?? "User")")
                                            .multilineTextAlignment(.center)
                                            .padding(5)
                                        Text("\(user2.gender ?? "")  \(user2.age ?? "")")
                                            .font(.footnote)
                                            .multilineTextAlignment(.center)
                                            .opacity(user2.hideInfo ?? false ? 0 : 1)
                                    } else {
                                        VStack {
                                            LottieView(filename: "loadingCircle", loop: true)
                                                .shadow(color: Color(.white), radius: 1, x: 0, y: 0)
                                                .frame(width: 30, height: 30)
                                        }.padding(10)
                                    }
                                    Spacer()
                                }.foregroundColor(Color("alwaysblack"))
                                    Group {
                                        HStack (spacing: 15){
                                            Image(systemName: likeClicked ? "hand.thumbsup.fill" : "hand.thumbsup")
                                                .font(.system(size: size.size.width < 500 ? size.size.width * 0.05 : 22, weight: Font.Weight.medium))
                                                .opacity(0.8)
                                            Text("Positiv bewerten")
                                                .font(.system(size: size.size.width < 500 ? size.size.width * 0.05 : 20))
                                                .opacity(0.8)
                                        }
                                        .padding(10)
                                        .onTapGesture(){
                                            impact(style: .medium)
                                            self.likeClicked.toggle()
                                        }
                                        .onTapGesture(){}
                                        .gesture(DragGesture()
                                                    .onChanged({ (value) in
                                                        self.options = false
                                                    }))
                                        Spacer()
                                            .frame(maxHeight: 5)
                                        HStack (spacing: 20){
                                            Image(systemName: dislikeClicked ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                                                .font(.system(size: size.size.width < 500 ? size.size.width * 0.05 : 22, weight: Font.Weight.medium))
                                                .opacity(0.8)
                                            Text("Negativ bewerten")
                                                .font(.system(size: size.size.width < 500 ? size.size.width * 0.05 : 20))
                                                .opacity(0.8)
                                        }
                                        .padding(10)
                                        .onTapGesture(){
                                            impact(style: .medium)
                                            self.likeClicked = false
                                            self.dislikeClicked.toggle()
                                        }
                                        Spacer()
                                            .frame(maxHeight: 5)
                                        HStack (spacing: 20){
                                            Image(systemName: reportClicked ? "flag.fill" : "flag")
                                                .font(.system(size: size.size.width < 500 ? size.size.width * 0.05 : 22, weight: Font.Weight.medium))
                                                .foregroundColor(.red)
                                                .opacity(0.8)
                                            Text("Diesen Tipp melden")
                                                .font(.system(size: size.size.width < 500 ? size.size.width * 0.05 : 20))
                                                .foregroundColor(.red)
                                                .opacity(0.8)
                                        }
                                        .padding(10)
                                        .animation(.spring())
                                        .onTapGesture(){
                                            impact(style: .medium)
                                            self.reportClicked.toggle()
                                        }
                                        Spacer()
                                    }.foregroundColor(Color("alwaysblack"))
//                                }
                            }
                            .frame(width: size.size.width / 1.3)
                            .gesture(DragGesture()
                                        .onChanged({ (value) in
                                            self.options = false
                                        }))
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width > 600 ? 600 - 30 : UIScreen.main.bounds.width - 30, height:
                            UIScreen.main.bounds.height / 2.1)
                    .background(Color.black.opacity(0.05))
                    .background(Color(color))
                    .cornerRadius(15)
                    .onTapGesture(){}
                    .gesture(DragGesture()
                                .onChanged({ (value) in
                                    self.options = false
                                }))
                    .animation(.spring())
                }
            }
            GeometryReader { size in
                ZStack {
                    VStack{
                        Spacer()
                        Image("I"+tipp.category)
                            .resizable()
                            .scaledToFit()
                            .frame(minHeight: 40, idealHeight: 200, maxHeight: 300)
                            .drawingGroup()
                        Text(tipp.title)
                            .font(.system(size: size.size.width < 500 ? size.size.width * 0.07  - CGFloat(tipp.title.count / 25) : 26, weight: .medium))
                            .fixedSize(horizontal: false, vertical: showSourceTextView ? false : true)
                            .foregroundColor(Color("alwaysblack"))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        if (showSourceTextView){
                            SourceTextView(source: tipp.source, show: $showSourceTextView, color: color)
                        } else {
                            if (tipp.source.count > 3) {
                                HStack (spacing: 5){
                                    Text("Quelle")
                                        .foregroundColor(.gray)
                                        .font(.system(size: size.size.width * 0.03, weight: .medium))
                                        .multilineTextAlignment(.center)
                                        .padding(.top, 5)
                                }
                                .onTapGesture {
                                    impact(style: .medium)
                                    }
                                    .sheet(isPresented: $quelleShowing) {
                                        QuelleView(quelle: tipp.source, quelleShowing: self.$quelleShowing)
                                            .environmentObject(ApiUrl())
                                    }
                            }
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: isChecked ? "checkmark" : "plus")
                                .font(Font.system(size: size.size.width < 500 ? size.size.width * 0.07 : 25, weight: isChecked ? .medium : .regular))
                                .foregroundColor(Color(isChecked ? .white : .black))
                                .rotationEffect(Angle(degrees: isChecked ? 0 : 180))
                                .scaleEffect(isClicked ? 2 : 1)
                                .animation(.spring())
                                .padding()
                                .onTapGesture(){
                                    self.isChecked.toggle()
                                    self.isClicked = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        self.isClicked = false
                                    }
                                    impact(style: .medium)
                                }
                            Spacer()
                            Spacer()
                            Image(systemName: "bookmark")
                                .font(Font.system(size: size.size.width < 500 ? size.size.width * 0.07 : 25, weight: isBookmarked ? .medium : .regular))
                                .foregroundColor(Color(isBookmarked ? .white : .black))
                                .scaleEffect(isClicked2 ? 2 : 1)
                                .animation(.spring())
                                .padding()
                                .onTapGesture(){
                                    self.isBookmarked.toggle()
                                    self.isClicked2 = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        self.isClicked2 = false
                                    }
                                    impact(style: .medium)
                                }
                            Spacer()
                        }
                        Spacer()
                            .frame(maxHeight: 10)
                        
                    }
                    VStack {
                        HStack(alignment: .top, spacing: 10) {
                            HStack {
                                Image(tipp.category)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: size.size.width < 500 ? size.size.width * 0.097 : 40, height: size.size.width < 500 ? size.size.width * 0.07 : 40)
                                    .opacity(0.1)
                                    .padding(.leading, 20)
                                    .padding(.vertical)
                                Image(tipp.level)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: size.size.width < 500 ? size.size.width * 0.07 : 40, height: size.size.width < 500 ? size.size.width * 0.07 : 40)
                                    .opacity(0.1)
                                    .padding(.vertical)
                                Image(tipp.official)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: size.size.width < 500 ? size.size.width * 0.07 : 40, height: size.size.width < 500 ? size.size.width * 0.07 : 40)
                                    .opacity(0.1)
                                    .padding(.vertical)
                            }
                            Spacer()
                            Image(systemName: "ellipsis")
                                .font(.system(size: size.size.width < 400 ? size.size.width * 0.07 : 25, weight: Font.Weight.medium))
                                .padding(25)
                                .padding(.trailing, 5)
                                .background(Color(color))
                                .opacity(0.1)
                                .onTapGesture(){
                                    impact(style: .heavy)
                                    self.options.toggle()
                                }
                        }.foregroundColor(Color("alwaysblack"))
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width > 600 ? 600 - 30 : UIScreen.main.bounds.width - 30, height:
                            UIScreen.main.bounds.height / 2.1)
                }
                .background(Color(color))
                .cornerRadius(15)
                .offset(x: options ? -size.size.width / 1.3 : 0)
            }
            .onTapGesture(){
                options = false
            }
            .gesture(DragGesture()
                        .onChanged({ (value) in
                            if options {
                                self.options = false
                            }
                        }))
        }
        .animation(.spring())
        .accentColor(.black)
        .frame(width: UIScreen.main.bounds.width > 600 ? 600 - 30 : UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height/2.1)
    }
}

struct TestTippCard_Previews: PreviewProvider {
    static var previews: some View {
        TippCard2(user: User(_id: "", phoneId: "", checkedTipps: [], savedTipps: [], savedFacts: [], log: []), tipp: .init(_id: "123", title: "Saisonale und Regionale Produkte sind umweltfreundlicher als Bio-Produkte", source: "www.google.com", level: "Leicht", category: "Ernährung", score: 25, postedBy: "123", official: "Community"), color: "cardblue2")
    }
}
