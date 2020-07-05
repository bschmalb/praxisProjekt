//
//  TippDataStore.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 07.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI
import Combine

class ChallengeDataStore: ObservableObject {
    @Published var challenges: [Challenge] = []
    
    init() {
        fetchChallenges()
    }
    
    func fetchChallenges() {
        ChallengeApi().fetchChallenges() { (challenges) in
            self.challenges = challenges
        }
    }
}
