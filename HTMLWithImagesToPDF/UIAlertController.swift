//
//  UIAlertController.swift
//  HTMLWithImagesToPDF
//
//  Created by user on 12.08.17.
//  Copyright © 2017 nyg. All rights reserved.
//

import UIKit

extension UIAlertController {

    func addAction(title: String?, style: UIAlertActionStyle = .default, handler: ((UIAlertAction) -> Void)? = nil) {
        addAction(UIAlertAction(title: title, style: style, handler: handler))
    }
}
