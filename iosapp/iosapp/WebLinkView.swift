//
//  WebLinkView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 09.09.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import Foundation
import SwiftUI
import WebKit

struct WebLinkView: UIViewRepresentable {
    
    var url: String
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: self.url) else {
            return WKWebView()
        }
        
        let request = URLRequest(url: url)
        let wkWebView = WKWebView()
        wkWebView.load(request)
        return wkWebView
    }
    
    func updateUIView(_ uiView: WebLinkView.UIViewType, context: UIViewRepresentableContext<WebLinkView>) {
        
    }
}

struct WebLinkView_Previews: PreviewProvider {
    static var previews: some View {
        WebLinkView(url: "www.google.com")
    }
}
