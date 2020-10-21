//
//  LottieTest.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 21.10.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct LottieTest: View {
    var body: some View {
        VStack {
            LottieView(filename: "errorCircle", loop: true)
                .frame(width: 200, height: 200)
        }
    }
}

struct LottieTest_Previews: PreviewProvider {
    static var previews: some View {
        LottieTest()
    }
}
