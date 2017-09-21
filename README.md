# HTMLWithImagesToPDF

## Description

This app showcases the following:

1. Loading an HTML file into a web view (actually both a `WKWebView` and `UIWebView`),
2. Generating a PDF using either
   1. the web views' `viewPrintFormatter()` or
   2. a `UIMarkupTextPrintFormatter`,
3. Printing a PDF using either
   1. one of the web views' `viewPrintFormatter()` or
   2. a `UIMarkupTextPrintFormatter`


## Bug

Generating a PDF using a `UIMarkupTextPrintFormatter` will not render the images of the HTML file. Unless the HTML code has been loaded into a web view beforehand.

1. Run the application.
2. Tap `Create PDF` and then `UIMarkupTextPrintFormatter`: a PDF is generated from the `index.html` file and loaded into both a `WKWebView` and a `UIWebView`. Images are not rendered.
3. Tap `Load HTML` and then `index-img.html`: the HTML code is loaded into both web views and the images are displayed. The HTML code is not the same as the one we used to generate our PDF (**but the `img` tags are the same**).
7. Re-do step 1: tap `Create PDF` and then `UIMarkupTextPrintFormatter`: another PDF is generated and loaded into the web views. And this time **with** images.

This behavior tells me that `UIMarkupTextPrintFormatter` does support `img` tags. Also confirmed by the fact that `Print PDF` > `UIMarkupTextPrintFormatter` shows a PDF with images (actually only one image is displayed).

## Note

The `Create PDF` > `WebView.viewPrintFormatter()` action creates a PDF from what each web view is **currently** displaying, that can either be nothing, one of the HTML loaded beforehand or a PDF loaded from a previous execution.

The `Create PDF` > `UIMarkupTextPrintFormatter` action always creates the PDF from the `index.html` file.