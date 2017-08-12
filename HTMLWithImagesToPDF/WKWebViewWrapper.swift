//
//  WKWebViewWrapper.swift
//  HTMLWithImagesToPDF
//
//  Created by user on 12.08.17.
//  Copyright © 2017 nyg. All rights reserved.
//

import WebKit

// WKWebView not yet available in Interface Builder
class WKWebViewWrapper: WKWebView {

    required convenience init?(coder: NSCoder) {
        self.init(frame: .zero, configuration: WKWebViewConfiguration())
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
