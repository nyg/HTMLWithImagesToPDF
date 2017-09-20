//
//  PDF.swift
//  HTMLWithImagesToPDF
//
//  Created by user on 20.09.17.
//  Copyright © 2017 nyg. All rights reserved.
//

import UIKit

class PDF {

    /**
     Generates a PDF using the given print formatter and saves it to the user's document directory.

     - parameters:
       - printFormatter: The print formatter used to generate the PDF.

     - returns: The generated PDF.
    */
    class func generate(using printFormatter: UIPrintFormatter) -> Data {

        // assign the print formatter to the print page renderer
        let renderer = UIPrintPageRenderer()
        renderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)

        // assign paperRect and printableRect values
        let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
        renderer.setValue(page, forKey: "paperRect")
        renderer.setValue(page, forKey: "printableRect")

        // create pdf context and draw each page
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)

        for i in 0..<renderer.numberOfPages {
            UIGraphicsBeginPDFPage()
            renderer.drawPage(at: i, in: UIGraphicsGetPDFContextBounds())
        }

        UIGraphicsEndPDFContext();

        // save data to a pdf file and return
        guard nil != (try? pdfData.write(to: outputURL, options: .atomic))
            else { fatalError("Error writing PDF data to file.") }

        return pdfData as Data
    }

    private class var outputURL: URL {

        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            else { fatalError("Error getting user's document directory.") }

        let url = directory.appendingPathComponent(outputFileName).appendingPathExtension("pdf")
        print("open \(url.path)")
        return url
    }

    private class var outputFileName: String {
        return "generated-\(Int(Date().timeIntervalSince1970))"
    }
}
