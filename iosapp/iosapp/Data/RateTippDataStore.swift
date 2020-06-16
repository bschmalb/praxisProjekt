//
//  RateTippDataStore.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 15.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI
import Combine

class RateTippDataStore: ObservableObject {
    @Published var rateTipps: [Tipp] = []
    
    init() {
        fetchRateTipps()
    }
    
    func fetchRateTipps() {
        RateApi().fetchRateTipps() { (rateTipps) in
            self.rateTipps = rateTipps
        }
    }
}
