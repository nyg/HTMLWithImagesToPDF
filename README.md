# HTMLWithImagesToPDF

## Goals

This project has two goals:

1. Showing how to convert an HTML page with images into a PDF document, using one of these three methods:
	1. `UIMarkupTextPrintFormatter`
	2. `viewPrintFormatter()` of either `WKWebView` or `UIWebView`
	3. `UIPrintInteractionController`, the PDF can then be obtain by pinching in the preview presenter by the print controller, it opens up the PDF and it can then be saved by the user. That's a UI only solution...
2. Showing that there is clearly a bug (iOS 10) when using UIMarkupTextPrintFormatter to convert an HTML containing images.

## The bug

1. Run the application.
2. Click the Create PDF button, and then choose the UIMarkupTextPrintFormatter option.
3. A PDF is generate from the index.html file and loaded into both a WKWebView (recommended by Apple with iOS 8+) and a UIWebView.
4. No images show up. Why? Is this a problem with my code?
5. Click on Load HTML and choose index-img.html. The HTML code is loaded into both web views. The HTML code is not the same as the one we used to generate our PDF.
6. All images show up, good. At least there's no problem with the HTML code.
7. Click on Create PDF and then UIMarkupTextPrintFormatter once more.
8. Yep, the PDF, created with UIMarkupTextPrintFormatter shows up with images.

This tells me two thing:

1. UIMarkupTextPrintFormatter supports img tags.
2. It somehow relies on the web view (or another WebKit class, the cache maybe) to render these images.