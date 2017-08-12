//
//  ViewController.swift
//  HTMLWithImagesToPDF
//
//  Created by user on 11.08.17.
//  Copyright © 2017 nyg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var wkWebView: WKWebViewWrapper!
    @IBOutlet weak var uiWebView: UIWebView!

    // MARK: IBActions

    /**
     Load either the index.html or index-img.html into both web views.
     */
    @IBAction func loadHTML() {

        func generateAndLoad(_ fileName: String) {
            let html = generateHTML(withName: fileName)
            uiWebView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
            wkWebView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
        }

        let alertController = UIAlertController(title: "Load HTML file", message: "Which HTML file should be loaded into the web views?", preferredStyle: .actionSheet)

        alertController.addAction(title: "index.html") { action in
            generateAndLoad("index")
        }

        alertController.addAction(title: "index-img.html") { action in
            generateAndLoad("index-img")
        }

        alertController.addAction(title: "Cancel", style: .cancel)

        present(alertController, animated: true)
    }

    /**
     Allows the creation of a PDF from different sources:
       1. what is currently displayed in the web views
       2. the index.html file

     The resulting PDFs are displayed in the web views.
    */
    @IBAction func createPDF() {

        let alertController = UIAlertController(title: "Create PDF", message: "Choose the UIPrintFormatter that should be given to the UIPrintPageRenderer to create the PDF.", preferredStyle: .actionSheet)

        alertController.addAction(title: "WebView.viewPrintFormatter()") { action in

            let wkPDF = self.generatePDF(printFormatter: self.wkWebViewPrintFormatter())
            self.loadIntoWKWebView(wkPDF.1)

            let uiPDF = self.generatePDF(printFormatter: self.uiWebViewPrintFormatter())
            self.loadIntoUIWebView(uiPDF.1)
        }

        alertController.addAction(title: "UIMarkupTextPrintFormatter") { action in
            let file = self.generatePDF(printFormatter: self.markupTextPrintFormatter())
            self.loadIntoWKWebView(file.1)
            self.loadIntoUIWebView(file.1)
        }

        alertController.addAction(title: "Cancel", style: .cancel)

        present(alertController, animated: true)
    }

    /**
     Shows the print controller.
     */
    @IBAction func printPDF() {

        let alertController = UIAlertController(title: "Print PDF", message: "Choose the UIPrintFormatter to be used by the UIPrintInteractionController.", preferredStyle: .actionSheet)
        let printController = UIPrintInteractionController.shared

        func presentPrintController() {
            printController.present(animated: true) { (controller, completed, error) in
                print(error ?? "Print controller presented.")
            }
        }

        alertController.addAction(title: "UIWebView.viewPrintFormatter()", style: .default) { action in
            printController.printFormatter = self.uiWebViewPrintFormatter()
            presentPrintController()
        }

        alertController.addAction(title: "WKWebView.viewPrintFormatter()", style: .default) { action in
            printController.printFormatter = self.wkWebViewPrintFormatter()
            presentPrintController()
        }

        alertController.addAction(title: "UIMarkupTextPrintFormatter", style: .default) { action in
            printController.printFormatter = self.markupTextPrintFormatter()
            presentPrintController()
        }

        alertController.addAction(title: "Cancel", style: .cancel)

        present(alertController, animated: true)
    }

    // MARK: Private methods

    /**
     Generates the HTML string to be given to either one of the web views or the UIMarkupTextPrintFormatter.
     */
    private func generateHTML(withName fileName: String) -> String {

        // get index.html file path
        guard let path = Bundle.main.path(forResource: fileName, ofType: "html")
            else { fatalError("Error locating HTML file.") }

        // get file content as string
        guard var html = try? String(contentsOfFile: path)
            else { fatalError("Error getting HTML file content.") }

        // get absolute path of apple.png image and insert it into the html code
        guard let imgPath = Bundle.main.path(forResource: "apple", ofType: "png")
            else { fatalError("Error locating image file.") }

        html = html.replacingOccurrences(of: "{{ABS_PATH}}", with: imgPath.description)

        // create base64 encoded string of apple image (located in Assets.xcassets)
        guard let base64 = UIImagePNGRepresentation(#imageLiteral(resourceName: "apple"))?.base64EncodedString()
            else { fatalError("Error creating PNG representation.") }

        // update html with base64 encoded string and return
        return html.replacingOccurrences(of: "{{BASE64_IMG}}", with: base64)
    }

    /**
     Generates a PDF using the given print formatter.
     */
    private func generatePDF(printFormatter: UIPrintFormatter) -> (URL, Data) {

        // assign the print formatter to the print page renderer
        let renderer = UIPrintPageRenderer()
        renderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)

        // assign paperRect and printableRect values
        let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
        let printable = page.insetBy(dx: 0, dy: 0)

        renderer.setValue(NSValue(cgRect: page), forKey: "paperRect")
        renderer.setValue(NSValue(cgRect: printable), forKey: "printableRect")

        // create pdf context and draw each page
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)

        for i in 0..<renderer.numberOfPages {
            UIGraphicsBeginPDFPage()
            renderer.drawPage(at: i, in: UIGraphicsGetPDFContextBounds())
        }

        UIGraphicsEndPDFContext();

        // save data to a pdf file and return
        guard let pdfFile = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("file.pdf")
            else { fatalError("Error getting user's document directory.") }

        guard (try? pdfData.write(to: pdfFile, options: .atomic)) != nil
            else { fatalError("Error writing PDF data to file.") }

        print(pdfFile)
        return (pdfFile, pdfData as Data)
    }

    // MARK: View controller

    override func viewDidLoad() {
        wkWebView.layer.borderWidth = 1
        uiWebView.layer.borderWidth = 1
    }

    // MARK: Helpers

    private func loadIntoUIWebView(_ data: Data) {
        uiWebView.load(data, mimeType: "application/pdf", textEncodingName: "utf-8", baseURL: Bundle.main.bundleURL)
    }

    private func loadIntoWKWebView(_ data: Data) {
        wkWebView.load(data, mimeType: "application/pdf", characterEncodingName: "utf-8", baseURL: Bundle.main.bundleURL)
    }

    private func uiWebViewPrintFormatter() -> UIPrintFormatter {
        return uiWebView.viewPrintFormatter()
    }

    private func wkWebViewPrintFormatter() -> UIPrintFormatter {
        return wkWebView.viewPrintFormatter()
    }

    private func markupTextPrintFormatter() -> UIPrintFormatter {
        return UIMarkupTextPrintFormatter(markupText: generateHTML(withName: "index"))
    }
}
