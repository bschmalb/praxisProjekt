//
//  UserDataStore.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 28.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI
import Combine

class UserDataStore: ObservableObject {
    @Published var user: User = User(id: "1", name: "Basti", checkedTipps: [], savedTipps: [], checkedChallenges: [], savedChallenges: [])
    
    init() {
        fetchUser()
    }
    
    func fetchUser() {
        UserApi().fetchUser() { (user) in
            self.user = user
        }
    }
}
