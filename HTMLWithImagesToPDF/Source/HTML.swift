//
//  HTML.swift
//  HTMLWithImagesToPDF
//
//  Created by user on 20.09.17.
//  Copyright © 2017 nyg. All rights reserved.
//

import UIKit

class HTML {

    /**
     Reads the given HTML file and replaces `{{ABSOLUTE_PATH}}` and `{{BASE64_STRING}}` with proper values.

     - parameters:
       - fileName: The name of the HTML file.

     - returns: The transformed HTML code.
     */
    class func get(from fileName: String) -> String {

        guard let htmlFile = Bundle.main.url(forResource: fileName, withExtension: nil)
            else { fatalError("Error locating HTML file.") }

        guard let htmlContent = try? String(contentsOf: htmlFile)
            else { fatalError("Error getting HTML file content.") }

        guard let imageURL = Bundle.main.url(forResource: "apple", withExtension: "png")
            else { fatalError("Error locating image file.") }

        // create base64-encoded string of the "apple" image (located in Assets.xcassets)
        guard let base64String = UIImagePNGRepresentation(#imageLiteral(resourceName: "apple"))?.base64EncodedString()
            else { fatalError("Error creating PNG representation.") }

        return htmlContent
            .replacingOccurrences(of: "{{ABSOLUTE_PATH}}", with: imageURL.description)
            .replacingOccurrences(of: "{{BASE64_STRING}}", with: base64String)
    }
}
