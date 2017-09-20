//
//  ViewController.swift
//  HTMLWithImagesToPDF
//
//  Created by user on 11.08.17.
//  Copyright © 2017 nyg. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var wkWebView: WKWebView!
    @IBOutlet weak var uiWebView: UIWebView!

    // MARK: IBActions

    /**
     Loads either the index.html or index-img.html into both web views.
     */
    @IBAction func loadHTML() {

        func generateAndLoad(action: UIAlertAction) {
            let html = HTML.get(from: action.title!)
            uiWebView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
            wkWebView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
        }

        UIAlertController(title: "Load HTML file", message: "Which HTML file should be loaded into the web views?", preferredStyle: .actionSheet)
            .addAction(title: "index.html", handler: generateAndLoad)
            .addAction(title: "index-img.html", handler: generateAndLoad)
            .addAction(title: "Cancel", style: .cancel)
            .present(by: self)
    }

    /**
     Creates a PDF from one of the following sources:
       - what is currently being displayed in the web views,
       - the content of the index.html file.

     The resulting PDF is displayed into both web views.
    */
    @IBAction func createPDF() {

        UIAlertController(title: "Create PDF", message: "Choose the UIPrintFormatter that should be given to the UIPrintPageRenderer to create the PDF.", preferredStyle: .actionSheet)
            .addAction(title: "WebView.viewPrintFormatter()") { action in

                let wkPDFData = PDF.generate(using: self.wkWebViewPrintFormatter())
                self.loadIntoWKWebView(wkPDFData)

                let uiPDFData = PDF.generate(using: self.uiWebViewPrintFormatter())
                self.loadIntoUIWebView(uiPDFData)
            }
            .addAction(title: "UIMarkupTextPrintFormatter") { action in
                let data = PDF.generate(using: self.markupTextPrintFormatter())
                self.loadIntoWKWebView(data)
                self.loadIntoUIWebView(data)
            }
            .addAction(title: "Cancel", style: .cancel)
            .present(by: self)
    }

    /**
     Presents the print controller using one of the three following print formatters:
       - `WKWebView`'s print formatter
       - `UIWebView`'s print formatter
       - `UIMarkupTextPrintFormatter` (using the `index.html` file)
     */
    @IBAction func printPDF() {

        let printController = UIPrintInteractionController.shared

        func presentPrintController() {
            printController.present(animated: true) { (controller, completed, error) in
                print(error ?? "Print controller presented.")
            }
        }

        UIAlertController(title: "Print PDF", message: "Choose the UIPrintFormatter to be used by the UIPrintInteractionController.", preferredStyle: .actionSheet)
            .addAction(title: "WKWebView.viewPrintFormatter()") { action in
                printController.printFormatter = self.wkWebViewPrintFormatter()
                presentPrintController()
            }
            .addAction(title: "UIWebView.viewPrintFormatter()") { action in
                printController.printFormatter = self.uiWebViewPrintFormatter()
                presentPrintController()
            }
            .addAction(title: "UIMarkupTextPrintFormatter") { action in
                printController.printFormatter = self.markupTextPrintFormatter()
                presentPrintController()
            }
            .addAction(title: "Cancel", style: .cancel)
            .present(by: self)
    }

    // MARK: Helpers

    private func loadIntoWKWebView(_ data: Data) {
        wkWebView.load(data, mimeType: "application/pdf", characterEncodingName: "utf-8", baseURL: Bundle.main.bundleURL)
    }

    private func loadIntoUIWebView(_ data: Data) {
        uiWebView.load(data, mimeType: "application/pdf", textEncodingName: "utf-8", baseURL: Bundle.main.bundleURL)
    }

    private func wkWebViewPrintFormatter() -> UIPrintFormatter {
        return wkWebView.viewPrintFormatter()
    }

    private func uiWebViewPrintFormatter() -> UIPrintFormatter {
        return uiWebView.viewPrintFormatter()
    }

    private func markupTextPrintFormatter() -> UIPrintFormatter {
        return UIMarkupTextPrintFormatter(markupText: HTML.get(from: "index.html"))
    }
}
