//
//  LevelView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 17.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct LevelView: View {
    
    var color1 = Color("blue")
    var color2 = Color(.blue).opacity(0.7)
    var frameWidth: CGFloat = 80
    var frameHeight: CGFloat = 80
    var percent: CGFloat = 88
    
    var body: some View {
        let multiplier = frameWidth / 70
        let progress = 1 - percent / 100
        
        return ZStack {
            Circle()
                .stroke(Color(.black).opacity(0.1), style: StrokeStyle(lineWidth: 6 * multiplier))
                .frame(width: frameWidth, height: frameHeight)
            
            Circle()
                .trim(from: progress, to: 1)
                .stroke(
                    LinearGradient(gradient: Gradient(colors: [color1, color2]), startPoint: .topTrailing, endPoint: .bottomLeading),
                    style: StrokeStyle(lineWidth: 8 * multiplier, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [20, 0], dashPhase: 0
                    )
            )
            .rotationEffect(Angle(degrees: 90))
            .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
            .frame(width: frameWidth, height: frameHeight)
                .shadow(color: Color("blue").opacity(0.1), radius: 3 * multiplier, x: 0, y: 3 * multiplier)
            VStack (spacing: -5 * multiplier){
                Text("Level")
                    .font(.system(size: 12 * multiplier))
                    .foregroundColor(Color("black"))
                Text("12")
                .font(.system(size: 28 * multiplier))
                .bold()
                .foregroundColor(Color("black"))
            }.offset(y: 2 * multiplier)
        }
    }
}

struct LevelView_Previews: PreviewProvider {
    static var previews: some View {
        LevelView()
    }
}
