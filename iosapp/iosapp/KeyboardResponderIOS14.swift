//
//  KeyboardResponderIOS14.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 29.09.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI
import Combine
import UIKit

final class KeyboardResponderIOS14: ObservableObject {
    
    @Published var keyboardHeight: CGFloat = 0
    private(set) var subscriptions = Set<AnyCancellable>()
    
    init() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .compactMap { notification in
                (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.keyboardHeight, on: self)
            .store(in: &subscriptions)
    }
}
