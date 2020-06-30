//
//  AllTippDataStore.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 29.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI
import Combine

class AllTippDataStore: ObservableObject {
    @Published var allTipps: [Tipp] = []
    
    init() {
        fetchAllTipps()
    }
    
    func fetchAllTipps() {
        AllApi().fetchAllTipps() { (allTipps) in
            self.allTipps = allTipps
        }
    }
}
