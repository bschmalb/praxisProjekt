//
//  TippDataStore.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 07.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI
import Combine

class TippDataStore: ObservableObject {
    @Published var tipps: [Tipp] = []
    
    init() {
        fetchTipps()
    }
    
    func fetchTipps() {
        Api().fetchTipps() { (tipps) in
            self.tipps = tipps
        }
    }
}
