import UIKit

///
/// Reads the given HTML file and replaces `{{ABSOLUTE_PATH}}` and `{{BASE64_STRING}}` with proper values.
///
/// - parameters:
///   - htmlFile: The HTML file.
///
/// - returns: The transformed HTML code.
func getHTML(from htmlFile: URL) -> String {

    guard let htmlContent = try? String(contentsOf: htmlFile)
        else { fatalError("Error getting HTML file content.") }

    guard let imgURL = Bundle.main.url(forResource: "apple", withExtension: "png")
        else { fatalError("Error locating image file.") }

    guard let base64String = try? Data(contentsOf: imgURL).base64EncodedString()
        else { fatalError("Error creating Base64-encoded string.") }

    return htmlContent
        .replacingOccurrences(of: "{{ABSOLUTE_PATH}}", with: imgURL.description)
        .replacingOccurrences(of: "{{BASE64_STRING}}", with: base64String)
}

///
/// Generates a PDF from the given HTML code and saves it to the given destination file.
///
/// - parameters:
///   - html: The HTML code.
///   - destination: The URL indicating where to write the generated PDF file.
///
func createPDF(with html: String, to destination: URL) {

    // create print formatter
    let printFormatter = UIMarkupTextPrintFormatter(markupText: html)

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

    // save data to file
    do {
        try pdfData.write(to: destination, options: .atomic)
        print("open \(destination.path)")
    }
    catch {
        fatalError("Error writing PDF data to file: \(error)")
    }
}

/* Generating PDF. */

guard let htmlFile = Bundle.main.url(forResource: "index", withExtension: "html")
    else { fatalError("Error locating HTML file.") }

let htmlContent = getHTML(from: htmlFile)

guard let outputURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("generated.pdf")
    else { fatalError("Error getting user's document directory.") }

createPDF(with: htmlContent, to: outputURL)
