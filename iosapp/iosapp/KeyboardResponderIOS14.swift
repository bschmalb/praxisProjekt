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
    
    @Published private(set) var keyboardHeight: CGFloat = 0
    
    private var cancellable: AnyCancellable?
    
    private let keyboardWillShow = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillShowNotification)
        .compactMap { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height }
    
    private let keyboardWillHide = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillShowNotification)
        .map { _ in CGFloat.zero }
    
    init() {
        cancellable = Publishers.Merge(keyboardWillShow, keyboardWillHide)
            .subscribe(on: DispatchQueue.main)
            .assign(to: \.self.keyboardHeight, on: self)
    }
}
